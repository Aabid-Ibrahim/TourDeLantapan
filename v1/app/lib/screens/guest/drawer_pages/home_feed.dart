import 'package:app/provider/place_provider.dart';
import 'package:app/screens/guest/place_info.dart';
import 'package:app/screens/guest/places_list.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/shape/inverted_triangle.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class HomeFeed extends StatefulWidget {
  HomeFeed({Key? key}) : super(key: key);

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String placeId = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<PlaceProvider>(context, listen: false).getPlaceIds();
    });
    super.initState();
  }

  void _openEndDrawer(String placeId) {
    setState(() {
      this.placeId = placeId;
    });
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: colorBG1,
          endDrawer: Drawer(
              width: MediaQuery.of(context).size.width * .30,
              child: PlaceInfo(arguments: {"placeId": placeId})),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: colorBG2,
              actions: <Widget>[Container()],
              flexibleSpace: Center(
                child: TabBar(
                  isScrollable: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  labelColor: textColor2,
                  unselectedLabelColor: textColor1,
                  indicator: MaterialIndicator(
                      color: textColor2,
                      bottomLeftRadius: 100,
                      bottomRightRadius: 100,
                      topLeftRadius: 100,
                      topRightRadius: 100),
                  tabs: const [
                    Tab(text: 'Popular'),
                    Tab(text: 'New'),
                    Tab(text: 'Top Rated'),
                  ],
                ),
              )),
          body: Stack(
            children: [
              Expanded(
                  child: TabBarView(children: [
                PlacesList(
                  onPlaceTap: (id) => _openEndDrawer(id),
                  arguments: const {
                    "mode": "popular",
                  },
                ),
                PlacesList(
                  onPlaceTap: (id) => _openEndDrawer(id),
                  arguments: const {
                    "mode": "new",
                  },
                ),
                PlacesList(
                  onPlaceTap: (id) => _openEndDrawer(id),
                  arguments: const {
                    "mode": "top_rated",
                  },
                ),
              ])),
            ],
          )),
    );
  }
}
