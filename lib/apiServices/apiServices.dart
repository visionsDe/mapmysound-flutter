import 'package:http/http.dart' as http;

class ApiServices{
   final url = "https://fake-json-api.mock.beeceptor.com/companies";
   final urlForGetObject = "https://fake-json-api.mock.beeceptor.com/companies/";

   Future<http.Response> getSampleApiArray() async{
     return await http.get(Uri.parse(url));
   }

   Future<http.Response> getSampleApiObject({id}) async {
     return await http.get(Uri.parse("${urlForGetObject}${id}"));
   }

}