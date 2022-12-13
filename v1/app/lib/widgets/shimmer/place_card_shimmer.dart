import 'package:app/utilities/constants.dart';
import 'package:flutter/material.dart';

class PlaceCardShimmer extends StatefulWidget {
  Color? color;
  PlaceCardShimmer({Key? key, this.color}) : super(key: key);

  @override
  State<PlaceCardShimmer> createState() => _PlaceCardShimmerState();
}

class _PlaceCardShimmerState extends State<PlaceCardShimmer>
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
        height: MediaQuery.of(context).size.height * .40,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: widget.color ?? Colors.red.withOpacity(.5),
            borderRadius: const BorderRadius.all(Radius.circular(0))),
      ),
    );
  }
}
