import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/response.dart';
import '../model/response.dart';
import '../model/response.dart';

class ApiService {
  String baseUrl = "http://www.mocky.io/v2/5dfccffc310000efc8d2c1ad";

  var client = http.Client();

  List<Items> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Items>((json) => Items.fromJson(json)).toList();
  }

  static const Map<String, String> jsonHeader = {
    'Accept': 'application/json',
  };          List<TableMenuList> tableMenu = [];



  Future<List<Items>> getResponse() async {

    try {
      var response = await client.get(
        Uri.parse(baseUrl),
        headers: jsonHeader,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonBody = parseProducts(response.body);

        return jsonBody;
      }
    } catch (e) {
      print("error=$e");
    }
    throw Exception();
  }
}
