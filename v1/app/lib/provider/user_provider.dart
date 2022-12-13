import 'dart:io';

import 'package:app/models/user_model.dart';
import 'package:app/models/visitor_model.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/api_status.dart';
import 'package:app/utilities/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  String _loading = "stop";
  String get loading => _loading;

  User? _currentUser;
  User? get currentUser => _currentUser;

  List<Visitor> _visitorList = [];
  List<Visitor> get visitorList => _visitorList;

  int _visitorCount = 0;
  int get visitorCount => _visitorCount;

  int _visitorCountInBukidnon = 0;
  int get visitorCountInBukidnon => _visitorCountInBukidnon;

  int _visitorCountOutsideBukidnon = 0;
  int get visitorCountOutsideBukidnon => _visitorCountOutsideBukidnon;

  setLoading(String loading) async {
    _loading = loading;
    notifyListeners();
  }

  setCurrentUser(User currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }

  profile({required Function callback}) async {
    var response = await APIServices.get(endpoint: "/profile");

    if (response is Success) {
      if (response.response["data"]["profile"] != null) {
        setCurrentUser(User.fromJson(response.response["data"]["profile"]));
      }
      callback(response.code, response.response["message"] ?? "Success.");
      setLoading("stop");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      setLoading("stop");
    }
  }

  login(
      {required Map<String, dynamic> payload,
      required Function callback}) async {
    setLoading("login");
    var response = await APIServices.post(endpoint: "/login", payload: payload);
    if (response is Success) {
      setLoading("stop");
      setToken(response.response["data"]["accessToken"]);
      User user = User.fromJson(response.response["data"]);
      setCurrentUser(user);
      callback(response.code, response.response["message"] ?? "Success.",
          user.scope);
    }
    if (response is Failure) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Failed.", []);
    }
  }

  signOut() {
    setToken("");
    _currentUser = null;
    notifyListeners();
  }

  signup(
      {required Map<String, dynamic> payload,
      required Function callback}) async {
    setLoading("signup");
    var response =
        await APIServices.post(endpoint: "/signup", payload: payload);
    if (response is Success) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Failed.");
    }
  }

  editProfile(
      {required Map<String, dynamic> payload,
      required Function callback,
      PlatformFile? photo}) async {
    setLoading("profile-edit");
    var response = await APIServices.post(
        endpoint: "/profile/edit",
        payload: payload,
        files: photo == null ? [] : [photo]);
    if (response is Success) {
      User user = User.fromJson(response.response["data"]["profile"]);
      setCurrentUser(user);
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Failed.");
    }
  }

  submitVisitorForm(
      {required Map<String, dynamic> payload,
      required Function callback}) async {
    setLoading("visitor-form");
    var response =
        await APIServices.post(endpoint: "/visitor/form", payload: payload);
    if (response is Success) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Failed.");
    }
  }

  getVisitors(
      {required Map<String, dynamic> query, required Function callback}) async {
    setLoading("visitor-list");
    var response =
        await APIServices.get(endpoint: "/visitor/list", query: query);
    if (response is Success) {
      _visitorList = List<Visitor>.from(response.response["data"]["visitorList"]
          .map((x) => Visitor.fromJson(x)));

      _visitorCountInBukidnon =
          response.response["data"]["visitorCountInBukidnon"];
      _visitorCountOutsideBukidnon =
          response.response["data"]["visitorCountOutsideBukidnon"];
      _visitorCount = response.response["data"]["visitorCount"];
      setLoading("stop");

      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      setLoading("stop");
    }
  }

  generatePin(
      {required Map<String, dynamic> query, required Function callback}) async {
    setLoading("generate-otp");
    var response =
        await APIServices.get(endpoint: "/generate-otp", query: query);
    if (response is Success) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      setLoading("stop");
    }
  }

  confirmPin(
      {required Map<String, dynamic> query, required Function callback}) async {
    setLoading("confirm-otp");
    var response = await APIServices.get(
        endpoint: "/confirm-otp/${query['pin']}", query: query);
    if (response is Success) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.",
          User.fromJson(response.response["data"]['profile']));
    }
    if (response is Failure) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Failed.", null);
    }
  }

  requestPasswordReset(
      {required Map<String, dynamic> query, required Function callback}) async {
    setLoading("password-reset");
    var response = await APIServices.get(
        endpoint: "/user/email-reset-password", query: query);
    if (response is Success) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      setLoading("stop");
    }
  }

  changePassword(
      {required Map<String, dynamic> payload,
      required Function callback}) async {
    setLoading("password-change");
    var response = await APIServices.post(
        endpoint: "/user/change-password", payload: payload);
    if (response is Success) {
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      setLoading("stop");
    }
  }
}
