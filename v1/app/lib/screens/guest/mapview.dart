import 'package:app/provider/location_provider.dart';
import 'package:app/screens/guest/select_location.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      Provider.of<LocationProvider>(context, listen: false).resetMarkers();
      // Provider.of<LocationProvider>(context, listen: false).setMarker(
      //     "destination",
      //     Provider.of<LocationProvider>(context, listen: false)
      //         .destination
      //         .coordinates);

      if (Provider.of<LocationProvider>(context, listen: false)
          .address
          .isNotEmpty) {
        await Provider.of<LocationProvider>(context, listen: false)
            .getPolyline();
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    LocationProvider locationProvider = context.watch<LocationProvider>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: .3,
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      enableDrag: false,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setModalState) {
                          return Modal(
                              title: "Long press to pin your location",
                              heightInPercentage: .9,
                              content: SelectLocation(
                                  value: locationProvider.coordinates,
                                  willDetectLocation:
                                      locationProvider.address.isEmpty,
                                  onSelectLocation: (coordinates, address) {
                                    Provider.of<LocationProvider>(context,
                                            listen: false)
                                        .setCoordinates(coordinates, address);
                                  }));
                        });
                      });
                },
                icon: const Icon(Icons.pin_drop_rounded))
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
                child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: locationProvider.initialCameraPosition,
              markers: Set<Marker>.of(locationProvider.markers.values),
              polylines: locationProvider.polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // controller.animateCamera(CameraUpdate.newCameraPosition(
                //     CameraPosition(
                //         target: Provider.of<LocationProvider>(context,
                //                 listen: false)
                //             .destination
                //             .coordinates,
                //         zoom: mapZoom)));
              },
            )),
            Container(
              padding: EdgeInsets.only(
                  left: HORIZONTAL_PADDING,
                  right: HORIZONTAL_PADDING,
                  bottom: bottomPadding == 0.0 ? 15 : bottomPadding),
              color: colorBG2,
              child: Column(children: [
                const SizedBox(
                  height: 15,
                ),
                IconText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    color: textColor2,
                    fontWeight: FontWeight.bold,
                    label: "Destination Tracking"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.red[50]),
                              child: const Icon(
                                Icons.pin_drop_rounded,
                                color: Colors.red,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            locationProvider.address.isEmpty
                                ? "No location"
                                : locationProvider.address.trim(),
                            maxLines: 2,
                            style: TextStyle(color: textColor2),
                          ))
                        ]),
                      ),
                      Expanded(
                          child: Icon(
                        Icons.arrow_right_alt_rounded,
                        color: textColor2,
                      )),
                      Expanded(
                        child: Row(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  image: NetworkImage(locationProvider
                                          .destination.photos.isNotEmpty
                                      ? locationProvider
                                          .destination.photos[0].small!
                                      : placeholderImage))),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            locationProvider.destination.name,
                            maxLines: 2,
                            style: TextStyle(color: textColor2),
                          ))
                        ]),
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                IconText(
                    mainAxisAlignment: MainAxisAlignment.start,
                    color: textColor2,
                    fontWeight: FontWeight.bold,
                    label: "Travel Gas Consumption"),
                const SizedBox(
                  height: 25,
                ),
                Details(
                  label: "Trip Distance",
                  value: "${locationProvider.distance.toStringAsFixed(2)}km",
                  measurement: "Kilometers(km)",
                  iconAsset: 'assets/images/distance.png',
                ),
                const SizedBox(
                  height: 20,
                ),
                Details(
                  label: "Fuel Efficiency",
                  value: "${locationProvider.liters.toStringAsFixed(2)} liter",
                  // measurement: "Liters per 100km(L/100km)",
                  measurement:
                      "${locationProvider.kilometerPerLiter.toStringAsFixed(2)}km per 1L",
                  iconAsset: 'assets/images/fuel.png',
                  action: Material(
                    color: Colors.transparent,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                String input = "";

                                return AlertDialog(
                                  title:
                                      const Text('Edit Kilometers per Liter'),
                                  content: TextField(
                                    onChanged: (value) {
                                      input = value;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: "Kilometers per Liter"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Close")),
                                    TextButton(
                                        onPressed: () {
                                          locationProvider.setKilometerPerLiter(
                                              double.parse(input));
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Save")),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.edit_rounded,
                            size: 15, color: textColor2)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Details(
                  label: "Gas Fuel Price",
                  value: "₱${locationProvider.fuelPrice.toStringAsFixed(2)}",
                  measurement:
                      "₱${locationProvider.averageGasPrice.toStringAsFixed(2)} per Liter",
                  iconAsset: 'assets/images/price.png',
                  action: Material(
                    color: Colors.transparent,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                String input = "";

                                return AlertDialog(
                                  title: const Text('Edit Gas Price'),
                                  content: TextField(
                                    onChanged: (value) {
                                      input = value;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: "Gas price in ₱"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Close")),
                                    TextButton(
                                        onPressed: () {
                                          locationProvider.setAverageGasPrice(
                                              double.parse(input));
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Save")),
                                  ],
                                );
                              });
                        },
                        icon: Icon(
                          Icons.edit_rounded,
                          size: 15,
                          color: textColor2,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ]),
            )
          ],
        ));
  }
}

class Details extends StatelessWidget {
  String label;
  String value;
  String measurement;
  String iconAsset;
  Widget? action;
  Details(
      {Key? key,
      required this.label,
      required this.value,
      required this.measurement,
      this.action,
      required this.iconAsset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image(height: 25, width: 25, image: AssetImage(iconAsset)),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconText(
            mainAxisAlignment: MainAxisAlignment.start,
            label: label,
            color: textColor2,
            fontWeight: FontWeight.bold,
          ),
          IconText(
            mainAxisAlignment: MainAxisAlignment.start,
            label: value,
            color: textColor2,
          )
        ]),
      ),
      Expanded(
        child: Row(children: [
          IconText(
            mainAxisAlignment: MainAxisAlignment.start,
            label: measurement,
            color: textColor2,
          ),
          if (action != null) action!
        ]),
      )
    ]);
  }
}




// https://pub.dev/packages/google_directions_api
// https://medium.com/@shiraz990/flutter-fetching-google-directions-using-changenotifierprovider-f642adbe6cf4