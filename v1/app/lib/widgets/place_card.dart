import 'package:app/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  Function onPress;
  String label;
  String? photoUrl;
  Widget? topLeft;
  Widget? topRight;
  Widget? bottomRight;
  Widget? upperLabelWidget;
  Function(TapDownDetails)? onTapDown;
  Function? onLongPress;
  String? subLabel;
  PlaceCard(
      {Key? key,
      required this.onPress,
      required this.label,
      this.onTapDown,
      this.onLongPress,
      this.topLeft,
      this.topRight,
      this.subLabel,
      this.bottomRight,
      this.upperLabelWidget,
      this.photoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.white, width: 4),
        color: Colors.grey[300],
        // image: DecorationImage(
        //   image: NetworkImage(photoUrl ?? placeholderImage),
        //   fit: BoxFit.cover,
        // ),
        image: DecorationImage(
          image: CachedNetworkImageProvider(photoUrl ?? placeholderImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTapDown: onTapDown,
          onLongPress: onLongPress == null ? null : () => onLongPress!(),
          onTap: () => onPress(),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              child: Stack(
                children: <Widget>[
                  if (topLeft != null)
                    Positioned(
                        top: 15, left: 15, child: topLeft ?? Container()),
                  if (topRight != null)
                    Positioned(
                        top: 5, right: 5, child: topRight ?? Container()),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(26, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (upperLabelWidget != null)
                                      upperLabelWidget!,
                                    Text(label,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: textColor2,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    if (subLabel != null)
                                      Text(subLabel ?? "",
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: textColor2,
                                            fontSize: 16.0,
                                          )),
                                  ]),
                            ),
                            bottomRight ?? Container()
                          ]),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
