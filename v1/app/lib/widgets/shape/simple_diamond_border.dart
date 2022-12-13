import 'package:app/utilities/constants.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';

class SimpleDiamondBorder extends StatelessWidget {
  double? size;
  int? length;
  SimpleDiamondBorder({Key? key, this.size, this.length}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ...List.generate(
          length ?? 10,
          (index) => Column(
            children: [
              CustomPaint(
                  painter: TrianglePainter(
                    strokeColor: colorBG2,
                    strokeWidth: 0,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  child: Container(
                    height: size ?? 15,
                    width: size != null ? size! + 5 : 20,
                  )),
              Transform.rotate(
                  angle: 3.14 / 1,
                  child: CustomPaint(
                      painter: TrianglePainter(
                        strokeColor: colorBG2,
                        strokeWidth: 0,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      child: Container(
                        height: size ?? 15,
                        width: size != null ? size! + 5 : 20,
                      )))
            ],
          ),
        )
      ]),
    );
  }
}
