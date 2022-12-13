import 'package:app/models/dashboard/dashboard_count.dart';
import 'package:app/models/dashboard/dashboard_like.dart';
import 'package:app/models/dashboard/dashboard_rating.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/api_status.dart';
import 'package:flutter/cupertino.dart';

class DashboardProvider extends ChangeNotifier {
  List<String> _loading = [];
  List<String> get loading => _loading;

  DashboardCount _dashboardCount = DashboardCount(
      totalUsers: 0,
      totalPlaces: 0,
      totalPlacesByCategory: [TotalPlacesByCategory(id: "nodata", count: 0)]);
  DashboardCount get dashboardCount => _dashboardCount;

  List<DashboardLikes> _dashboardLikes = [];
  List<DashboardLikes> get dashboardLikes => _dashboardLikes;

  List<DashboardRating> _dashboardRating = [];
  List<DashboardRating> get dashboardRating => _dashboardRating;

  addLoading(String loading) {
    _loading.add(loading);
    notifyListeners();
  }

  removeLoading(String loading) {
    _loading.removeWhere((e) => e == loading);
    notifyListeners();
  }

  getCount({required Function callback}) async {
    addLoading("count");
    var response = await APIServices.get(endpoint: "/admin/dashboard/count");
    if (response is Success) {
      _dashboardCount = DashboardCount.fromJson(response.response["data"]);
      removeLoading("count");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      removeLoading("count");
    }
  }

  getLikesCount(
      {required Map<String, dynamic> query, required Function callback}) async {
    addLoading("likes");
    var response =
        await APIServices.get(endpoint: "/admin/dashboard/likes", query: query);
    if (response is Success) {
      _dashboardLikes = List<DashboardLikes>.from(response.response["data"]
              ["likesCount"]
          .map((x) => DashboardLikes.fromJson(x)));
      removeLoading("likes");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      removeLoading("likes");
    }
  }

  getRatingsCount(
      {required Map<String, dynamic> query, required Function callback}) async {
    addLoading("ratings");
    var response = await APIServices.get(
        endpoint: "/admin/dashboard/ratings", query: query);
    if (response is Success) {
      _dashboardRating = List<DashboardRating>.from(response.response["data"]
              ["ratingsCount"]
          .map((x) => DashboardRating.fromJson(x)));
      removeLoading("ratings");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      removeLoading("ratings");
    }
  }
}
