import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_loaders.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/shape/diamond_border.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitializeScreen extends StatefulWidget {
  const InitializeScreen({Key? key}) : super(key: key);

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  String initialize = "WAITING";

  initializeApp() {
    Future.delayed(const Duration(seconds: 1), () {
      Provider.of<UserProvider>(context, listen: false).profile(
          callback: (code, message) {
        if ([103, 500].contains(code)) {
          setState(() => initialize = "FAILED");
          return;
        }

        if ([200, 201].contains(code)) {
          if (BUILD_MODE == "ADMIN" && code == 200) {
            Navigator.pushNamedAndRemoveUntil(context, "/admin", (_) => false);
            return;
          }

          if (BUILD_MODE == "ADMIN") {
            Navigator.pushNamedAndRemoveUntil(
                context, "/auth/admin", (_) => false);
            return;
          }

          Navigator.pushNamedAndRemoveUntil(context, "/guest", (_) => false);
        } else {
          launchSnackbar(context: context, mode: "ERROR", message: message);
        }
      });
    });
  }

  @override
  void initState() {
    initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (initialize == "WAITING") {
      return Scaffold(
          backgroundColor: colorBG2,
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 10,
            ),
            DiamondBorder(),
            Expanded(child: Container()),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height * .07,
                width: MediaQuery.of(context).size.height * .07,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: Image(
                  image: const AssetImage('assets/images/lantapan_seal.png'),
                  // height: MediaQuery.of(context).size.height * .10,
                  // width: MediaQuery.of(context).size.width *
                  //     (isMobile(context) ? .15 : .10)
                ),
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: Image(
                    image: const AssetImage('assets/images/tour_office.png'),
                    height: MediaQuery.of(context).size.height * .06,
                    width: MediaQuery.of(context).size.height * .06),
              ),
            ]),
            Image(
                image: const AssetImage('assets/images/logo_light.png'),
                height: MediaQuery.of(context).size.height * .30,
                width: MediaQuery.of(context).size.width *
                    (isMobile(context) ? .80 : .30)),
            const SizedBox(
              height: 15,
            ),
            IconText(
              mainAxisAlignment: MainAxisAlignment.center,
              label: "Tradisyon Hu Katatao",
              color: textColor2,
              fontWeight: FontWeight.bold,
              size: 20,
            ),
            IconText(
              mainAxisAlignment: MainAxisAlignment.center,
              label: "A Tradition Of Excellence",
              color: textColor1,
            ),
            const SizedBox(
              height: 100,
            ),
            showDoubleBounce(size: 30, color: textColor2),
            Expanded(child: Container()),
            DiamondBorder(),
            const SizedBox(
              height: 10,
            ),
          ]));
    }

    if (initialize == "FAILED") {
      return Scaffold(
          backgroundColor: colorBG2,
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 10,
              ),
              DiamondBorder(),
              Expanded(child: Container()),
              Icon(
                Icons.error_rounded,
                size: 30,
                color: textColor2,
              ),
              const SizedBox(
                height: 10,
              ),
              IconText(
                mainAxisAlignment: MainAxisAlignment.center,
                label: "Failed to initialize app.",
                color: textColor2,
                fontWeight: FontWeight.bold,
                size: 15,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Button(
                    backgroundColor: Colors.transparent,
                    borderColor: textColor2,
                    textColor: textColor2,
                    borderRadius: 100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    icon: Icons.replay_outlined,
                    label: "Retry",
                    onPress: () {
                      setState(() => initialize = "WAITING");
                      initializeApp();
                    }),
              ]),
              Expanded(child: Container()),
              if (BUILD_MODE == "GUEST")
                Button(
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    textColor: textColor2,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    icon: Icons.wifi_off_outlined,
                    label: "Offline Mode",
                    onPress: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/guest", (_) => false);
                    }),
              const SizedBox(
                height: 15,
              ),
              IconText(
                mainAxisAlignment: MainAxisAlignment.center,
                label: "Discover Lantapan",
                fontWeight: FontWeight.bold,
                color: textColor1,
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom == 0.0
                    ? 20
                    : MediaQuery.of(context).padding.bottom,
              ),
            ]),
          ));
    }

    return Container();
  }
}
