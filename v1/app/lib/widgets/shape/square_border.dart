import 'package:app/utilities/constants.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';

class SquareBorder extends StatelessWidget {
  double? size;
  int? count;
  SquareBorder({Key? key, this.count, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ...List.generate(
          count ?? 25,
          (index) => Row(children: [
            Container(
              height: size ?? 10,
              width: size ?? 10,
              color: Colors.white,
            ),
            Container(
              height: size ?? 10,
              width: size ?? 10,
              color: Colors.black,
            ),
          ]),
        )
      ]),
    );
  }
}
