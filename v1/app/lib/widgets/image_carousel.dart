import 'package:app/models/photo_model.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  Photo? photo;
  AssetImage? assetImage;
  Function onPress;
  double? borderRadius;
  Widget? bottomLabel;
  ImageCarousel(
      {Key? key,
      this.photo,
      this.borderRadius,
      this.bottomLabel,
      this.assetImage,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
            image: photo?.medium != null
                ? DecorationImage(
                    image: NetworkImage(photo!.medium ?? ""),
                    fit: BoxFit.cover,
                  )
                : DecorationImage(
                    image: AssetImage(assetImage!.assetName),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onPress(),
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        )),
        if (bottomLabel != null) bottomLabel!
      ],
    );
  }
}
