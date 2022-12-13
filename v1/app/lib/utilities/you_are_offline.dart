import 'package:app/widgets/snackbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<bool> isOffline(BuildContext context) async {
  ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());
  if (ConnectivityResult.none == connectivityResult) {
    launchSnackbar(context: context, mode: "ERROR", message: "You are offline");
    return true;
  }

  return false;
}
