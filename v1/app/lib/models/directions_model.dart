// To parse this JSON data, do
//
//     final directions = directionsFromJson(jsonString);

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Directions directionsFromJson(String str) =>
    Directions.fromJson(json.decode(str));

String directionsToJson(Directions data) => json.encode(data.toJson());

class Directions {
  Directions({
    required this.routes,
    required this.waypoints,
    required this.code,
    required this.uuid,
  });

  List<Route> routes;
  List<Waypoint> waypoints;
  String code;
  String uuid;

  factory Directions.fromJson(Map<String, dynamic> json) => Directions(
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
        waypoints: List<Waypoint>.from(
            json["waypoints"].map((x) => Waypoint.fromJson(x))),
        code: json["code"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
        "waypoints": List<dynamic>.from(waypoints.map((x) => x.toJson())),
        "code": code,
        "uuid": uuid,
      };
}

class Route {
  Route({
    required this.countryCrossed,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
    required this.legs,
    required this.geometry,
  });

  bool countryCrossed;
  String weightName;
  double weight;
  double duration;
  double distance;
  List<Leg> legs;
  List<PointLatLng> geometry;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        countryCrossed: json["country_crossed"],
        weightName: json["weight_name"],
        weight: json["weight"].toDouble(),
        duration: json["duration"].toDouble(),
        distance: json["distance"].toDouble(),
        legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
        geometry: PolylinePoints().decodePolyline(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "country_crossed": countryCrossed,
        "weight_name": weightName,
        "weight": weight,
        "duration": duration,
        "distance": distance,
        "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
        "geometry": geometry,
      };
}

class Leg {
  Leg({
    required this.viaWaypoints,
    required this.admins,
    required this.weight,
    required this.duration,
    required this.steps,
    required this.distance,
    required this.summary,
  });

  List<dynamic> viaWaypoints;
  List<Admin> admins;
  double weight;
  double duration;
  List<dynamic> steps;
  double distance;
  String summary;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        viaWaypoints: List<dynamic>.from(json["via_waypoints"].map((x) => x)),
        admins: List<Admin>.from(json["admins"].map((x) => Admin.fromJson(x))),
        weight: json["weight"].toDouble(),
        duration: json["duration"].toDouble(),
        steps: List<dynamic>.from(json["steps"].map((x) => x)),
        distance: json["distance"].toDouble(),
        summary: json["summary"],
      );

  Map<String, dynamic> toJson() => {
        "via_waypoints": List<dynamic>.from(viaWaypoints.map((x) => x)),
        "admins": List<dynamic>.from(admins.map((x) => x.toJson())),
        "weight": weight,
        "duration": duration,
        "steps": List<dynamic>.from(steps.map((x) => x)),
        "distance": distance,
        "summary": summary,
      };
}

class Admin {
  Admin({
    required this.iso31661Alpha3,
    required this.iso31661,
  });

  String iso31661Alpha3;
  String iso31661;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        iso31661Alpha3: json["iso_3166_1_alpha3"],
        iso31661: json["iso_3166_1"],
      );

  Map<String, dynamic> toJson() => {
        "iso_3166_1_alpha3": iso31661Alpha3,
        "iso_3166_1": iso31661,
      };
}

class Waypoint {
  Waypoint({
    required this.distance,
    required this.name,
    required this.location,
  });

  double distance;
  String name;
  List<double> location;

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
        distance: json["distance"].toDouble(),
        name: json["name"],
        location: List<double>.from(json["location"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "name": name,
        "location": List<dynamic>.from(location.map((x) => x)),
      };
}

// https://api.mapbox.com/directions/v5/mapbox/driving/125.017118%2C8.000077%3B125.148467%2C8.051715?alternatives=true&geometries=polyline&language=en&overview=simplified&steps=true&access_token=pk.eyJ1IjoidmlzaXRvdXIiLCJhIjoiY2ttYnd6Y21oMjVycjJvcXMxbjQzcHRmbSJ9.VAV4qSYSXfFYwiuCFYarTQ
// https://docs.mapbox.com/playground/directions/
//https://developers.google.com/maps/documentation/directions/start

// duration - seconds
// distance - meters