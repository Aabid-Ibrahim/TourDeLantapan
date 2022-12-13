import 'package:flutter/material.dart';

class BoxShimmer extends StatefulWidget {
  double? heightInPercentage;
  double? borderRadius;
  BoxShimmer({Key? key, this.borderRadius, this.heightInPercentage})
      : super(key: key);

  @override
  State<BoxShimmer> createState() => _BoxShimmerState();
}

class _BoxShimmerState extends State<BoxShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius ?? 15))),
      ),
    );
  }
}

  // height: MediaQuery.of(context).size.height *
  //           (widget.heightInPercentage ?? .40),
  //       width: MediaQuery.of(context).size.width,
  //       margin: const EdgeInsets.all(15),