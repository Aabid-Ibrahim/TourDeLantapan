import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

setToken(String accessToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('accessToken') ?? "";
  return token;
}

setLogInMode(String mode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('logInMode', mode);
}

Future<String> getLogInMode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('logInMode') ?? "";
  return token;
}

setOffline(String key, List<dynamic> json) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, jsonEncode(json));
}

Future<List<dynamic>?> getOfflineData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) != null
      ? jsonDecode(prefs.getString(key)!)
      : null;
}

setMappedOffline(String key, Map<String, dynamic> json) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, jsonEncode(json));
}

Future<Map<String, dynamic>?> getOfflineMappedData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) != null
      ? jsonDecode(prefs.getString(key)!)
      : null;
}
