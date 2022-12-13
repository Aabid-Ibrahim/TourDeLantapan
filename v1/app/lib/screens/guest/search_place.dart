import 'package:app/models/place_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/debouncer.dart';
import 'package:app/utilities/grid_count.dart';
import 'package:app/widgets/action_modal.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/place_card.dart';
import 'package:app/widgets/search_bar.dart';
import 'package:app/widgets/shape/diamond_border.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SearchPlace extends StatelessWidget {
  const SearchPlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 1000);
    PlaceProvider placeProvider = context.watch<PlaceProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    String searchKey = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBG2,
        foregroundColor: textColor2,
        elevation: .5,
        title: const Text("Search for Places"),
      ),
      body: Container(
        color: colorBG1,
        child: Column(
          children: [
            if (placeProvider.loading.contains("search"))
              const LinearProgressIndicator(
                color: Colors.red,
                backgroundColor: Colors.blue,
              ),
            const SizedBox(
              height: 0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
              child: SearchBar(
                  searchKey: searchKey,
                  backgroundColor: colorBG2,
                  textColor: textColor1.withOpacity(.5),
                  onChanged: (val) {
                    if (val.isEmpty) {
                      return;
                    }

                    searchKey = val;

                    _debouncer.run(() {
                      placeProvider.getPlaces(
                          query: {"mode": "search", "searchKey": val},
                          callback: (code, message) {
                            if (code != 200) {
                              launchSnackbar(
                                  context: context,
                                  mode: code == 200 ? "SUCCESS" : "ERROR",
                                  message: message ?? "Error!");
                            }
                          });
                    });
                  }),
            ),
            const SizedBox(
              height: 0,
            ),
            if (placeProvider.searchResult.isEmpty)
              IconText(
                mainAxisAlignment: MainAxisAlignment.center,
                padding: const EdgeInsets.only(top: 50),
                label: "No result",
                color: Colors.black54,
                icon: Icons.air_rounded,
                size: 20,
                fontWeight: FontWeight.bold,
              )
            else if (placeProvider.searchResult.isNotEmpty)
              Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: HORIZONTAL_PADDING, vertical: 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount:
                            getGridCount(MediaQuery.of(context).size.width),
                      ),
                      itemCount: placeProvider.searchResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        Place place = placeProvider.searchResult[index];
                        return Column(children: [
                          Expanded(
                            child: PlaceCard(
                                photoUrl: place.photos.isNotEmpty
                                    ? place.photos[0].small
                                    : placeholderImage,
                                onPress: () {
                                  Navigator.pushNamed(context, "/place/info",
                                      arguments: {"placeId": place.id});
                                },
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
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: textColor2,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
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
                                              mode: "search",
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
                                label: place.name,
                                subLabel: place.address),
                          ),
                          DiamondBorder()
                        ]);
                      }))
          ],
        ),
      ),
    );
  }
}
