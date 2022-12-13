// To parse this JSON data, do
//
//     final dashboardRating = dashboardRatingFromJson(jsonString);

import 'package:app/models/photo_model.dart';
import 'package:app/models/place_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<DashboardRating> dashboardRatingFromJson(String str) =>
    List<DashboardRating>.from(
        json.decode(str).map((x) => DashboardRating.fromJson(x)));

String dashboardRatingToJson(List<DashboardRating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashboardRating {
  DashboardRating({
    required this.id,
    required this.name,
    required this.photos,
    required this.reviewsStat,
  });

  String id;
  String name;
  List<Photo> photos;
  ReviewsStat reviewsStat;

  factory DashboardRating.fromJson(Map<String, dynamic> json) =>
      DashboardRating(
        id: json["_id"],
        name: json["name"],
        photos: json["photos"] == null
            ? []
            : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        reviewsStat: ReviewsStat.fromJson(json["reviewsStat"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "photos": photos == null
            ? null
            : List<dynamic>.from(photos.map((x) => x.toJson())),
        "reviewsStat": reviewsStat.toJson(),
      };
}
