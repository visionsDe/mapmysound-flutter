
import 'dart:developer';
import '../dashboard/sample/model/sampleApiModel.dart';
import '../dashboard/sample/model/sampleApiModelObject.dart';
import 'apiServices.dart';

class ApiRepository{
  final _apiSer = ApiServices();

  /// for array
  Future<List<ModelSampleApi>> sampleApiArray() async {
    final res = await _apiSer.getSampleApiArray();
    if(res.statusCode == 200) {
      log("RES BODY : ${res.body}");
      return modelSampleApiFromJson(res.body);

    }else {
      print("ERROR");
      throw Exception('Error In API');
    }
  }

  /// for object

  Future<SampleApiObject> sampleApiObject({id})async{
    final res = await _apiSer.getSampleApiObject(id: id);
    print("RES BODY 2 : ${res.body}");
    print("RES BODY 2: ${res.statusCode}");
    if(res.statusCode == 200){
      return sampleApiObjectFromJson(res.body);
    }else {
      print("ERROR 2 ");
      throw Exception('Error In API 2');
    }

  }
}