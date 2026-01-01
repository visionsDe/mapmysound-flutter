import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecorderViewModel extends ChangeNotifier {
  final AudioRecorder recorder = AudioRecorder();
  RecordState _recordState = RecordState.stop;
  RecordState get recordState => _recordState;

  int _recordDuration = 0;
  int get recordDuration => _recordDuration;

  Timer? _timer;
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;

  Amplitude? _amplitude;
  Amplitude? get amplitude => _amplitude;

  /// for play audio
  String? recordedFilePath;
  String? recordedFilePath1Dub;
  String? recordedFilePath2Dub;
  bool isPlaying = false;
  final AudioPlayer _player = AudioPlayer();
  Duration? duration;
  Duration? position;
  StreamSubscription<Duration>? _positionSub;

  /// for set indicator
  int totalSeconds = 0;
  double progress = 0.0;
  int elapsedSeconds = 0;

  /// for range slider
  double start = 0.0;
  double end = 0.0;
  double durationRange = 0.0;

  /// For generate waveform image
  String? waveAudioPath;
  String? spectrogramAudioPath;


  RecorderViewModel() {
    _init();
  }

  void _init() {
    _recordSub = recorder.onStateChanged().listen((state) {
      _recordState = state;
      notifyListeners();

      if (state == RecordState.record) {
        _startTimer();
      } else {
        _timer?.cancel();
        _recordDuration = 0;
      }
    });

    _amplitudeSub = recorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
          _amplitude = amp;
          notifyListeners();
        });
  }



  // 🎙️ START RECORDING
  Future<void> startRecording() async {
    if (_recordState != RecordState.stop) return;

    if (!await recorder.hasPermission()) return;

    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    const config = RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1);

    await recorder.start(config, path: path);
  }

  // ⏹ STOP RECORDING
  Future<void> stopRecording() async {
    if (_recordState == RecordState.stop) return;

    final path = await recorder.stop();

    recordedFilePath = path;
    print("recordedFilePath ${recordedFilePath}");
    print("appendedAudio ${appendedAudio}");
    if (appendedAudio == null) {
      if (recordedFilePath1Dub == null) {
        recordedFilePath1Dub = recordedFilePath;
      } else {
        recordedFilePath2Dub = recordedFilePath;
      }
    } else {
      recordedFilePath1Dub = appendedAudio;
      recordedFilePath2Dub = recordedFilePath;
    }

   await getAudioDuration(recordedFilePath!);
    notifyListeners();
    print("recordedFilePath1Dub ${recordedFilePath1Dub}");
    print("recordedFilePath2Dub ${recordedFilePath2Dub}");
    notifyListeners();
    debugPrint("Saved at: $path");
  }

  Future<void> pause() => recorder.pause();

  Future<void> resume() => recorder.resume();

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _recordDuration++;
      notifyListeners();
    });
  }

  Future<void> play() async {
    if (recordedFilePath == null) return;
    print("recordedFilePath ${recordedFilePath}");
    await _player.play(DeviceFileSource(recordedFilePath!));
    isPlaying = true;
    duration = await _player.getDuration();
    print("DURATION :${duration}");
    int? value = duration?.inSeconds;
    print("DURATION :${value}");
    totalSeconds = value!;
    startTimerIndicator();
    notifyListeners();

    // Listen to playback position
    _positionSub = _player.onPositionChanged.listen((p) {
      position = p;
      notifyListeners();
    });

    _player.onPlayerComplete.listen((event) {
      isPlaying = false;
      position = duration;
      notifyListeners();
    });
  }

  /// currently not used
  /// fxn for pausing audio
  Future<void> pauseAudio() async {
    await _player.pause();
    isPlaying = false;
    notifyListeners();
  }

  /// currently not used
  /// fxn for stop audio
  Future<void> stop() async {
    await _player.stop();
    isPlaying = false;
    position = Duration.zero;
    notifyListeners();
  }

  void startTimerIndicator() {
    _timer?.cancel();
    progress = 0;
    elapsedSeconds = 0;
    notifyListeners();

    const tick = Duration(milliseconds: 100);
    final totalTicks = (totalSeconds * 1000) ~/ tick.inMilliseconds;
    int currentTick = 0;

    _timer = Timer.periodic(tick, (timer) {
      currentTick++;
      progress = currentTick / totalTicks;
      elapsedSeconds = (progress * totalSeconds).ceil();

      notifyListeners();

      if (progress >= 1.0) {
        timer.cancel();
      }
    });
  }

  void resetIndicator() {
    _timer?.cancel();
    progress = 0;
    elapsedSeconds = 0;
    notifyListeners();
  }

  /// Append Audio
  // final  String recordedFilePath1 = "/var/mobile/Containers/Data/Application/35AD79B6-BE01-4CD7-8959-0EAD9EC29849/Documents/audio_1766554145512.m4a";
  //   final String recordedFilePath2 = "/var/mobile/Containers/Data/Application/35AD79B6-BE01-4CD7-8959-0EAD9EC29849/Documents/audio_1766554162052.m4a";
  // final List<String> audioPaths = [recordedFilePath1, recordedFilePath2];

  String? appendedAudio;

  List<String?> get audioPaths => [recordedFilePath1Dub, recordedFilePath2Dub];

  Future<String?> concatenateAudio() async {
    final validPaths = audioPaths.whereType<String>().toList();
    if (validPaths.length < 2) return validPaths.first;

    final tempDir = await getTemporaryDirectory();
    final listFile = File('${tempDir.path}/inputs.txt');

    final buffer = StringBuffer();
    for (final path in validPaths) {
      buffer.writeln("file '$path'");
    }
    await listFile.writeAsString(buffer.toString());

    final outputDir = await getApplicationDocumentsDirectory();
    final outputPath =
        '${outputDir.path}/appended_${DateTime.now().millisecondsSinceEpoch}.m4a';

    final command =
        "-f concat -safe 0 -i ${listFile.path} "
        "-c:a aac -b:a 128k -ar 44100 -ac 1 "
        "-movflags +faststart "
        "$outputPath";

    final session = await FFmpegKit.execute(command);
    final rc = await session.getReturnCode();

    if (rc?.isValueSuccess() == true) {
      appendedAudio = outputPath;
      recordedFilePath = outputPath;
      print("appendedAudio $appendedAudio");
      // IMPORTANT: reset dub paths

      recordedFilePath1Dub = outputPath;
      recordedFilePath2Dub = null;

      return outputPath;
    }

    return null;
  }

  /// play multi-audio same time

  // final String recordedFilePath1 =
  //     "/var/mobile/Containers/Data/Application/35AD79B6-BE01-4CD7-8959-0EAD9EC29849/Documents/audio_1766554145512.m4a";
  // final String recordedFilePath2 =
  //     "/var/mobile/Containers/Data/Application/35AD79B6-BE01-4CD7-8959-0EAD9EC29849/Documents/audio_1766554162052.m4a";

  Future<String?> mixAudios() async {
    if (recordedFilePath1Dub == null || recordedFilePath2Dub == null) {
      print("No valid audio files found.");
      return null;
    }

    final docsDir = await getApplicationDocumentsDirectory();
   // final outputPath = '${docsDir.path}/mixed_audio.m4a';
    final outputPath =
        '${docsDir.path}/mixed_audio_${DateTime.now().millisecondsSinceEpoch}.m4a';


    // Remove existing file
    final outputFile = File(outputPath);
    if (outputFile.existsSync()) {
      outputFile.deleteSync();
    }

    final command =
        '-i "$recordedFilePath1Dub" '
        '-i "$recordedFilePath2Dub" '
        '-filter_complex "[0:a][1:a]amix=inputs=2:duration=longest:dropout_transition=0" '
        '-acodec aac -ar 44100 -ac 2 '
        '"$outputPath"';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (returnCode?.isValueSuccess() == true) {
      recordedFilePath1Dub = outputPath;
      recordedFilePath = outputPath;
      recordedFilePath2Dub = null;


      print("Mixed audio created at: $outputPath");
      print("recordedFilePath $recordedFilePath");
      return outputPath;
    } else {
      final logs = await session.getAllLogsAsString();
      print("FFmpeg mix error:\n$logs");
      return null;
    }
  }

  /// trim section


  String format(double seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toInt();
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  void updateStartEnd({
    required double start,
    required double end,
  }) {
    stop();
    this.start = start;
    this.end = end;
    print("Start END ${this.start} , ${this.end}");

    notifyListeners();
    // trimAudio();
  }

  void trimAudio() async {
    print("trimAudio start ${start}");
    print(" trimAudio end ${end}");
    final outputPath =
        "${recordedFilePath?.replaceAll('.m4a', '_trimmed.m4a')}";

    final cmd =
        "-y -i \"${recordedFilePath}\" -ss $start -to $end "
        "-ar 16000 -ac 2 -b:a 96k \"$outputPath\"";

    await FFmpegKit.executeAsync(cmd, (session) async {
      final rc = await session.getReturnCode();
      if (ReturnCode.isSuccess(rc)) {
        debugPrint("Trim success: $outputPath");
        print("outputPath Trimed ${outputPath}");
        recordedFilePath = outputPath;
       // getAudioDuration(outputPath);
      } else {
        debugPrint("Trim failed: $rc");
      }
    });
  }

   getAudioDuration(String path) async {
    final session = await FFprobeKit.getMediaInformation(path);
    final info = session.getMediaInformation();
    final durationStr = info?.getDuration();

    if (durationStr == null) return 0.0;
    print("durationStr :${durationStr}");
    durationRange = double.parse(durationStr);
    start = 0.0;
    end = double.parse(durationStr);
    print("duration :${durationRange}");
   // trimAudio();
    notifyListeners();
  //  return double.parse(durationStr); // seconds
  }


  Future<void> playSelectedRange() async {
    if (recordedFilePath == null) return;

    final startMs = (start * 1000).toInt();
    final endMs = (end * 1000).toInt();

    print("SELECTED RANGE START END $startMs , $endMs");

    //  Stop anything playing
    await _player.stop();

    // Load & start playing (required before seek)
    await _player.play(
      DeviceFileSource(recordedFilePath!),
      position: Duration(milliseconds: startMs), // 👈 BEST WAY
    );

    isPlaying = true;
    notifyListeners();

    // 3️⃣ Stop at selected end
    _positionSub?.cancel();
    _positionSub = _player.onPositionChanged.listen((position) {
      if (position.inMilliseconds >= endMs) {
        _player.stop();
        isPlaying = false;
        notifyListeners();
      }
    });
  }

  /// generate a wave from path of audio

  Future<String?> generateWaveformImage(String audioPath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final outputPath =
        '${docsDir.path}/waveform_${DateTime.now().millisecondsSinceEpoch}.png';

    // FFmpeg command to generate waveform image
    // final commandWORKING =
    //     '-y -i "$audioPath" -filter_complex "aformat=channel_layouts=mono,showwavespic=s=640x120" "$outputPath"';
    final commandN =
        '-y -i "$audioPath" '
        '-filter_complex "aformat=channel_layouts=mono,showwavespic=s=800x200:scale=lin" '
        '"$outputPath"';
    // final command =
    //     '-y -i "input.m4a" '
    //     '-filter_complex "volume=6dB,aformat=channel_layouts=mono,showwavespic=s=400x400:drawstyle=bars:scale=lin" '
    //     '"waveform.png"';


    final session = await FFmpegKit.execute(commandN);
    final rc = await session.getReturnCode();

    if (rc?.isValueSuccess() == true) {
      print("Waveform image generated at: $outputPath");
      waveAudioPath = outputPath;
      notifyListeners();
      return outputPath;

      // waveform image generated
    } else {
      final logs = await session.getAllLogsAsString();
      print("FFmpeg waveform error: $logs");
      return null;
    }
  }

  Future<String?> generateSpectrogram(String audioPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final outputPath =
        '${dir.path}/spectrogram_${DateTime.now().millisecondsSinceEpoch}.png';

    final commandNewOne =
        '-y -i "$audioPath" '
        '-lavfi showspectrumpic=s=800x400 '
        '"$outputPath"';


    final commandOkWithBlack =
        '-y -i "$audioPath" '
        '-lavfi showspectrumpic=s=800x400 '
        '"$outputPath"';

    final commandWithBlackNew =
        '-y -i "$audioPath" '
        '-lavfi showspectrumpic=s=800x400:legend=disabled '
        '"$outputPath"';

    // final command =
    //     '-y -i "$audioPath" '
    //     '-lavfi '
    //     '"showspectrumpic='
    //     's=800x400:'
    //     'legend=disabled:'
    //     'color=rainbow,'
    //     'format=rgba" '
    //     '"$outputPath"';

    final commandWithoutBackground =
        '-y -i "$audioPath" '
        '-lavfi '
        '"showspectrumpic=s=800x400:legend=disabled,format=rgba" '
        '"$outputPath"';


    final command =
        '-y -i "$audioPath" '
        '-lavfi "'
        'showspectrumpic=s=800x400:legend=disabled,'
        'format=rgba,'
        "drawtext=text='Time (s)':x=(w/2)-40:y=h-20:fontsize=16:fontcolor=white,"
        "drawtext=text='Frequency (Hz)':x=10:y=10:fontsize=16:fontcolor=white"
        '" '
        '"$outputPath"';

    final session = await FFmpegKit.execute(commandNewOne);
    final rc = await session.getReturnCode();

    if (rc?.isValueSuccess() == true) {
      debugPrint('Spectrogram generated at $outputPath');
      spectrogramAudioPath = outputPath;
      notifyListeners();
      return outputPath;
    } else {
      debugPrint(await session.getAllLogsAsString());
      return null;
    }
  }









  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    recorder.dispose();
    _player.dispose();
    _positionSub?.cancel();
    super.dispose();
  }

  void resetSavedData() {
    recordedFilePath = null;
    isPlaying = false;
    position = Duration.zero;
    progress = 0.0;
    elapsedSeconds = 0;
    _amplitude = null;
    totalSeconds = 0;
    notifyListeners();
  }
}
