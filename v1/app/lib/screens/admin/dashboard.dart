import 'package:app/models/category_model.dart';
import 'package:app/models/dashboard/dashboard_count.dart';
import 'package:app/provider/dashboard_provider.dart';
import 'package:app/screens/admin/likes_bar_chart.dart';
import 'package:app/screens/admin/ratings_bar_chart.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/shimmer/place_card_shimmer.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  apiCallback(code, message) {
    if (code != 200) {
      launchSnackbar(
          context: context,
          mode: code == 200 ? "SUCCESS" : "ERROR",
          message: message ?? "Success!");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<DashboardProvider>(context, listen: false)
          .getCount(callback: apiCallback);
      Provider.of<DashboardProvider>(context, listen: false)
          .getLikesCount(query: {}, callback: apiCallback);
      Provider.of<DashboardProvider>(context, listen: false)
          .getRatingsCount(query: {}, callback: apiCallback);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider = context.watch<DashboardProvider>();

    return Container(
      color: Colors.white,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          children: [
            if (dashboardProvider.loading.contains("count"))
              const Center(child: CircularProgressIndicator())
            else
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(right: 15),
                  width: 150,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconText(
                            label: "Total Places",
                            color: Colors.black,
                            size: 19,
                            fontWeight: FontWeight.bold),
                        IconText(
                            label: dashboardProvider.dashboardCount.totalPlaces
                                .toString(),
                            color: Colors.black,
                            size: 25,
                            fontWeight: FontWeight.bold),
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(right: 15),
                  width: 150,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconText(
                            label: "Total Users",
                            color: Colors.black,
                            size: 19,
                            fontWeight: FontWeight.bold),
                        IconText(
                            label: dashboardProvider.dashboardCount.totalUsers
                                .toString(),
                            color: Colors.black,
                            size: 25,
                            fontWeight: FontWeight.bold)
                      ]),
                ),
              ]),
            const SizedBox(height: 10),
            const Divider(),
            if (dashboardProvider.loading.contains("count"))
              const Center(child: CircularProgressIndicator())
            else
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
                  return Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(right: 15, top: 15),
                    // width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (category.isNotEmpty)
                            IconText(
                                label: category[0].name,
                                icon: category[0].icon,
                                color: Colors.black,
                                size: 19,
                                fontWeight: FontWeight.bold),
                          const SizedBox(height: 5),
                          IconText(
                              label: totalPlacesByCategory.count.toString(),
                              color: Colors.black,
                              size: 25,
                              fontWeight: FontWeight.bold),
                        ]),
                  );
                })
              ]),
            const SizedBox(height: 10),
            const Divider(),
            MostPopular(
              likes: dashboardProvider.dashboardLikes,
              onFilter: (query) {
                Provider.of<DashboardProvider>(context, listen: false)
                    .getLikesCount(query: query, callback: apiCallback);
              },
            ),
            MostRated(
              ratings: dashboardProvider.dashboardRating,
              onFilter: (query) {
                Provider.of<DashboardProvider>(context, listen: false)
                    .getRatingsCount(query: query, callback: apiCallback);
              },
            )
          ]),
    );
  }
}
