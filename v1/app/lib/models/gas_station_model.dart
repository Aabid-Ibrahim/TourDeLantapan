// To parse this JSON data, do
//
//     final gasStation = gasStationFromJson(jsonString);

import 'package:app/models/photo_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

GasStation gasStationFromJson(String str) =>
    GasStation.fromJson(json.decode(str));

String gasStationToJson(GasStation data) => json.encode(data.toJson());

class GasStation {
  GasStation({
    required this.id,
    required this.name,
    required this.photos,
    required this.coordinates,
  });

  String id;
  String name;
  List<Photo> photos;
  Coordinates coordinates;

  factory GasStation.fromJson(Map<String, dynamic> json) => GasStation(
        id: json["_id"],
        name: json["name"],
        photos: json["photos"] != null
            ? List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x)))
            : [],
        coordinates: Coordinates.fromJson(json["coordinates"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "photos": List<dynamic>.from(photos.map((x) => x)),
        // "coordinates": coordinates.toJson(),
      };
}

class Coordinates {
  Coordinates({
    required this.type,
    required this.coordinates,
  });

  String type;
  LatLng coordinates;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        type: json["type"],
        coordinates: LatLng(json["coordinates"][1], json["coordinates"][0]),
      );

  // Map<String, dynamic> toJson() => {
  //       "type": type,
  //       "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  //     };
}
