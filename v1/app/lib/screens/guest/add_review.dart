import 'dart:io';

import 'package:app/models/place_model.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/review_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/add_photo.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/form/form-theme.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AddReview extends StatefulWidget {
  AddReview({Key? key}) : super(key: key);

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  Map<String, dynamic> payload = {"placeId": "", "content": "", "rating": 0.0};
  Map<String, dynamic> _payload = {};
  List<PlatformFile> photos = [];

  bool validateForm() {
    if (payload["content"].isEmpty) {
      launchSnackbar(
          context: context, mode: "ERROR", message: "Write your review.");
      return false;
    }
    if (payload["rating"] == 0.0) {
      launchSnackbar(
          context: context, mode: "ERROR", message: "Set your rating.");
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _payload = {...payload};
    payload["placeId"] =
        Provider.of<PlaceProvider>(context, listen: false).placeInfo.id;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();
    ReviewProvider reviewProvider = context.watch<ReviewProvider>();

    Widget submitButton() {
      return Button(
          margin: EdgeInsets.symmetric(vertical: isMobile(context) ? 0 : 5),
          borderColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          label: "Submit Review",
          onPress: () {
            bool res = validateForm();
            if (res) {
              reviewProvider.postReview(
                  payload: payload,
                  files: photos,
                  callback: (code, message) {
                    if (code == 200) {
                      launchSnackbar(
                          context: context,
                          mode: "SUCCESS",
                          message: message ?? "Success!");
                      setState(() {
                        photos = [];
                        payload = _payload;
                      });
                      placeProvider.getPlace(
                          placeId: placeProvider.placeInfo.id, callback: () {});
                      Navigator.pop(context);
                      return;
                    }
                    if (code != 200) {
                      launchSnackbar(
                          context: context,
                          mode: code == 200 ? "SUCCESS" : "ERROR",
                          message: message ?? "Error!");
                    }
                  });
            }
          });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: .5,
          backgroundColor: colorBG2,
          foregroundColor: textColor2,
          title: const Text("Add Review"),
          actions: [
            if (!isMobile(context)) submitButton(),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        body: SafeArea(
          bottom: true,
          child: Column(children: [
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
                        errorBuilder: (context, error, stackTrace) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                            )),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconText(
                          label: placeProvider.placeInfo.name,
                          color: textColor2,
                          fontWeight: FontWeight.bold,
                        ),
                        IconText(
                          label: placeProvider.placeInfo.address,
                          color: textColor1,
                        )
                      ])
                ])),
            if (reviewProvider.loading.contains("post-review"))
              const LinearProgressIndicator(),
            Expanded(
              child: Container(
                color: colorBG1,
                child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: !isMobile(context)
                            ? MediaQuery.of(context).size.width * .3
                            : HORIZONTAL_PADDING),
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      AddPhotos(
                          photos: photos,
                          foregroundColor: textColor2,
                          onDeletePhoto: (index) =>
                              setState(() => photos.removeAt(index)),
                          onAddPhotos: (List<PlatformFile> photos) {
                            setState(() => this.photos = photos);
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      RatingBar.builder(
                        initialRating: payload["rating"] ?? 0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 35,
                        unratedColor: Colors.white30,
                        wrapAlignment: WrapAlignment.center,
                        textDirection: TextDirection.rtl,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            payload["rating"] = rating;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLines: null,
                        onChanged: (e) =>
                            setState(() => payload["content"] = e.trim()),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "This field is required";
                          }
                        },
                        style: TextStyle(color: textColor2),
                        decoration: textFieldStyle(label: "Write your review"),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ]),
              ),
            ),
            if (isMobile(context))
              Container(
                  color: colorBG2,
                  padding: const EdgeInsets.only(
                      top: 15,
                      left: 15,
                      right: 15,
                      // bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                      bottom: 15),
                  child: submitButton())
          ]),
        ));
  }
}
