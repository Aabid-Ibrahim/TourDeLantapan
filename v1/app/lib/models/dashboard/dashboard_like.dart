// To parse this JSON data, do
//
//     final dashboardLikes = dashboardLikesFromJson(jsonString);

import 'package:app/models/photo_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<DashboardLikes> dashboardLikesFromJson(String str) =>
    List<DashboardLikes>.from(
        json.decode(str).map((x) => DashboardLikes.fromJson(x)));

String dashboardLikesToJson(List<DashboardLikes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashboardLikes {
  DashboardLikes({
    required this.id,
    required this.name,
    required this.photos,
    required this.favorites,
  });

  String id;
  String name;
  List<Photo> photos;
  Favorites favorites;

  factory DashboardLikes.fromJson(Map<String, dynamic> json) => DashboardLikes(
        id: json["_id"],
        name: json["name"],
        photos: json["photos"] == null
            ? []
            : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        favorites: Favorites.fromJson(json["favorites"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "photos": photos == null
            ? null
            : List<dynamic>.from(photos.map((x) => x.toJson())),
        "favorites": favorites.toJson(),
      };
}

class Favorites {
  Favorites({
    required this.id,
    required this.count,
  });

  int id;
  int count;

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        id: json["_id"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "count": count,
      };
}
