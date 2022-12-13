// To parse this JSON data, do
//
//     final basicModel = basicModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'photo_model.dart';

BasicModel basicModelFromJson(String str) =>
    BasicModel.fromJson(json.decode(str));

String basicModelToJson(BasicModel data) => json.encode(data.toJson());

class BasicModel {
  BasicModel({
    required this.id,
    required this.title,
    this.icon,
    this.photos,
  });

  String id;
  String title;
  String? icon;
  List<Photo>? photos;

  factory BasicModel.fromJson(Map<String, dynamic> json) => BasicModel(
        id: json["_id"],
        title: json["title"],
        icon: json["icon"],
        photos: json["photos"] == null
            ? null
            : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
      };
}
