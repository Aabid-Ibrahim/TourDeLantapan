import 'dart:convert';
import 'package:app/models/gas_station_model.dart';
import 'package:app/models/philippines_model.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/api_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppProvider extends ChangeNotifier {
  String _loading = "stop";
  String get loading => _loading;

  List<Philippines> philippines = [];

  int _YEAR_SELECTED = DateTime.now().year;
  int get YEAR_SELECTED => _YEAR_SELECTED;

  List _QUARTER_SELECTED = [1, 3, "1st Quarter"];
  List get QUARTER_SELECTED => _QUARTER_SELECTED;

  List _MONTH_SELECTED = [1, "January"];
  List get MONTH_SELECTED => _MONTH_SELECTED;

  List _WEEK_SELECTED = [1, "Week 1"];
  List get WEEK_SELECTED => _WEEK_SELECTED;

  String _DATE_FILTER_TYPE = "Custom";
  String get DATE_FILTER_TYPE => _DATE_FILTER_TYPE;

  List<GasStation> _gasStations = [];
  List<GasStation> get gasStations => _gasStations;

  setLoading(String loading) async {
    _loading = loading;
    notifyListeners();
  }

  setYear(int year) {
    _YEAR_SELECTED = year;
    notifyListeners();
  }

  setDateFilterType(String dateFilterType) {
    _DATE_FILTER_TYPE = dateFilterType;
    notifyListeners();
  }

  setQuarter(List quarter) {
    _QUARTER_SELECTED = quarter;
    notifyListeners();
  }

  setMonth(List month) {
    _MONTH_SELECTED = month;
    notifyListeners();
  }

  setWeek(List week) {
    _WEEK_SELECTED = week;
    notifyListeners();
  }

  resetFilter() {
    _DATE_FILTER_TYPE = "Custom";
    notifyListeners();
  }

  Future<String> getPhilippinesJson() {
    return rootBundle.loadString('assets/json/philippines.json');
  }

  getPhilippines() async {
    var _philippines = json.decode(await getPhilippinesJson());
    philippines = List<Philippines>.from(
        _philippines.map((x) => Philippines.fromJson(x)));
    notifyListeners();
  }

  getGasStationList(
      {required Map<String, dynamic> query, required Function callback}) async {
    setLoading("gas-station-list");
    var response =
        await APIServices.get(endpoint: "/nearby/gas-stations", query: query);
    if (response is Success) {
      _gasStations = List<GasStation>.from(response.response["data"]
              ["gasStations"]
          .map((x) => GasStation.fromJson(x)));
      setLoading("stop");
      callback(response.code, response.response["message"] ?? "Success.");
    }
    if (response is Failure) {
      callback(response.code, response.response["message"] ?? "Failed.");
      setLoading("stop");
    }
  }
}
