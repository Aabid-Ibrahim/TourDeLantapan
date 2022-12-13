import 'dart:async';
import 'dart:convert';
import 'package:app/models/gas_station_model.dart';
import 'package:app/provider/app_provider.dart';
import 'package:app/provider/location_provider.dart';
import 'package:app/screens/image-viewer.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_loaders.dart';
import 'package:app/widgets/place_card.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as coords;

class NearbyGasStations extends StatefulWidget {
  NearbyGasStations({Key? key}) : super(key: key);

  @override
  State<NearbyGasStations> createState() => _NearbyGasStationsState();
}

class _NearbyGasStationsState extends State<NearbyGasStations> {
  int index = -1;
  late GoogleMapController _controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  CarouselController buttonCarouselController = CarouselController();

  fetchPlaces() {
    coords.LatLng loc =
        Provider.of<LocationProvider>(context, listen: false).coordinates;
    Provider.of<AppProvider>(context, listen: false).getGasStationList(
        query: {
          "userLocation":
              jsonEncode({"latitude": loc.latitude, "longitude": loc.longitude})
        },
        callback: (code, message) async {
          if (code != 200) {
            launchSnackbar(
                context: context,
                mode: code == 200 ? "SUCCESS" : "ERROR",
                message: message ?? "Success!");
            return;
          }

          var icon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), 'assets/images/fuel_map.png');

          List<GasStation> gasStations =
              Provider.of<AppProvider>(context, listen: false).gasStations;

          for (int i = 0; i < gasStations.length; i++) {
            MarkerId locationMarkerId = MarkerId(gasStations[i].id);
            Marker locationMarker = Marker(
              icon: icon,
              markerId: locationMarkerId,
              position: gasStations[i].coordinates.coordinates,
              infoWindow: InfoWindow(title: gasStations[i].name),
              onTap: () async {
                setState(() {
                  index = i;
                });

                if (Provider.of<LocationProvider>(context, listen: false)
                    .address
                    .isNotEmpty) {
                  await Provider.of<LocationProvider>(context, listen: false)
                      .getPolyline(
                          pos: coords.LatLng(
                              gasStations[i].coordinates.coordinates.latitude,
                              gasStations[i]
                                  .coordinates
                                  .coordinates
                                  .longitude));
                }

                _controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: Provider.of<AppProvider>(context, listen: false)
                            .gasStations[i]
                            .coordinates
                            .coordinates,
                        zoom: mapZoom)));
              },
            );
            markers[locationMarkerId] = locationMarker;
          }
        });
  }

  @override
  void initState() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false).resetPolyline();
      fetchPlaces();
      MarkerId locationMarkerId = const MarkerId("location");
      Marker locationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(.5),
        markerId: locationMarkerId,
        position: LatLng(
            Provider.of<LocationProvider>(context, listen: false)
                .coordinates
                .latitude,
            Provider.of<LocationProvider>(context, listen: false)
                .coordinates
                .longitude),
        infoWindow: const InfoWindow(title: "location", snippet: '*'),
        onTap: () {},
      );
      markers[locationMarkerId] = locationMarker;
      launchSnackbar(
          context: context,
          mode: "SUCCESS",
          message: "Tap on the gas icon to see details.");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = context.watch<LocationProvider>();
    AppProvider appProvider = context.watch<AppProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: .3,
          actions: [
            if (appProvider.loading == "gas-station-list")
              showDoubleBounce(size: 20, color: textColor2),
            const SizedBox(
              width: 30,
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Expanded(
              child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: const LatLng(8.053088729642518, 125.13539297751151),
              zoom: mapZoom,
            ),
            polylines: locationProvider.polylines,
            markers: Set<Marker>.of(markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              coords.LatLng latlng =
                  Provider.of<LocationProvider>(context, listen: false)
                      .coordinates;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(latlng.latitude, latlng.longitude),
                      zoom: mapZoom)));
            },
          )),
          if (appProvider.gasStations.isNotEmpty && index != -1)
            Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 15,
                child: Container(
                  height: 100,
                  width: 200,
                  margin: const EdgeInsets.all(15),
                  child: PlaceCard(
                      onPress: () {
                        showModalBottomSheet(
                            context: context,
                            isDismissible: false,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setModalState) {
                                return Modal(
                                    content: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(
                                            Provider.of<AppProvider>(context,
                                                        listen: false)
                                                    .gasStations[index]
                                                    .photos[0]
                                                    .original ??
                                                placeholderImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Button(
                                            label: "Open Image",
                                            backgroundColor: Colors.transparent,
                                            borderColor: Colors.transparent,
                                            textColor: textColor2,
                                            icon: Icons.open_in_browser_rounded,
                                            onPress: () {
                                              if (Provider.of<AppProvider>(
                                                      context,
                                                      listen: false)
                                                  .gasStations[index]
                                                  .photos
                                                  .isEmpty) {
                                                return;
                                              }

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GalleryPhotoViewWrapper(
                                                    galleryItems: Provider.of<
                                                                AppProvider>(
                                                            context,
                                                            listen: false)
                                                        .gasStations[index]
                                                        .photos,
                                                    backgroundDecoration:
                                                        const BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                    initialIndex: index,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                  ),
                                                ),
                                              );
                                            })
                                      ],
                                    ),
                                    title: Provider.of<AppProvider>(context,
                                            listen: false)
                                        .gasStations[index]
                                        .name);
                              });
                            });
                      },
                      photoUrl: appProvider.gasStations[index].photos[0].small,
                      label: appProvider.gasStations[index].name),
                ))
        ]));
  }
}
