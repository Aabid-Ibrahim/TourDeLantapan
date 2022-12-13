import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  double? heightInPercentage;
  Widget content;
  String title;
  Color? bgColor;
  Color? textColor;
  Modal(
      {Key? key,
      required this.content,
      required this.title,
      this.bgColor,
      this.textColor,
      this.heightInPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: isMobile(context) ? 0 : width * .3),
      height: height * (heightInPercentage ?? 0.70),
      width: isMobile(context) ? width * .90 : width * .30,
      decoration: BoxDecoration(
          color: bgColor ?? colorBG1,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: (height * 0.70) * .07),
              child: content),
          Container(
              padding: const EdgeInsets.only(left: 15),
              height: (height * 0.70) * .07,
              decoration: BoxDecoration(
                  color: bgColor ?? colorBG2,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor ?? textColor2),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: textColor ?? textColor2,
                          )),
                    ),
                  ]))
        ],
      ),
    );
  }
}
