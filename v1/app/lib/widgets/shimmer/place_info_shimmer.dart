import 'package:app/utilities/constants.dart';
import 'package:flutter/material.dart';

class PlaceInfoShimmer extends StatefulWidget {
  const PlaceInfoShimmer({Key? key}) : super(key: key);

  @override
  State<PlaceInfoShimmer> createState() => _PlaceInfoShimmerState();
}

class _PlaceInfoShimmerState extends State<PlaceInfoShimmer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationControllerB;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animationControllerB =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationControllerB.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationControllerB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBG2.withOpacity(.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _animationController,
            child: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: colorBG2,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          FadeTransition(
            opacity: _animationController,
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
                height: 20,
                width: MediaQuery.of(context).size.width * .20,
                decoration: BoxDecoration(
                  color: colorBG1,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          FadeTransition(
            opacity: _animationController,
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
                height: 20,
                width: MediaQuery.of(context).size.width * .30,
                decoration: BoxDecoration(
                  color: colorBG1,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          FadeTransition(
            opacity: _animationControllerB,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: HORIZONTAL_PADDING),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: colorBG1,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)))),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: HORIZONTAL_PADDING),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: colorBG1,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)))),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: HORIZONTAL_PADDING),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: colorBG1,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
