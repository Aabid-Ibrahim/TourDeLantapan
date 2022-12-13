// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:app/models/photo_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.scope,
    this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this.emailVerification,
  });

  String id;
  String fullName;
  String email;
  String password;
  Photo? photo;
  List<String> scope;
  DateTime createdAt;
  DateTime updatedAt;
  List<EmailVerification> emailVerification;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["_id"],
      fullName: json["fullName"],
      email: json["email"],
      password: json["password"] ?? "",
      scope: List<String>.from(json["scope"].map((x) => x)),
      photo: json["photo"] == null ? null : Photo.fromJson(json["photo"]),
      createdAt: json["createdAt"] == null
          ? DateTime.now()
          : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
          ? DateTime.now()
          : DateTime.parse(json["updatedAt"]),
      emailVerification: json["emailVerification"] == null
          ? []
          : List<EmailVerification>.from(json["emailVerification"]
              .map((x) => EmailVerification.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "email": email,
        "password": password,
        "scope": List<dynamic>.from(scope.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class EmailVerification {
  EmailVerification({
    required this.isConfirmed,
    required this.email,
    required this.pin,
  });

  bool isConfirmed;
  String email;
  String pin;

  factory EmailVerification.fromJson(Map<String, dynamic> json) =>
      EmailVerification(
        isConfirmed: json["isConfirmed"],
        email: json["email"],
        pin: json["pin"],
      );

  Map<String, dynamic> toJson() => {
        "isConfirmed": isConfirmed,
        "email": email,
        "pin": pin,
      };
}
