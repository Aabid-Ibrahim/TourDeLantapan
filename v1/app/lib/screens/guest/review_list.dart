import 'package:app/models/review_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/review_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/action_modal.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/review_item.dart';
import 'package:app/widgets/shape/diamond_border.dart';
import 'package:app/widgets/shape/simple_diamond_border.dart';
import 'package:app/widgets/shape/square_border.dart';
import 'package:app/widgets/shimmer/place_card_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  ReviewList({Key? key}) : super(key: key);

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      getReviews();
    }();
    super.initState();
  }

  void getReviews() {
    Provider.of<ReviewProvider>(context, listen: false).getReviews(
        placeId:
            Provider.of<PlaceProvider>(context, listen: false).placeInfo.id,
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
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();
    ReviewProvider reviewProvider = context.watch<ReviewProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: colorBG2,
        foregroundColor: textColor2,
        title: const Text("Reviews"),
      ),
      backgroundColor: colorBG1,
      body: Column(
        children: [
          Container(
              color: colorBG2,
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: HORIZONTAL_PADDING),
              child: Row(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      placeProvider.placeInfo.photos.isNotEmpty
                          ? placeProvider.placeInfo.photos[0].small!
                          : placeholderImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  width: 15,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  IconText(
                    label: placeProvider.placeInfo.name,
                    color: textColor2,
                    fontWeight: FontWeight.bold,
                  ),
                  IconText(
                    label: placeProvider.placeInfo.address,
                    color: textColor2,
                  )
                ])
              ])),
          if (reviewProvider.loading.contains("review-delete"))
            const LinearProgressIndicator(),
          if (reviewProvider.loading.contains("reviews-list"))
            PlaceCardShimmer()
          else
            Expanded(
                child: ListView.builder(
                    itemCount: reviewProvider.reviewList.length,
                    itemBuilder: (context, index) {
                      Review review = reviewProvider.reviewList[index];
                      return Column(
                        children: [
                          ReviewItem(
                            review: review,
                            onDelete: userProvider.currentUser != null &&
                                    userProvider.currentUser!.scope
                                        .contains("ADMIN")
                                ? () {
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
                                                  return;
                                                }
                                                Navigator.pop(context);
                                                reviewProvider.deleteReview(
                                                    reviewId: review.id,
                                                    callback: (code, message) {
                                                      if (code == 200) {
                                                        getReviews();
                                                      }
                                                      launchSnackbar(
                                                          context: context,
                                                          mode: code == 200
                                                              ? "SUCCESS"
                                                              : "ERROR",
                                                          message: message);
                                                    });
                                              },
                                            );
                                          });
                                        });
                                  }
                                : null,
                          ),
                        ],
                      );
                    }))
        ],
      ),
    );
  }
}
