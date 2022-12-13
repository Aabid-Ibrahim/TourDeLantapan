import 'dart:convert';
import 'dart:io';

import 'package:app/models/directions_model.dart';
import 'package:app/services/api_status.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as coords;

class DirectionsRepository {
  static Future<Directions?> getDirections({
    required coords.LatLng location,
    required coords.LatLng destination,
  }) async {
    String base_url = "https://api.mapbox.com/directions/v5/mapbox";
    String routing_profile = "driving";
    String point_one = "${location.longitude}%2C${location.latitude}";
    String point_two = "${destination.longitude}%2C${destination.latitude}";
    bool alternatives = true;
    String geometries = "polyline";
    String language = "en";
    String overview = "simplified";
    bool steps = false;
    String access_token = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "";

    String direction_url =
        "${base_url}/${routing_profile}/${point_one}%3B${point_two}";

    var url = Uri.parse(direction_url).replace(queryParameters: {
      "alternatives": alternatives.toString(),
      "geometries": geometries,
      "language": language,
      "overview": overview,
      "steps": steps.toString(),
      "access_token": access_token
    });

    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    print(response.body);

    if (response.statusCode == 200) {
      return Directions.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
