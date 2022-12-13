import 'dart:convert';
import 'package:app/models/directions_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class AddressRepository {
  static Future<String> reverseGeocode({
    required LatLng coordinates,
  }) async {
    String base_url = "https://api.mapbox.com/geocoding/v5/mapbox.places/";
    String query = "${coordinates.longitude},${coordinates.latitude}.json?";
    String accessToken =
        "access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? ""}";
    String limit = "&limit=1";
    String reverse_geocode_url = "${base_url}${query}${accessToken}${limit}";

    var url = Uri.parse(reverse_geocode_url);
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      try {
        List context =
            jsonDecode(response.body)?["features"]?[0]?['context'] as List;
        return context
            .map((e) => e["id"].contains('locality') ? "" : e["text"] ?? "")
            .join(', ')
            .replaceFirst(r', ', '');
        // return jsonDecode(response.body)?["features"]?[0]?['place_name'];
      } catch (e) {
        return "No Address";
      }
    } else {
      return "No Address";
    }
  }
}
