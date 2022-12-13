import 'dart:ui';

import 'package:app/models/photo_model.dart';
import 'package:app/provider/location_provider.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/screens/image-viewer.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/action_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/image_carousel.dart';
import 'package:app/widgets/review_item.dart';
import 'package:app/widgets/shape/diamond_border.dart';
import 'package:app/widgets/shape/square_border.dart';
import 'package:app/widgets/shimmer/place_info_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:app/widgets/time_table_display.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app/utilities/string_extensions.dart';

class PlaceInfo extends StatefulWidget {
  Map<String, dynamic> arguments;
  PlaceInfo({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PlaceInfo> createState() => _PlaceInfoState();
}

class _PlaceInfoState extends State<PlaceInfo> {
  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;

      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      if (ConnectivityResult.none == connectivityResult) {
        if (!mounted) return;
        Provider.of<PlaceProvider>(context, listen: false).getPlaceOffline(
            placeId: widget.arguments["placeId"],
            onUnavailable: () {
              launchSnackbar(
                  context: context,
                  mode: "ERROR",
                  message: "Information is unavailable");
              Navigator.pop(context);
            });
        return;
      }

      Provider.of<PlaceProvider>(context, listen: false).getPlace(
          placeId: widget.arguments["placeId"],
          callback: (code, message) {
            if (code != 200) {
              launchSnackbar(
                  context: context,
                  mode: code == 200 ? "SUCCESS" : "ERROR",
                  message: message ?? "Success!");
              return;
            }
            if (Provider.of<LocationProvider>(context, listen: false)
                .address
                .isNotEmpty) {
              Provider.of<LocationProvider>(context, listen: false)
                  .setDestination(
                      Provider.of<PlaceProvider>(context, listen: false)
                          .placeInfo);
              Provider.of<LocationProvider>(context, listen: false)
                  .getPolyline();
            }
          });
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int index = -1;
    PlaceProvider placeProvider = context.watch<PlaceProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    LocationProvider locationProvider = context.watch<LocationProvider>();
    double height = MediaQuery.of(context).size.height;
    int _currentIndex = 0;

    void openImageViewer(BuildContext context, final int index) {
      if (placeProvider.placeInfo.photos.isEmpty) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhotoViewWrapper(
            galleryItems: placeProvider.placeInfo.photos,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
            scrollDirection: Axis.horizontal,
          ),
        ),
      );
    }

    String getIsOpenClose() {
      int weekday = DateTime.now().weekday - 1;

      if (placeProvider.placeInfo.timeTable.isEmpty) {
        return "--";
      }

      if (placeProvider.placeInfo.timeTable[weekday].other == "247") {
        return "Open";
      }

      if (placeProvider.placeInfo.timeTable[weekday].other == "CLOSED") {
        return "Closed";
      }

      TimeOfDay from = TimeOfDay(
          hour: placeProvider.placeInfo.timeTable[weekday].timeFromHour,
          minute: placeProvider.placeInfo.timeTable[weekday].timeFromMinute);
      TimeOfDay to = TimeOfDay(
          hour: placeProvider.placeInfo.timeTable[weekday].timeToHour,
          minute: placeProvider.placeInfo.timeTable[weekday].timeToMinute);
      TimeOfDay now = TimeOfDay.now();

      int _from =
          int.parse("${from.hour}${from.minute < 10 ? "0" : ""}${from.minute}");
      int _to = int.parse("${to.hour}${to.minute < 10 ? "0" : ""}${to.minute}");
      int _now =
          int.parse("${now.hour}${now.minute < 10 ? "0" : ""}${now.minute}");

      if (_now > _to || _now < _from) {
        return "Closed";
      }

      if (_now < _to && _now > _from) {
        return "Open";
      }

      return "--";
    }

    return Scaffold(
      appBar: isMobile(context)
          ? AppBar(
              backgroundColor: colorBG2,
              foregroundColor: textColor2,
              elevation: 0,
              // leading: Material(
              //     color: Colors.transparent,
              //     child: IconButton(
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //         icon: Icon(
              //           Icons.arrow_left_outlined,
              //           size: 36,
              //         ))),
              title: const Text("Place Details"),
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey<int>(placeProvider.loading.length),
          child: placeProvider.loading.contains("place-info")
              ? const PlaceInfoShimmer()
              : Container(
                  color: colorBG1,
                  child: Column(children: [
                    Expanded(
                        child: ListView(children: [
                      Stack(children: [
                        Image.network(
                          placeProvider.placeInfo.photos.isNotEmpty
                              ? placeProvider.placeInfo.photos.first.large!
                              : placeholderImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: height * .5,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: double.infinity,
                            height: height * .5,
                            color: colorBG1.withOpacity(.1),
                          ),
                        ),
                        Positioned(
                            right: 10,
                            bottom: 10,
                            child: Button(
                                label: "Photos",
                                icon: Icons.photo_filter_rounded,
                                backgroundColor: colorBG2,
                                borderColor: textColor2,
                                borderRadius: 100,
                                textColor: textColor2,
                                onPress: () {
                                  openImageViewer(context, 0);
                                }))
                      ]),
                      // CarouselSlider(
                      //     items: List.generate(
                      //         placeProvider.placeInfo.photos.isNotEmpty
                      //             ? placeProvider.placeInfo.photos.length
                      //             : 1,
                      //         (index) => ImageCarousel(
                      //               photo: placeProvider
                      //                       .placeInfo.photos.isNotEmpty
                      //                   ? placeProvider.placeInfo.photos[index]
                      //                   : Photo(medium: placeholderImage),
                      //               onPress: () =>
                      //                   openImageViewer(context, index),
                      //             )),
                      //     options: CarouselOptions(
                      //       enableInfiniteScroll: false,
                      //       aspectRatio: 1,
                      //       autoPlay: true,
                      //       enlargeCenterPage: true,
                      //       onPageChanged: (index, reason) {
                      //         _currentIndex = index;
                      //         setState(() {});
                      //       },
                      //       pageViewKey:
                      //           const PageStorageKey<String>('carousel_slider'),
                      //     )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: HORIZONTAL_PADDING),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconText(
                                        size: 18,
                                        label: placeProvider.placeInfo.name,
                                        fontWeight: FontWeight.bold,
                                        color: textColor2,
                                      ),
                                      Text(
                                        placeProvider.placeInfo.address,
                                        style: TextStyle(color: textColor1),
                                      ),
                                    ]),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: placeProvider.placeInfo.isLiked
                                          ? Colors.red[100]
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: IconButton(
                                      onPressed: () {
                                        if (userProvider.currentUser == null) {
                                          showModalBottomSheet(
                                              context: context,
                                              isDismissible: false,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext newContext,
                                                        StateSetter
                                                            setModalState) {
                                                  return ActionModal(
                                                    isLoading: true,
                                                    title: "Account Required.",
                                                    subTitle:
                                                        "This action requires an account.",
                                                    confirmAction:
                                                        "Log In/SignUp",
                                                    callback: (action) {
                                                      if (action !=
                                                          "Log In/SignUp") {
                                                        return;
                                                      }
                                                      Navigator.pushNamed(
                                                          context, "/auth");
                                                    },
                                                  );
                                                });
                                              });
                                          return;
                                        }

                                        placeProvider.likePlace(
                                            mode: "single",
                                            index: -1,
                                            placeId: placeProvider.placeInfo.id,
                                            callback: (code, message) {
                                              launchSnackbar(
                                                  context: context,
                                                  mode: code == 200
                                                      ? "SUCCESS"
                                                      : "ERROR",
                                                  message: code == 200
                                                      ? message
                                                      : "Failed to submit like.");
                                            });
                                      },
                                      icon: placeProvider.placeInfo.isLiked
                                          ? const Icon(Icons.favorite_rounded)
                                          : const Icon(Icons.favorite_border),
                                      color: placeProvider.placeInfo.isLiked
                                          ? Colors.red
                                          : textColor2))
                            ]),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: HORIZONTAL_PADDING),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FeatureBadge(
                                    icon: Icons.star_rate_rounded,
                                    accentColor: Colors.red,
                                    label: "Rating",
                                    value:
                                        "${placeProvider.placeInfo.reviewsStat.average.toStringAsFixed(1)} (${NumberFormat.compact(locale: "en_US").format(placeProvider.placeInfo.reviewsStat.reviewerCount)})"),
                                FeatureBadge(
                                    icon: Icons.directions,
                                    accentColor: Colors.blue,
                                    label: "Distance",
                                    value:
                                        "${locationProvider.distance.toStringAsFixed(2)}km"),
                                FeatureBadge(
                                    icon: Icons.door_sliding_rounded,
                                    accentColor: Colors.green,
                                    label:
                                        placeProvider.placeInfo.categoryId.name,
                                    value: getIsOpenClose())
                              ])),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: HORIZONTAL_PADDING),
                        child: Text(
                          placeProvider.placeInfo.description,
                          style: TextStyle(height: 1.5, color: textColor2),
                        ),
                      ),
                      if (placeProvider.placeInfo.timeTable.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(children: [
                            const SizedBox(
                              height: 40,
                            ),
                            IconText(
                              label: "Open/Close Time",
                              icon: Icons.more_time_rounded,
                              color: textColor2,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TimeTableDisplay(
                                timeTable: placeProvider.placeInfo.timeTable),
                          ]),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      DiamondBorder(),
                      if (placeProvider.recentReview != null)
                        Column(children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconText(
                                  icon: Icons.reviews_outlined,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: HORIZONTAL_PADDING),
                                  label: "Recent Review",
                                  color: textColor2,
                                ),
                                Button(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: HORIZONTAL_PADDING),
                                    borderColor: Colors.transparent,
                                    textColor: Colors.yellow,
                                    fontSize: 13,
                                    backgroundColor: Colors.transparent,
                                    icon: Icons.reviews_rounded,
                                    label: "All Reviews",
                                    onPress: () {
                                      Provider.of<LocationProvider>(context,
                                              listen: false)
                                          .setDestination(
                                              placeProvider.placeInfo);
                                      Navigator.pushNamed(
                                          context, '/review/list');
                                    }),
                              ]),
                          ReviewItem(review: placeProvider.recentReview!),
                        ]),
                      const SizedBox(
                        height: 20,
                      ),
                    ])),
                    Container(
                      decoration: BoxDecoration(
                          color: colorBG2,
                          border: Border(
                              top: BorderSide(color: Colors.white, width: 2))),
                      padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 10),
                      child: Row(
                        children: [
                          Button(
                              borderColor: Colors.transparent,
                              backgroundColor: Colors.amber,
                              textColor: Colors.black,
                              icon: Icons.reviews_rounded,
                              borderRadius: 0,
                              label: "Add Review",
                              onPress: () {
                                if (userProvider.currentUser == null) {
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
                                            title: "Account Required.",
                                            subTitle:
                                                "This action requires an account.",
                                            confirmAction: "Log In/SignUp",
                                            callback: (action) {
                                              if (action != "Log In/SignUp") {
                                                return;
                                              }
                                              Navigator.pushNamed(
                                                  context, "/auth");
                                            },
                                          );
                                        });
                                      });
                                  return;
                                }

                                Navigator.pushNamed(context, "/review/add");
                              }),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Button(
                                borderColor: Colors.transparent,
                                backgroundColor: Colors.red[700],
                                borderRadius: 0,
                                icon: Icons.map_rounded,
                                label: "Show on Map",
                                onPress: () {
                                  Provider.of<LocationProvider>(context,
                                          listen: false)
                                      .setDestination(placeProvider.placeInfo);
                                  Navigator.pushNamed(context, "/mapview");
                                }),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
        ),
      ),
    );
  }
}

class FeatureBadge extends StatelessWidget {
  Color accentColor;
  String label;
  String value;
  IconData icon;
  FeatureBadge(
      {Key? key,
      required this.accentColor,
      required this.label,
      required this.icon,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: textColor2,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 25,
            color: accentColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconText(
              label: label,
              color: textColor2,
            ),
            IconText(
              label: value,
              color: textColor2,
              fontWeight: FontWeight.bold,
            )
          ],
        )
      ],
    );
  }
}
