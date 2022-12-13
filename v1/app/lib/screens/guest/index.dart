import 'package:app/models/user_model.dart';
import 'package:app/provider/app_provider.dart';
import 'package:app/provider/location_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/screens/guest/drawer_pages/about_lantapan.dart';
import 'package:app/screens/guest/drawer_pages/contacts.dart';
import 'package:app/screens/guest/drawer_pages/developers.dart';
import 'package:app/screens/guest/drawer_pages/history.dart';
import 'package:app/screens/guest/drawer_pages/home_feed.dart';
import 'package:app/screens/guest/drawer_pages/tourism_staff.dart';
import 'package:app/screens/guest/select_location.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/reverse_geocode.dart';
import 'package:app/utilities/you_are_offline.dart';
import 'package:app/widgets/bottom_modal.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_loaders.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/shape/inverted_triangle.dart';
import 'package:app/widgets/shape/simple_diamond_border.dart';
import 'package:app/widgets/shape/square_border.dart';
import 'package:app/widgets/shape/triangle.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as coords;

class Guest extends StatefulWidget {
  Guest({Key? key}) : super(key: key);

  @override
  State<Guest> createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  PageController page = PageController();
  int pageIndex = 0;
  bool detectingLocation = true;
  late var connectivitySubscription;

  List<IconTextModel> drawerItems = [
    IconTextModel(Icons.home, "Home"),
    IconTextModel(Icons.history_edu_rounded, "History"),
    IconTextModel(Icons.people_alt_rounded, "Tourism Staff"),
    IconTextModel(Icons.info_outline_rounded, "About Lantapan"),
    IconTextModel(Icons.contact_mail_rounded, "Contacts"),
    IconTextModel(Icons.developer_mode_rounded, "Developers"),
    IconTextModel(Icons.qr_code_2_rounded, "Scan QR"),
    IconTextModel(Icons.local_gas_station_rounded, "Nearby Gas Stations"),
  ];

  void setLocation() async {
    if (await isOffline(context)) return;
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Modal(
                title: "Long press to pin your location",
                heightInPercentage: .9,
                content: SelectLocation(
                    value: Provider.of<LocationProvider>(context, listen: false)
                        .coordinates,
                    willDetectLocation:
                        Provider.of<LocationProvider>(context, listen: false)
                            .address
                            .isEmpty,
                    onSelectLocation: (coordinates, address) {
                      Provider.of<LocationProvider>(context, listen: false)
                          .setCoordinates(coordinates, address);
                    }));
          });
        });
  }

  void determinePosition() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (ConnectivityResult.none == connectivityResult) {
      setState(() => detectingLocation = false);
      return;
    }
    if (!mounted) return;
    Provider.of<LocationProvider>(context, listen: false)
        .determinePosition(context, (res, isSuccess) async {
      if (isSuccess) {
        String address = await AddressRepository.reverseGeocode(
            coordinates: coords.LatLng(res.latitude, res.longitude));
        if (!mounted) return;
        Provider.of<LocationProvider>(context, listen: false).setCoordinates(
            coords.LatLng(res.latitude, res.longitude), address);

        launchSnackbar(
            context: context,
            mode: "SUCCESS",
            duration: 7000,
            icon: Icons.pin_drop_rounded,
            message:
                "Location detected: $address. Virtually change location to your liking by pressing the pin button on the top bar.");
      }

      setState(() => detectingLocation = false);
    });
  }

  bool checkIfVerified(List<EmailVerification> emailVerification) {
    for (int i = 0; i < emailVerification.length; i++) {
      if (emailVerification[i].isConfirmed) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      determinePosition();
      Provider.of<AppProvider>(context, listen: false).getPhilippines();
    }();

    // connectivitySubscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   if (ConnectivityResult.none != result) {
    //     launchSnackbar(
    //         context: context,
    //         mode: "SUCCESS",
    //         message: "You are now connected to internet.",
    //         action: SnackBarAction(
    //             label: "Reload",
    //             onPressed: () {
    //               Navigator.pushNamed(context, '/');
    //             }));
    //   }
    // });
    super.initState();
  }

  // @override
  // dispose() {
  //   super.dispose();
  //   connectivitySubscription.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    AppProvider appProvider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBG2,
        foregroundColor: textColor2,
        elevation: .5,
        title: const Text("Discover Lantapan"),
        actions: [
          if (detectingLocation)
            showDoubleBounce(size: 20)
          else
            IconButton(
                onPressed: () {
                  setLocation();
                },
                icon: const Icon(Icons.pin_drop_rounded)),
          IconButton(
              onPressed: () async {
                if (await isOffline(context)) return;
                Navigator.pushNamed(context, '/search/place');
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Column(
        children: [
          // Container(),
          // SquareBorder(
          //   size: 4,
          //   count: 100,
          // ),
          Expanded(
            child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: page,
                children: [
                  HomeFeed(),
                  History(),
                  TourismStaff(),
                  AboutLantapan(),
                  Contacts(),
                  Developers()
                ]),
          ),
          if (userProvider.currentUser != null &&
              !checkIfVerified(userProvider.currentUser!.emailVerification))
            Container(
                color: Colors.red,
                padding: const EdgeInsets.all(15),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconText(
                          label: "Email not verified!",
                          fontWeight: FontWeight.bold,
                          color: textColor2,
                        ),
                        Button(
                          isLoading: userProvider.loading == "generate-otp",
                          label: "Verify Now",
                          onPress: () {
                            userProvider.generatePin(
                                query: {
                                  "email": userProvider.currentUser!.email,
                                  "recipient_name":
                                      userProvider.currentUser!.fullName
                                },
                                callback: (code, message) {
                                  if (code == 200) {
                                    Navigator.pushNamed(context, '/verify/otp');
                                    return;
                                  }

                                  launchSnackbar(
                                      context: context,
                                      mode: "ERROR",
                                      message: message);
                                });
                          },
                          backgroundColor: textColor2,
                          borderColor: Colors.transparent,
                          textColor: Colors.black,
                          borderRadius: 100,
                        )
                      ]),
                ]))
        ],
      ),
      drawer: Drawer(
        backgroundColor: colorBG1,
        child: Column(children: [
          Expanded(
              child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
                margin: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: colorBG2,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconText(
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "Tour De Lantapan",
                        color: textColor2,
                        fontWeight: FontWeight.bold,
                        size: 17,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Maayad Ha Pag uma,\nDini Ta Lantapan",
                        style: TextStyle(color: textColor2),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Row(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userProvider.currentUser?.photo != null
                                    ? "${userProvider.currentUser!.photo!.small!}?${DateTime.now().toString()}"
                                    : placeholderImage,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 50,
                                  height: 50,
                                  color: colorBG1.withOpacity(.1),
                                ),
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(userProvider.currentUser?.fullName ?? "Guest",
                              style: TextStyle(
                                  color: textColor2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))
                        ]),
                      ),
                    ])),
            SquareBorder(
              size: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: drawerItems.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          if (pageIndex == index)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(children: [
                                Container(
                                  color: Colors.white,
                                  height: 3,
                                ),
                                // Diamonds()
                              ]),
                            ),
                          Button(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 7),
                              mainAxisAlignment: MainAxisAlignment.start,
                              backgroundColor: pageIndex == index
                                  ? Colors.black
                                  : Colors.transparent,
                              borderColor: Colors.transparent,
                              borderRadius: 0,
                              textColor: pageIndex == index
                                  ? Colors.white
                                  : textColor1,
                              fontSize: 17,
                              icon: drawerItems[index].icon,
                              label: drawerItems[index].text,
                              onPress: () async {
                                if (index == 6) {
                                  Navigator.pop(context);
                                  if (await isOffline(context)) return;
                                  Navigator.pushNamed(context, '/scan/qr');
                                  return;
                                }

                                if (index == 7) {
                                  Navigator.pop(context);
                                  if (await isOffline(context)) return;
                                  Navigator.pushNamed(
                                      context, '/nearby/gas-stations');
                                  return;
                                }

                                setState(() => pageIndex = index);
                                page.jumpToPage(index);
                                Navigator.pop(context);
                              }),
                          if (pageIndex == index)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(children: [
                                // Diamonds(
                                //   isInverted: true,
                                // ),
                                Container(
                                  color: Colors.white,
                                  height: 3,
                                ),
                              ]),
                            ),
                        ],
                      ),
                    ))
          ])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                      icon: userProvider.currentUser == null
                          ? Icons.person
                          : Icons.logout_rounded,
                      label: userProvider.currentUser == null
                          ? "Log In/Sign Up"
                          : "Log Out",
                      borderColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      textColor: textColor1,
                      padding: const EdgeInsets.all(0),
                      mainAxisAlignment: MainAxisAlignment.start,
                      onPress: () async {
                        Navigator.pop(context);
                        if (await isOffline(context)) return;
                        if (userProvider.currentUser != null) {
                          userProvider.signOut();
                          return;
                        }

                        Navigator.pushNamed(context, '/auth');
                        return;
                      }),
                  if (userProvider.currentUser != null)
                    Button(
                        icon: Icons.edit,
                        label: "Edit Profile",
                        borderColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        textColor: textColor2,
                        padding: const EdgeInsets.all(0),
                        mainAxisAlignment: MainAxisAlignment.start,
                        onPress: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/user/profile/edit');
                          return;
                        }),
                ]),
          ),
          const SizedBox(
            height: 15,
          ),
        ]),
      ),
    );
  }
}

class IconTextModel {
  IconTextModel(this.icon, this.text);
  final IconData icon;
  final String text;
}

class Diamonds extends StatelessWidget {
  bool? isInverted;
  Diamonds({Key? key, this.isInverted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ...List.generate(
          100,
          (index) => Container(
            color: Colors.white,
            child: Column(
              children: [
                Transform.rotate(
                    angle: isInverted ?? false ? 0 : 3.14 / 1,
                    child: CustomPaint(
                        painter: TrianglePainter(
                          strokeColor: Colors.black,
                          strokeWidth: 0,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        child: Container(
                          height: 5,
                          width: 30,
                        ))),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
