import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../dashboard/sample/model/sampleApiModel.dart';
import '../dashboard/sample/model/sampleApiModelObject.dart';
import 'apiServices.dart';

class ApiRepository {
  final _apiSer = ApiServices();

  /// for array
  Future<List<ModelSampleApi>> sampleApiArray() async {
    final res = await _apiSer.getSampleApiArray();
    if (res.statusCode == 200) {
      log("RES BODY : ${res.body}");
      return modelSampleApiFromJson(res.body);
    } else {
      print("ERROR");
      throw Exception('Error In API');
    }
  }

  /// for object

  Future<SampleApiObject> sampleApiObject({id}) async {
    final res = await _apiSer.getSampleApiObject(id: id);
    print("RES BODY 2 : ${res.body}");
    print("RES BODY 2: ${res.statusCode}");
    if (res.statusCode == 200) {
      return sampleApiObjectFromJson(res.body);
    } else {
      print("ERROR 2 ");
      throw Exception('Error In API 2');
    }
  }

  /// Multipart API
  Future<Map<String, dynamic>> uploadImage({
    required File image,
    required String name,
    required String phone,
  }) async {
    final response = await _apiSer.uploadImageMultipart(
      imageFile: image,
      name: name,
      phone: phone,
    );
    print("RESPONSE ${response.statusCode}");
    final responseBody = await response.stream.bytesToString();
    log("responseBody ${responseBody}");
    print("RESPONSE ${jsonDecode(responseBody)}");
    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception("Upload failed ${response.statusCode}: $responseBody");
    }
  }
}
