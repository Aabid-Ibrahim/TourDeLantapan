import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  MainAxisAlignment? mainAxisAlignment;
  double? textWidthInPercentage;
  IconData? icon;
  String label;
  double? size;
  Color? color;
  FontWeight? fontWeight;
  EdgeInsets? padding;
  Color? backgroundColor;
  double? borderRadius;
  double? width;
  double? height;
  IconText(
      {Key? key,
      this.icon,
      required this.label,
      this.size,
      this.width,
      this.height,
      this.color,
      this.fontWeight,
      this.mainAxisAlignment,
      this.backgroundColor,
      this.borderRadius,
      this.textWidthInPercentage,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 0)),
      padding: padding ?? const EdgeInsets.all(0),
      child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: size ?? 13,
                color: color ?? Colors.green,
              ),
            if (icon != null) const SizedBox(width: 5),
            SizedBox(
              width: textWidthInPercentage != null
                  ? MediaQuery.of(context).size.width * textWidthInPercentage!
                  : null,
              child: Text(
                label,
                style: TextStyle(
                    fontSize: size ?? 13,
                    color: color ?? Colors.green,
                    fontWeight: fontWeight ?? FontWeight.normal),
              ),
            )
          ]),
    );
  }
}
