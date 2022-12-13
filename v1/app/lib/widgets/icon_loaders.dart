import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

showDoubleBounce({double? size, Color? color}) {
  Color colorA = color ?? Colors.red;
  Color colorB =
      color != null ? color.withOpacity(0.7) : Colors.red.withOpacity(0.7);

  return SpinKitDoubleBounce(
    size: size ?? 30,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: index.isEven ? colorA : colorB,
        ),
      );
    },
  );
}
