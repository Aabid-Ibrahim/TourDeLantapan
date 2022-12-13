import 'dart:ui';

import 'package:app/models/place_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/screens/guest/place_info.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/grid_count.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/utilities/you_are_offline.dart';
import 'package:app/widgets/action_modal.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/place_card.dart';
import 'package:app/widgets/shape/diamond_border.dart';
import 'package:app/widgets/shimmer/place_card_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class PlacesList extends StatefulWidget {
  Function onPlaceTap;
  Map<String, dynamic> arguments;
  PlacesList({Key? key, required this.arguments, required this.onPlaceTap})
      : super(key: key);

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  fetchPlaces() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (ConnectivityResult.none == connectivityResult) {
      if (!mounted) return;
      Provider.of<PlaceProvider>(context, listen: false)
          .loadPlacesOffline(mode: widget.arguments["mode"]);
      return;
    }
    if (!mounted) return;
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

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      fetchPlaces();
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    hasNoContent() {
      if (widget.arguments["mode"] == "popular") {
        return placeProvider.popularPlaces.isEmpty;
      }
      if (widget.arguments["mode"] == "new") {
        return placeProvider.newPlaces.isEmpty;
      }
      if (widget.arguments["mode"] == "top_rated") {
        return placeProvider.topRatedPlaces.isEmpty;
      }
      return false;
    }

    return SafeArea(
        bottom: true,
        child: Column(
          children: [
            if (placeProvider.loading.contains(widget.arguments["mode"]))
              PlaceCardShimmer()
            else if (!hasNoContent())
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
                    itemCount: widget.arguments["mode"] == "popular"
                        ? placeProvider.popularPlaces.length
                        : widget.arguments["mode"] == "new"
                            ? placeProvider.newPlaces.length
                            : widget.arguments["mode"] == "top_rated"
                                ? placeProvider.topRatedPlaces.length
                                : 0,
                    itemBuilder: (BuildContext context, int index) {
                      late Place place;

                      if (widget.arguments["mode"] == "popular") {
                        place = placeProvider.popularPlaces[index];
                      }
                      if (widget.arguments["mode"] == "new") {
                        place = placeProvider.newPlaces[index];
                      }
                      if (widget.arguments["mode"] == "top_rated") {
                        place = placeProvider.topRatedPlaces[index];
                      }

                      Widget getTopLeft() {
                        if (widget.arguments["mode"] == "top_rated") {
                          return IconText(
                              icon: Icons.star,
                              backgroundColor: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              size: 12,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              borderRadius: 0,
                              label:
                                  "${place.reviewsStat.average.toStringAsFixed(1)} / ${place.reviewsStat.reviewerCount} review${place.reviewsStat.reviewerCount > 1 ? "s" : ""}");
                        }
                        if (widget.arguments["mode"] == "popular") {
                          return IconText(
                              icon: Icons.favorite,
                              backgroundColor: Colors.yellow,
                              color: Colors.black,
                              padding: const EdgeInsets.all(10),
                              borderRadius: 0,
                              label: "${place.favorites.count}");
                        }
                        return Container();
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: PlaceCard(
                                photoUrl: place.photos.isNotEmpty
                                    ? place.photos[0].small
                                    : placeholderImage,
                                onPress: () {
                                  if (!isMobile(context)) {
                                    widget.onPlaceTap(place.id);
                                    return;
                                  }

                                  Navigator.pushNamed(context, "/place/info",
                                          arguments: {"placeId": place.id})
                                      .then((value) => fetchPlaces());
                                },
                                topLeft: getTopLeft(),
                                bottomRight: Container(
                                    decoration: BoxDecoration(
                                        color: textColor2,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: IconButton(
                                        onPressed: () {
                                          if (userProvider.currentUser ==
                                              null) {
                                            showModalBottomSheet(
                                                context: context,
                                                isDismissible: false,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                      builder: (BuildContext
                                                              newContext,
                                                          StateSetter
                                                              setModalState) {
                                                    return ActionModal(
                                                      isLoading: true,
                                                      title:
                                                          "Account Required.",
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
                                              mode: widget.arguments["mode"],
                                              index: index,
                                              placeId: place.id,
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
                                        icon: Icon(
                                          !place.isLiked
                                              ? Icons.favorite_border_outlined
                                              : Icons.favorite_rounded,
                                          color: Colors.red,
                                        ))),
                                upperLabelWidget: RatingBar.builder(
                                  initialRating: place.reviewsStat.average,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  unratedColor: textColor2,
                                  itemCount: 5,
                                  itemSize: 15,
                                  itemPadding: const EdgeInsets.only(
                                      right: 2, bottom: 5),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                label: place.name,
                                subLabel: place.address),
                          ),
                          DiamondBorder()
                        ],
                      );
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
        ));
  }
}
