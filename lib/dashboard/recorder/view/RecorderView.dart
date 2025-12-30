import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maymysound/utils/appColors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import '../../../utils/trachThumb.dart';
import '../viewmodel/RecorderViewModel.dart';

class RecorderView extends StatelessWidget {
  const RecorderView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => RecorderViewModel(),
      child: Consumer<RecorderViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _recordButton(vm),
                  const SizedBox(height: 20),
                  _pauseResume(vm),
                  const SizedBox(height: 20),
                  _timer(vm),
                  if (vm.amplitude != null) ...[
                    const SizedBox(height: 20),
                    Text('Amp: ${vm.amplitude!.current.toStringAsFixed(2)}'),
                  ],
                  //  if (vm.recordedFilePath != null)
                  Column(
                    children: [
                      // ElevatedButton.icon(
                      //   onPressed: vm.play,
                      //   icon: const Icon(Icons.play_arrow),
                      //   label: const Text('Play Recorded Audio'),
                      // ),

                      // new CircularPercentIndicator(
                      //   radius: 60.0,
                      //   lineWidth: 5.0,
                      //   percent: vm.progress.clamp(0.0, 1.0),
                      //   center: new Text("100%"),
                      //   progressColor: Colors.green,
                      // )
                      CircularPercentIndicator(
                        radius: 40,
                        lineWidth: 5,
                        percent: vm.progress.clamp(0.0, 1.0),
                        animation: true,
                        animateFromLastPercent: true,
                        center: vm.isPlaying
                            ? Icon(Icons.pause, size: 36)
                            : IconButton(
                                onPressed: () {
                                  vm.play();
                                },
                                icon: Icon(Icons.play_arrow, size: 36),
                              ),
                        progressColor: Colors.blue,
                        backgroundColor: Colors.grey.shade300,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),

                      IconButton(
                        onPressed: () {
                          vm.resetSavedData();
                        },
                        icon: Icon(Icons.delete, size: 36),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      vm.concatenateAudio();
                    },
                    child: Text("Append Audio"),
                  ),
                  TextButton(
                    onPressed: () {
                      vm.mixAudios();
                    },
                    child: Text("Mix Audio"),
                  ),
                  if (vm.durationRange != 0.0 && vm.durationRange > 1.0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double start = vm.start / vm.durationRange;
                            final double end = vm.end / vm.durationRange;

                            return Stack(
                              children: [
                                /// SVG with range-based color
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      stops: [0.0, start, start, end, end, 1.0],
                                      colors: [
                                        AppColors.textSecondary,
                                        AppColors.textSecondary,
                                        AppColors.primary, // inside range
                                        AppColors.primary, // inside range
                                        AppColors.textSecondary,
                                        AppColors.textSecondary,
                                      ],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcIn,
                                  child: SvgPicture.asset(
                                    "assets/images/voice.svg",
                                    fit: BoxFit.fill,
                                    color: Colors.white, // REQUIRED
                                  ),
                                ),

                                /// Range Slider
                                Positioned.fill(
                                  child:
                                  SliderTheme(
                                    data:
                                    SliderTheme.of(context).copyWith(
                                      trackHeight: 0,
                                       rangeTrackShape: GappedRangeSliderTrackShape(),
                                   //   rangeTrackShape: const RectangularRangeSliderTrackShape(),
                                      mouseCursor: MaterialStateProperty.all(
                                        SystemMouseCursors.alias,
                                      ),

                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                    ),
                                    child: RangeSlider(
                                      values: RangeValues(
                                        vm.start.clamp(0, vm.durationRange),
                                        vm.end.clamp(0, vm.durationRange),
                                      ),
                                      labels: RangeLabels(
                                        vm.format(vm.start),
                                        vm.format(vm.end),
                                      ),
                                      min: 0,
                                      max: vm.durationRange,
                                      activeColor: AppColors.primary,
                                      inactiveColor: AppColors.transparent,
                                      onChanged: (values) {
                                        vm.updateStartEnd(
                                          start: values.start,
                                          end: values.end,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  if (vm.durationRange != 0.0)
                    TextButton(
                      onPressed: () {
                        vm.playSelectedRange();
                        // vm.play();
                      },
                      child: Text("Play Selected Range"),
                    ),

                  if (vm.durationRange != 0.0)
                    TextButton(
                      onPressed: () {
                        vm.trimAudio();
                      },
                      child: Text("Trim Audio"),
                    ),

                  /// waveform image
                  // if (vm.durationRange != 0.0)
                  //   TextButton(
                  //     onPressed: () {
                  //       vm.generateWaveformImage(
                  //         vm.recordedFilePath.toString(),
                  //       );
                  //     },
                  //     child: Text("Generate Waveform"),
                  //   ),

                  // if (vm.waveAudioPath != null)
                  //   Stack(
                  //     children: [
                  //       // Waveform image
                  //       Container(
                  //        // height: 200,
                  //         color: AppColors.secondary,
                  //         child: Image.file(
                  //           File(vm.waveAudioPath!),
                  //           width: double.infinity,
                  //           //height: 200,
                  //           color: AppColors.primary,
                  //           fit: BoxFit.fill,
                  //         ),
                  //       ),
                  //
                  //       // Progress indicator
                  //       Positioned.fill(
                  //         child: Align(
                  //           alignment: Alignment.topLeft,
                  //           child: FractionallySizedBox(
                  //             widthFactor: vm.progress, // 0.0 - 1.0
                  //             child: Container(
                  //               height: 00,
                  //               color: Colors.blue.withOpacity(0.3),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       // Trim range slider overlay
                  //       Positioned.fill(
                  //         child: RangeSlider(
                  //           activeColor: AppColors.transparent,
                  //           inactiveColor: AppColors.transparent,
                  //           values: RangeValues(vm.start, vm.end),
                  //           min: 0,
                  //           max: vm.durationRange,
                  //           onChanged: (values) => vm.updateStartEnd(
                  //             start: values.start,
                  //             end: values.end,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ///
                  // if (vm.recordedFilePath != null && vm.isPlaying)
                  // AudioWaveforms(
                  //   enableGesture: true,
                  //   size: Size(
                  //       MediaQuery.of(context).size.width / 2,
                  //       50),
                  //   recorderController: vm.recorderController,
                  //   waveStyle: const WaveStyle(
                  //     waveColor: Colors.white,
                  //
                  //     extendWaveform: true,
                  //     showMiddleLine: false,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(12.0),
                  //     color: const Color(0xFF1E1B26),
                  //   ),
                  //   padding: const EdgeInsets.only(left: 18),
                  //   margin: const EdgeInsets.symmetric(
                  //       horizontal: 15),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _recordButton(RecorderViewModel vm) {
    final isRecording = vm.recordState != RecordState.stop;

    return IconButton(
      iconSize: 64,
      icon: Icon(isRecording ? Icons.stop : Icons.mic, color: Colors.red),
      onPressed: () {
        isRecording ? vm.stopRecording() : vm.startRecording();
      },
    );
  }

  Widget _pauseResume(RecorderViewModel vm) {
    if (vm.recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    return IconButton(
      iconSize: 48,
      icon: Icon(
        vm.recordState == RecordState.pause ? Icons.play_arrow : Icons.pause,
      ),
      onPressed: () {
        vm.recordState == RecordState.pause ? vm.resume() : vm.pause();
      },
    );
  }

  Widget _timer(RecorderViewModel vm) {
    if (vm.recordState == RecordState.stop) {
      return const Text("Waiting to record Audio");
    }

    final min = (vm.recordDuration ~/ 60).toString().padLeft(2, '0');
    final sec = (vm.recordDuration % 60).toString().padLeft(2, '0');

    return Text(
      '$min : $sec',
      style: const TextStyle(color: Colors.red, fontSize: 18),
    );
  }
}
