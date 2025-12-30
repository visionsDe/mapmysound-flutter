import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:maymysound/dashboard/sample/view/sampleApiViewObject.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../apiServices/apiRepository.dart';
import '../../../utils/network/networkServices.dart';
import '../model/sampleApiModel.dart';
import '../model/sampleApiModelObject.dart';
import '../model/sampleStaticModel.dart';

class SampleApiViewModel extends ChangeNotifier{

  final _repo = ApiRepository();
  List<ModelSampleApi> list = [];
  List<ModelSampleApi> get data => list;
  var loader = false;


 List<SampleStaticModel> staticList = [];
 List<SampleStaticModel> get staticData => staticList;

 /// static data
  List<SampleStaticModel> staticListCopy = [];
  List<SampleStaticModel> get staticDataCopy => staticListCopy;

  /// Get object data
  SampleApiObject? info;

  final record = AudioRecorder();

  /// internet

  bool hasInternet = true;
  final NetworkService _network = NetworkService.instance;
  StreamSubscription? _netSub;

  SampleApiViewModel() {
    _listenNetwork();
  }


  void _listenNetwork() {
    _netSub = _network.onStatusChange.listen((online) {
      hasInternet = online;
      if (online && list.isEmpty) {
        getSampleApiData();
      }
      notifyListeners();
    });
  }

  Future<void> getSampleApiData() async {
    loader = true;
    notifyListeners();
    try{
     list =  await _repo.sampleApiArray();
     print("LIST DD :${jsonEncode(list)}");
      notifyListeners();
    }catch (error){
      print("ERROR IN VIEWMODEL :${error}");
      throw Exception("Error in SAMPLE VIEW MODEL");
    } finally {
      loader = false;
    }
  }


  Future<void> getSampleApiObject({id}) async {
    loader = true;
    try{
    info =  await _repo.sampleApiObject(id: id);
    notifyListeners();
    }catch(error){
      print("ERROR IN VIEWMODEL :${error}");
      throw Exception("Error in SAMPLE VIEW MODEL");
    }
    loader = false;
  }



  Future<void> setStaticData()async {
    var list = <SampleStaticModel>[];
    var model = SampleStaticModel();
    model.id = "1";
    model.surname = "surname One";
    model.name = "name one";
    model.phoneNo = "11111";

    list.add(model);


    var model1 = SampleStaticModel();
    model1.id = "2";
    model1.surname = "surname Two";
    model1.name = "name Two";
    model1.phoneNo = "22222";

    list.add(model1);

    var model2 = SampleStaticModel();
    model2.id = "3";
    model2.surname = "surname Three";
    model2.name = "name Three";
    model2.phoneNo = "33333";

    list.add(model2);


    var model3 = SampleStaticModel();
    model3.id = "4";
    model3.surname = "surname Four";
    model3.name = "name Four";
    model3.phoneNo = "44444";

    list.add(model3);

    var model4 = SampleStaticModel();
    model4.id = "5";
    model4.surname = "surname Five";
    model4.name = "name Five";
    model4.phoneNo = "55555";

    list.add(model4);

    staticList = list;
    staticListCopy = staticList;
    //notifyListeners();
  }

  Future<int> addStaticItem() async {
    var model  =  SampleStaticModel();
    model.id = "4";
    model.phoneNo = "44444";
    model.name = "name Four";
    model.surname = "surname Four";
    staticList.add(model);
    return staticList.length;


  }

  void removeItemFromList({index}) async {
    staticList.removeAt(index);
    notifyListeners();

  }

  void filterList(String value) {
    var list = <SampleStaticModel>[];
    for(var name in staticList){
      if(name.name.toLowerCase().contains(value.toLowerCase())){
        list.add(name);
      }
    }
    staticListCopy = list;
    notifyListeners();
  }


  // record audio handling


  bool isRecording = false;
  Future<void> startRecording() async {
    print("START REC");

    if (isRecording) return;

    if (!await record.hasPermission()) {
      print("Permission denied");
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await record.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
      ),
      path: path,
    );

    isRecording = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 5), () async {
      if (!isRecording) return;
      await stopRecording();
    });
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    final path = await record.stop();
    isRecording = false;
    notifyListeners();

    print("Saved at: $path");
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

}