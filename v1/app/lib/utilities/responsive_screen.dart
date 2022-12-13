import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  return 600 > MediaQuery.of(context).size.width;
}

double customSize(double screenWidth, Map<String, double> breakpoints) {
  double? size;
  List keys = breakpoints.keys.map((e) => e).toList();
  for (int i = 0; i < keys.length; i++) {
    if (int.parse(keys[i]) > screenWidth) {
      size = breakpoints[keys[i]] as double;
      break;
    }
  }
  if (size != null) {
    return size;
  }
  return screenWidth * .30;
}

// customSize(Map sizes, ) {
//   sizes.map((key, value) => null)
// }


// 320px — 480px: Mobile devices.
// 481px — 768px: iPads, Tablets.
// 769px — 1024px: Small screens, laptops.
// 1025px — 1200px: Desktops, large screens.
// 1201px and more — Extra large screens, TV.