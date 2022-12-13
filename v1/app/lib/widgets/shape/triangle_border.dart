import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';

class TraingleBorder extends StatelessWidget {
  const TraingleBorder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(
        strokeColor: Colors.blue,
        strokeWidth: 10,
        paintingStyle: PaintingStyle.fill,
      ),
      child: Container(
        height: 180,
        width: 200,
      ),
    );
  }
}
