// ignore_for_file: non_constant_identifier_names

import 'package:app/models/directions_model.dart';
import 'package:app/models/place_model.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/directions_repository.dart';
import 'package:app/widgets/snackbar.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as coords;

class LocationProvider extends ChangeNotifier {
  coords.LatLng _coordinates =
      coords.LatLng(8.143548493162127, 125.13147031688014);
  coords.LatLng get coordinates => _coordinates;

  Place _destination = placeNoData;
  Place get destination => _destination;
  CameraPosition _initialCameraPosition = CameraPosition(
    target: const LatLng(8.143548493162127, 125.13147031688014),
    zoom: mapZoom,
  );
  CameraPosition get initialCameraPosition => _initialCameraPosition;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String _address = "";
  String get address => _address;

  Set<Polyline> polylines = {};
  Directions? info;
  List<LatLng> polylineCoordinates = [];
  List<String> stepsInstructions = [];

  double _distance = 0;
  double get distance => _distance;
  double _liters = 0;
  double get liters => _liters;
  double _fuelPrice = 0;
  double get fuelPrice => _fuelPrice;

  double _averageGasPrice = 74.20;
  double get averageGasPrice => _averageGasPrice;

  double _kilometerPerLiter = 12.5;
  double get kilometerPerLiter => _kilometerPerLiter;

  setAverageGasPrice(double input) {
    _averageGasPrice = input;
    calculateGasFuelPrice(distanceByMeters: _distance * 1000);
    notifyListeners();
  }

  setKilometerPerLiter(double input) {
    _kilometerPerLiter = input;
    calculateGasFuelPrice(distanceByMeters: _distance * 1000);
    notifyListeners();
  }

  setDestination(Place place) {
    _destination = place;
    // _initialCameraPosition = CameraPosition(
    //   target: place.coordinates,
    //   zoom: mapZoom,
    // );
    notifyListeners();
  }

  calculateGasFuelPrice({required double distanceByMeters}) {
    _distance = distanceByMeters / 1000;
    _liters = _distance / _kilometerPerLiter;
    _fuelPrice = _liters * _averageGasPrice;
  }

  resetMarkers() {
    markers = <MarkerId, Marker>{};
    notifyListeners();
  }

  resetPolyline() {
    polylines = {};
    notifyListeners();
  }

  determinePosition(BuildContext context, Function callback) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      launchSnackbar(
          context: context,
          mode: "ERROR",
          message: 'Location services are disabled.');
      callback(null, false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        launchSnackbar(
            context: context,
            mode: "ERROR",
            message: 'Location permissions are denied');
        return;
      }
      callback(null, false);
    }

    if (permission == LocationPermission.deniedForever) {
      launchSnackbar(
          context: context,
          mode: "ERROR",
          message:
              'Location permissions are permanently denied, we cannot request permissions.');
      callback(null, false);
    }
    var res = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.best);

    callback(res, true);
  }

  setMarker(String markerName, LatLng coordinates) {
    MarkerId markerId = MarkerId(markerName);
    Marker destinationMarker = Marker(
      markerId: markerId,
      position: coordinates,
      infoWindow: InfoWindow(title: markerName, snippet: '*'),
      onTap: () {},
    );
    markers[markerId] = destinationMarker;
    notifyListeners();
  }

  // Current location of user
  setCoordinates(coords.LatLng coordinates, String address) {
    _coordinates = coordinates;
    _address = address;

    MarkerId locationMarkerId = const MarkerId("location");
    // Marker locationMarker = Marker(
    //   icon: BitmapDescriptor.defaultMarkerWithHue(.5),
    //   markerId: locationMarkerId,
    //   position: coordinates,
    //   infoWindow: const InfoWindow(title: "location", snippet: '*'),
    //   onTap: () {},
    // );
    // markers[locationMarkerId] = locationMarker;
    notifyListeners();
    getPolyline();
  }

  getPolyline({coords.LatLng? pos}) async {
    coords.LatLng origin = _coordinates;
    coords.LatLng dest = pos ?? _destination.coordinates;
    Directions? direction = await DirectionsRepository.getDirections(
        location: origin, destination: dest);
    if (direction != null) {
      info = direction;
      calculateGasFuelPrice(distanceByMeters: direction.routes[0].distance);
      polylineCoordinates.clear();
      direction.routes[0].geometry.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      notifyListeners();
      _addPolyLine();
    }
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        width: 5,
        color: Colors.red,
        points: polylineCoordinates);
    polylines.add(polyline);
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, ' ');
  }
}
