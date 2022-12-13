import 'package:app/provider/place_provider.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetectPlace extends StatefulWidget {
  Map<String, dynamic> arguments;
  DetectPlace({Key? key, required this.arguments}) : super(key: key);

  @override
  State<DetectPlace> createState() => _DetectPlaceState();
}

class _DetectPlaceState extends State<DetectPlace> {
  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      Provider.of<PlaceProvider>(context, listen: false).getPlace(
          placeId: widget.arguments["placeId"],
          callback: (code, message) async {
            if (code != 200) {
              Navigator.pop(context);
              launchSnackbar(
                  context: context,
                  mode: code == 200 ? "SUCCESS" : "ERROR",
                  message: message ?? "Success!");
            }
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/visitor/form');
            }
          });
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = context.watch<PlaceProvider>();

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (placeProvider.loading.contains("place-info"))
          const CircularProgressIndicator()
        else
          IconText(
              mainAxisAlignment: MainAxisAlignment.center,
              icon: Icons.check_circle,
              label: "Place found. Redirecting to visitor form.")
      ]),
    );
  }
}
