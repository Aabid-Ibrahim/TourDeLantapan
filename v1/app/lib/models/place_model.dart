// To parse this JSON data, do
//
//     final place = placeFromJson(jsonString);

import 'package:app/models/dashboard/dashboard_like.dart';
import 'package:app/models/photo_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart' as coords;

Place placeFromJson(String str) => Place.fromJson(json.decode(str));

String placeToJson(Place data) => json.encode(data.toJson());

class Place {
  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    required this.categoryId,
    required this.photos,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
    // required this.status,
    required this.reviewsStat,
    required this.timeTable,
    required this.favorites,
  });

  String id;
  String name;
  String address;
  String description;
  coords.LatLng coordinates;
  Category categoryId;
  List<Photo> photos;
  List<TimeTable> timeTable;
  DateTime createdAt;
  DateTime updatedAt;
  bool isLiked;
  // String status;
  ReviewsStat reviewsStat;
  Favorites favorites;

  factory Place.fromJson(Map<String, dynamic> json) {
    ReviewsStat reviewsStat = ReviewsStat(average: 0, reviewerCount: 0);

    try {
      reviewsStat = ReviewsStat.fromJson(json["reviewsStat"] is List
          ? json["reviewsStat"][0]
          : json["reviewsStat"]);
    } catch (e) {
      reviewsStat = ReviewsStat(average: 0, reviewerCount: 0);
    }

    return Place(
      id: json["_id"],
      name: json["name"],
      address: json["address"],
      coordinates: coords.LatLng(
          double.parse(json["coordinates"]["latitude"].toString()),
          double.parse(json["coordinates"]["longitude"].toString())),
      categoryId: Category.fromJson(json["categoryId"]),
      description: json["description"],
      // status: json["status"],
      isLiked: json["isLiked"] == null ||
              json["isLiked"] == false ||
              json["isLiked"].toString() == "[]"
          ? false
          : true,
      photos: json["photos"] != null
          ? List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x)))
          : [],
      timeTable: json["timeTable"] != null
          ? List<TimeTable>.from(
              json["timeTable"].map((x) => TimeTable.fromJson(x)))
          : [],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
      // reviewsStat: ReviewsStat(average: 0, reviewerCount: 0),
      reviewsStat: reviewsStat,
      favorites: json["favorites"] != null
          ? Favorites.fromJson(json["favorites"])
          : Favorites(id: 0, count: 0),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "address": address,
        "description": description,
        "isLiked": isLiked,
        "coordinates": coordinates.toJson(),
        "categoryId": categoryId,
        // "status": status,
        "timeTable": List<dynamic>.from(timeTable.map((x) => x.toJson())),
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Coordinates {
  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

ReviewsStat reviewsStatFromJson(String str) =>
    ReviewsStat.fromJson(json.decode(str));

String reviewsStatToJson(ReviewsStat data) => json.encode(data.toJson());

class ReviewsStat {
  ReviewsStat({
    required this.average,
    required this.reviewerCount,
  });

  double average;
  int reviewerCount;

  factory ReviewsStat.fromJson(Map<String, dynamic> json) => ReviewsStat(
        average: json["average"] != null ? json["average"].toDouble() : 0,
        reviewerCount:
            json["reviewerCount"] != null ? json["reviewerCount"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "average": average,
        "reviewerCount": reviewerCount,
      };
}

class TimeTable {
  TimeTable(
      {required this.day,
      required this.timeFromHour,
      required this.timeFromMinute,
      required this.timeToHour,
      required this.timeToMinute,
      required this.other});

  String day;
  int timeFromHour;
  int timeFromMinute;
  int timeToHour;
  int timeToMinute;
  String other;

  factory TimeTable.fromJson(Map<String, dynamic> json) => TimeTable(
        day: json["day"],
        timeFromHour: json["timeFromHour"],
        timeFromMinute: json["timeFromMinute"],
        timeToHour: json["timeToHour"],
        timeToMinute: json["timeToMinute"],
        other: json["other"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "timeFromHour": timeFromHour,
        "timeFromMinute": timeFromMinute,
        "timeToHour": timeToHour,
        "timeToMinute": timeToMinute,
        "other": other
      };
}

Place placeNoData = Place(
    id: "1",
    name: "No data",
    address: "No data",
    description: "No data",
    coordinates: coords.LatLng(10.3, 12.3),
    categoryId: Category(id: "48", name: "No data"),
    photos: [],
    isLiked: false,
    // status: "OPEN",
    timeTable: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    reviewsStat: ReviewsStat(average: 0, reviewerCount: 0),
    favorites: Favorites(id: 0, count: 0));
