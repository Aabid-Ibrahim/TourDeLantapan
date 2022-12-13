import 'package:app/models/category_model.dart';
import 'package:app/models/dashboard/dashboard_count.dart';
import 'package:app/models/dashboard/dashboard_like.dart';
import 'package:app/provider/dashboard_provider.dart';
import 'package:app/widgets/chips.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/shimmer/place_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class MostPopular extends StatefulWidget {
  List<DashboardLikes> likes;
  Function? onFilter;
  MostPopular({Key? key, this.onFilter, required this.likes}) : super(key: key);
  @override
  MostPopularState createState() => MostPopularState();
}

class MostPopularState extends State<MostPopular> {
  Map<String, dynamic> query = {};
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider = context.watch<DashboardProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconText(
                icon: Icons.favorite,
                mainAxisAlignment: MainAxisAlignment.start,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                size: 17,
                label: "Most Popular (Likes)"),
            if (!dashboardProvider.loading.contains("count"))
              Wrap(children: [
                ...List.generate(
                    dashboardProvider
                        .dashboardCount.totalPlacesByCategory.length, (index) {
                  TotalPlacesByCategory totalPlacesByCategory =
                      dashboardProvider
                          .dashboardCount.totalPlacesByCategory[index];
                  List<Category> category = categories
                      .where((e) => e.id == totalPlacesByCategory.id)
                      .toList();
                  return Chippy(
                      label: category[0].name,
                      backgroundColor:
                          query['categoryId'] == totalPlacesByCategory.id
                              ? Colors.black
                              : Colors.grey,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      onPress: () {
                        setState(() {
                          query = {
                            ...query,
                            "categoryId":
                                query['categoryId'] == totalPlacesByCategory.id
                                    ? null
                                    : totalPlacesByCategory.id
                          };
                        });

                        if (widget.onFilter != null) {
                          widget.onFilter!(query);
                        }
                      });
                })
              ]),
          ]),
          const SizedBox(
            height: 10,
          ),
          if (dashboardProvider.loading.contains("likes"))
            PlaceCardShimmer(
              color: Colors.grey,
            )
          else
            SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis:
                    NumericAxis(minimum: 0, maximum: 40, interval: 10),
                onTooltipRender: (TooltipArgs args) {
                  DashboardLikes dashboardLikes =
                      widget.likes[args.pointIndex!.toInt()];

                  args.header = "${dashboardLikes.name} Likes";

                  args.text = dashboardLikes.favorites.count.toString();
                },
                tooltipBehavior: _tooltip,
                series: <ChartSeries<DashboardLikes, String>>[
                  ColumnSeries<DashboardLikes, String>(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      width: 0.5,
                      dataSource: widget.likes,
                      xValueMapper: (DashboardLikes data, _) => data.name,
                      yValueMapper: (DashboardLikes data, _) =>
                          data.favorites.count,
                      color: Colors.red)
                ]),
        ],
      ),
    );
  }
}
