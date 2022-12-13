import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final IconData? icon;
  final String? title;
  final LatLng? location;

  MapMarker({
    required this.icon,
    required this.title,
    required this.location,
  });
}
