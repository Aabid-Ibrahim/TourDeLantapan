import 'dart:convert';
import 'dart:io';
import 'package:app/services/api_status.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class APIServices {
  static Future<Object> get(
      {required String endpoint, Map<String, dynamic>? query}) async {
    try {
      String token = await getToken();
      var url = Uri.parse("$BASE_URL$endpoint").replace(queryParameters: query);
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });
      if ([200, 201].contains(response.statusCode)) {
        return Success(
            code: response.statusCode, response: jsonDecode(response.body));
      } else {
        return Failure(
            code: response.statusCode, response: jsonDecode(response.body));
      }
    } on HttpException {
      return Failure(code: 101, response: {"message": 'No Internet'});
    } on FormatException {
      return Failure(code: 102, response: {"message": 'Invalid Format'});
    } catch (e) {
      print("GET: ERROR");
      print(e);
      return Failure(code: 103, response: {"message": 'Unknown Error'});
    }
  }

  static Future<Object> post(
      {required String endpoint,
      required Map<String, dynamic> payload,
      List<PlatformFile>? files}) async {
    try {
      String token = await getToken();
      var url = Uri.parse("$BASE_URL$endpoint");

      var response;

      if (files == null) {
        response = await http
            .post(url, body: jsonEncode(payload), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });
      } else {
        var request = http.MultipartRequest("POST", url);
        request.headers['Authorization'] = 'Bearer $token';
        payload.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        files.forEach((e) {
          request.files.add(http.MultipartFile.fromBytes('photos',
              !kIsWeb ? File(e.path!).readAsBytesSync() : e.bytes!.toList(),
              filename: e.name, contentType: MediaType('image', 'jpeg')));
        });
        response = await http.Response.fromStream(await request.send());
      }

      if (response.statusCode == 200) {
        return Success(code: 200, response: jsonDecode(response.body));
      } else {
        return Failure(
            code: response.statusCode, response: jsonDecode(response.body));
      }
    } on HttpException {
      return Failure(code: 101, response: {"message": 'No Internet'});
    } on FormatException {
      return Failure(code: 102, response: {"message": 'Invalid Format'});
    } catch (e) {
      print("API SERVICE ERROR");
      print(e);
      return Failure(code: 103, response: {"message": 'Unknown Error'});
    }
  }
}
