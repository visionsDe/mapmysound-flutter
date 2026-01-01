import 'dart:io';
import 'dart:math' hide log;
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiServices{
   final url = "https://fake-json-api.mock.beeceptor.com/companies";
   final urlForGetObject = "https://fake-json-api.mock.beeceptor.com/companies/";
   final multiPart = "https://httpbin.org/post";

   Future<http.Response> getSampleApiArray() async{
     return await http.get(Uri.parse(url));
   }

   Future<http.Response> getSampleApiObject({id}) async {
     return await http.get(Uri.parse("${urlForGetObject}${id}"));
   }

   Future<http.StreamedResponse> uploadImageMultipart({
     required File imageFile,
     required String name,
     required String phone,
   }) async {
     final request =
     http.MultipartRequest('POST', Uri.parse("${multiPart}"));

     // Add params
     request.fields["name"]= name;
     request.fields["phone"]= phone;

     request.files.add(
       http.MultipartFile(
         'file',
         imageFile.readAsBytes().asStream(),
         imageFile.lengthSync(),
         filename: imageFile.path.split('/').last,
       ),
     );
    // var res = await request.send();
    //
    //
    //   log(" request.send() ${res}");

     return await request.send();
   }

}