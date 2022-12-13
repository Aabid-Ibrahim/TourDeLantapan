import 'package:app/utilities/grid_count.dart';
import 'package:app/widgets/shimmer/box_shimmer.dart';
import 'package:flutter/material.dart';

class GridShimmer extends StatelessWidget {
  double? borderRadius;
  double? childAspectRatio;
  int? itemCount;
  GridShimmer(
      {Key? key, this.borderRadius, this.childAspectRatio, this.itemCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 20,
            mainAxisSpacing: 40,
            crossAxisCount: getGridCount(MediaQuery.of(context).size.width),
          ),
          itemCount: itemCount ?? 3,
          itemBuilder: (context, index) {
            return BoxShimmer(
              borderRadius: borderRadius ?? 0,
            );
          }),
    );
  }
}
