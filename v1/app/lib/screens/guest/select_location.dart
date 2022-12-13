import 'package:app/provider/location_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/reverse_geocode.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SelectLocation extends StatefulWidget {
  bool willDetectLocation;
  LatLng? value;
  Function onSelectLocation;
  SelectLocation(
      {Key? key,
      required this.willDetectLocation,
      this.value,
      required this.onSelectLocation})
      : super(key: key);

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String address = "";
  bool detectingLocation = false;
  LatLng? coordinates;

  _determinePosition() async {
    setState(() => detectingLocation = true);
    Provider.of<LocationProvider>(context, listen: false)
        .determinePosition(context, (res, isSuccess) {
      if (isSuccess) {
        setMarker(LatLng(res.latitude, res.longitude));
        setState(() => detectingLocation = false);
      }
    });
  }

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      if (widget.willDetectLocation) {
        _determinePosition();
      }
      if (widget.value != null && !widget.willDetectLocation) {
        setMarker(widget.value!);
      }
    }();
    super.initState();
  }

  setMarker(LatLng pos) async {
    var markerIdVal = "no_id";
    address = await AddressRepository.reverseGeocode(coordinates: pos);
    setState(() {
      coordinates = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBG1,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (detectingLocation) const LinearProgressIndicator(),
        const SizedBox(
          height: 15,
        ),
        IconText(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            mainAxisAlignment: MainAxisAlignment.start,
            color: textColor1,
            fontWeight: FontWeight.normal,
            label: "Your Location"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
              address.isNotEmpty
                  ? address.trim()
                  : detectingLocation
                      ? "Detecting location..."
                      : "Select Location",
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor2)),
        ),
        const SizedBox(
          height: 15,
        ),
        Button(
            backgroundColor: Colors.black87,
            borderColor: Colors.transparent,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            label: "Select Location",
            onPress: () {
              if (coordinates == null) {
                launchSnackbar(
                    context: context,
                    mode: "ERROR",
                    message: "No location yet.");
                return;
              }

              widget.onSelectLocation(coordinates, address);
              Navigator.pop(context);
            }),
        const SizedBox(
          height: 15,
        ),
        Expanded(
            child: FlutterMap(
          options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 13,
              center: widget.value,
              onLongPress: (pos, latlng) {
                setMarker(latlng);
              }),
          layers: [
            TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/tourdelantapan/cl95ltry3000j14ocq601prir/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidG91cmRlbGFudGFwYW4iLCJhIjoiY2w4ZzJxc25uMGIyZzNvcHJuaWZ4Yzh0dyJ9.pLM4COThCSDADIYCDrfGFg",
              additionalOptions: {
                'mapStyleId': dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "",
                'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "",
              },
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  height: 40,
                  width: 40,
                  point: coordinates ?? widget.value!,
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 40,
                        color: Colors.red,
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        )),
      ]),
    );
  }
}
