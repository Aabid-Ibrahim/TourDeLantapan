// To parse this JSON data, do
//
//     final visitor = visitorFromJson(jsonString);

import 'package:app/models/place_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Visitor visitorFromJson(String str) => Visitor.fromJson(json.decode(str));

String visitorToJson(Visitor data) => json.encode(data.toJson());

class Visitor {
  Visitor({
    required this.id,
    required this.fullName,
    required this.contactNumber,
    required this.dateOfVisit,
    required this.numberOfVisitors,
    required this.placeId,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
  });

  String id;
  String fullName;
  String contactNumber;
  DateTime dateOfVisit;
  int numberOfVisitors;
  Place placeId;
  DateTime createdAt;
  DateTime updatedAt;
  Address address;

  factory Visitor.fromJson(Map<String, dynamic> json) => Visitor(
      id: json["_id"],
      fullName: json["fullName"],
      contactNumber: json["contactNumber"],
      dateOfVisit: DateTime.parse(json["dateOfVisit"]),
      numberOfVisitors: json["numberOfVisitors"],
      placeId: Place.fromJson(json["placeId"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      address: Address.fromJson(json["address"]));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "contactNumber": contactNumber,
        "dateOfVisit": dateOfVisit.toIso8601String(),
        "numberOfVisitors": numberOfVisitors,
        "placeId": placeId.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "address": address.toJson(),
      };
}

class Address {
  Address({
    required this.region,
    required this.regionId,
    required this.province,
    required this.provinceId,
    required this.cityMunicipality,
    required this.cityMunicipalityId,
  });

  String region;
  String regionId;
  String province;
  String provinceId;
  String cityMunicipality;
  String cityMunicipalityId;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        region: json["region"],
        regionId: json["regionId"],
        province: json["province"],
        provinceId: json["provinceId"],
        cityMunicipality: json["cityMunicipality"],
        cityMunicipalityId: json["cityMunicipalityId"],
      );

  Map<String, dynamic> toJson() => {
        "region": region,
        "regionId": regionId,
        "province": province,
        "provinceId": provinceId,
        "cityMunicipality": cityMunicipality,
        "cityMunicipalityId": cityMunicipalityId,
      };
}
