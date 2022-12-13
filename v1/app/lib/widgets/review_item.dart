import 'package:app/models/review_model.dart';
import 'package:app/screens/image-viewer.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewItem extends StatelessWidget {
  Review review;
  Function? onDelete;
  ReviewItem({Key? key, required this.review, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openImageViewer(BuildContext context, final int index) {
      if (review.photos.isEmpty) {
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhotoViewWrapper(
            galleryItems: review.photos,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            initialIndex: index,
            scrollDirection: Axis.horizontal,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                review.userId.photo?.small != null
                    ? review.userId.photo!.small!
                    : placeholderImage,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) => ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                  ),
                ),
                fit: BoxFit.cover,
              )),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconText(
                label: review.userId.fullName,
                color: textColor2,
                fontWeight: FontWeight.bold),
            RatingBar.builder(
              initialRating: review.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 15,
              wrapAlignment: WrapAlignment.center,
              itemPadding: const EdgeInsets.only(right: 2),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                return;
              },
            ),
          ])
        ]),
        const SizedBox(height: 15),
        Text(
          review.content,
          style:
               TextStyle(color: textColor2, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 10),
        if (review.photos.isNotEmpty)
          SizedBox(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.photos.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () => openImageViewer(context, index),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image.network(
                                review.photos[index].small ?? placeholderImage,
                                width: 150,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ))),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconText(
            label: DateFormat("MMM dd, yyyy").format(review.createdAt),
            color: textColor2,
            size: 12,
          ),
          if (onDelete != null)
            InkWell(
                onTap: () => onDelete!(),
                child: IconText(
                  label: "Delete Review",
                  icon: Icons.remove_circle_rounded,
                  fontWeight: FontWeight.bold,
                  color: textColor2,
                ))
        ])
        // const Divider(),
      ]),
    );
  }
}
