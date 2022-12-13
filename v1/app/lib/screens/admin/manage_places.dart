import 'package:app/models/place_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/screens/guest/place_info.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/grid_count.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/action_modal.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/place_card.dart';
import 'package:app/widgets/shimmer/grid_shimmer.dart';
import 'package:app/widgets/shimmer/place_card_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ManagePlaces extends StatefulWidget {
  Map<String, dynamic> arguments;
  ManagePlaces({Key? key, required this.arguments}) : super(key: key);

  @override
  State<ManagePlaces> createState() => _ManagePlacesState();
}

class _ManagePlacesState extends State<ManagePlaces> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String placeId = '';

  fetchPlaces() {
    Provider.of<PlaceProvider>(context, listen: false).getPlaces(
        query: {"mode": widget.arguments["mode"]},
        callback: (code, message) {
          if (code != 200) {
            launchSnackbar(
                context: context,
                mode: code == 200 ? "SUCCESS" : "ERROR",
                message: message ?? "Success!");
          }
        });
  }

  deletePlace(String placeId) {
    Provider.of<PlaceProvider>(context, listen: false).deletePlace(
        placeId: placeId,
        callback: (code, message) {
          if (code != 200) {
            launchSnackbar(
                context: context,
                mode: code == 200 ? "SUCCESS" : "ERROR",
                message: message ?? "Success!");
          }
          Navigator.pop(context);
          fetchPlaces();
        });
  }

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      fetchPlaces();
      super.initState();
    }();
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    void _openEndDrawer(String placeId) {
      setState(() {
        this.placeId = placeId;
      });
      _scaffoldKey.currentState!.openEndDrawer();
    }

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * .30,
          child: PlaceInfo(arguments: {"placeId": placeId})),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/place/add", arguments: {"mode": "ADD"})
              .then((_) {
            fetchPlaces();
          });
        },
        isExtended: true,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            if (placeProvider.loading.contains("place-delete"))
              const LinearProgressIndicator(),
            if (placeProvider.loading.contains("admin"))
              GridShimmer()
            else if (placeProvider.adminPlaces.isNotEmpty)
              Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount:
                          getGridCount(MediaQuery.of(context).size.width),
                    ),
                    itemCount: placeProvider.adminPlaces.length,
                    itemBuilder: (BuildContext context, int index) {
                      Place place = placeProvider.adminPlaces[index];

                      return PlaceCard(
                          photoUrl: place.photos.isNotEmpty
                              ? place.photos[0].small
                              : placeholderImage,
                          onPress: () {},
                          topRight: PopupMenuButton<String>(
                              icon: Container(
                                  decoration: BoxDecoration(
                                      color: textColor2,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: const Icon(Icons.more_horiz_rounded)),
                              itemBuilder: (context) => [
                                    PopupMenuItem<String>(
                                        // ignore: sort_child_properties_last
                                        child: IconText(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            icon: Icons.edit_rounded,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            label: "Edit"),
                                        value: '1'),
                                    PopupMenuItem<String>(
                                        // ignore: sort_child_properties_last
                                        child: IconText(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            icon: Icons.qr_code,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            label: "Generate QR Code"),
                                        value: '2'),
                                    PopupMenuItem<String>(
                                        // ignore: sort_child_properties_last
                                        child: IconText(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            icon: Icons.details,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            label: "See Details"),
                                        value: '3'),
                                    PopupMenuItem<String>(
                                        // ignore: sort_child_properties_last
                                        child: IconText(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            icon: Icons.reviews_rounded,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            label: "Manage Reviews"),
                                        value: '4'),
                                    PopupMenuItem<String>(
                                        // ignore: sort_child_properties_last
                                        child: IconText(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            icon: Icons
                                                .remove_circle_outline_rounded,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            label: "Delete Place"),
                                        value: '5'),
                                  ],
                              onSelected: (itemSelected) {
                                if (itemSelected == "1") {
                                  Navigator.pushNamed(context, '/place/add',
                                      arguments: {
                                        "mode": "EDIT",
                                        "payload": place
                                      }).then((_) {
                                    fetchPlaces();
                                  });
                                }

                                if (itemSelected == "2") {
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
                                            heightInPercentage: .7,
                                            title: "${place.name} QR Code",
                                            bgColor: Colors.white,
                                            textColor: Colors.black,
                                            content: Center(
                                              child: QrImage(
                                                data: place.id,
                                                version: QrVersions.auto,
                                                size: 250.0,
                                              ),
                                            ),
                                          );
                                        });
                                      });
                                }

                                if (itemSelected == "3") {
                                  if (!isMobile(context)) {
                                    _openEndDrawer(place.id);
                                    return;
                                  }

                                  Navigator.pushNamed(context, "/place/info",
                                      arguments: {"placeId": place.id});
                                }

                                if (itemSelected == "4") {
                                  Provider.of<PlaceProvider>(context,
                                          listen: false)
                                      .setPlace(place);
                                  Navigator.pushNamed(context, '/review/list');
                                }

                                if (itemSelected == "5") {
                                  showModalBottomSheet(
                                      context: context,
                                      isDismissible: false,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext newContext,
                                                StateSetter setModalState) {
                                          return ActionModal(
                                            isLoading: true,
                                            title: "Confirm Delete?",
                                            subTitle:
                                                "This action cannot be undone.",
                                            callback: (action) {
                                              if (action != "CONFIRM") {
                                                Navigator.pop(context);
                                                return;
                                              }
                                              deletePlace(place.id);
                                            },
                                          );
                                        });
                                      });
                                  return;
                                }
                              }),
                          // upperLabelWidget: RatingBar.builder(
                          //   initialRating: 0,
                          //   minRating: 1,
                          //   direction: Axis.horizontal,
                          //   allowHalfRating: true,
                          //   unratedColor: textColor254,
                          //   itemCount: 5,
                          //   itemSize: 15,
                          //   itemPadding:
                          //       const EdgeInsets.only(right: 2, bottom: 5),
                          //   itemBuilder: (context, _) => const Icon(
                          //     Icons.star,
                          //     color: Colors.amber,
                          //   ),
                          //   onRatingUpdate: (rating) {},
                          // ),
                          label: place.name,
                          subLabel: place.address);
                    }),
              )
            else
              IconText(
                mainAxisAlignment: MainAxisAlignment.center,
                padding: const EdgeInsets.only(top: 50),
                label: "No content",
                color: Colors.black54,
                icon: Icons.air_rounded,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
          ],
        ),
      ),
    );
  }
}
