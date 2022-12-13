// To parse this JSON data, do
//
//     final Review = ReviewFromJson(jsonString);

import 'package:app/models/photo_model.dart';
import 'package:app/models/place_model.dart';
import 'package:app/models/user_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Review reviewsFromJson(String str) => Review.fromJson(json.decode(str));

String reviewsToJson(Review data) => json.encode(data.toJson());

class Review {
  Review({
    required this.id,
    required this.rating,
    required this.content,
    required this.photos,
    required this.placeId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  double rating;
  String content;
  List<Photo> photos;
  Place placeId;
  User userId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        rating: json["rating"] + 0.0,
        content: json["content"],
        photos: json["photos"] == null
            ? []
            : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        placeId: Place.fromJson(json["placeId"]),
        userId: User.fromJson(json["userId"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "rating": rating,
        "content": content,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "placeId": placeId.toJson(),
        "userId": userId.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
