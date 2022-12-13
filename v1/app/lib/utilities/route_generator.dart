import 'package:app/screens/admin/add_place.dart';
import 'package:app/screens/admin/index.dart';
import 'package:app/screens/auth/admin_login.dart';
import 'package:app/screens/auth/change_password.dart';
import 'package:app/screens/auth/index.dart';
import 'package:app/screens/auth/login.dart';
import 'package:app/screens/auth/otp.dart';
import 'package:app/screens/forgot-password.dart';
import 'package:app/screens/guest/add_review.dart';
import 'package:app/screens/guest/edit_profile.dart';
import 'package:app/screens/guest/index.dart';
import 'package:app/screens/guest/mapview.dart';
import 'package:app/screens/guest/nearby_gas_stations.dart';
import 'package:app/screens/guest/place_info.dart';
import 'package:app/screens/guest/review_list.dart';
import 'package:app/screens/guest/scan_qr.dart';
import 'package:app/screens/guest/search_place.dart';
import 'package:app/screens/guest/visitor_form.dart';
import 'package:app/screens/initialize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => const InitializeScreen());
      case '/guest':
        return CupertinoPageRoute(builder: (_) => Guest());
      case '/admin':
        return CupertinoPageRoute(builder: (_) => Admin());
      case '/user/profile/edit':
        return CupertinoPageRoute(builder: (_) => EditProfile());
      case '/user/profile/change-password':
        return CupertinoPageRoute(builder: (_) => ChangePassword());
      case '/place/info':
        return CupertinoPageRoute(
            builder: (_) => PlaceInfo(arguments: args as Map<String, dynamic>));
      case '/search/place':
        return CupertinoPageRoute(builder: (_) => SearchPlace());
      case '/mapview':
        return CupertinoPageRoute(builder: (_) => MapView());
      case '/auth':
        return CupertinoPageRoute(builder: (_) => Auth());
      case '/auth/admin':
        return CupertinoPageRoute(builder: (_) => AdminLogin());
      case '/auth/password/reset':
        return CupertinoPageRoute(builder: (_) => ForgotPassword());
      case '/place/add':
        return CupertinoPageRoute(
            builder: (_) => AddPlace(arguments: args as Map<String, dynamic>));
      case '/review/add':
        return CupertinoPageRoute(builder: (_) => AddReview());
      case '/review/list':
        return CupertinoPageRoute(builder: (_) => ReviewList());
      case '/scan/qr':
        return CupertinoPageRoute(builder: (_) => QRScanner());
      case '/visitor/form':
        return CupertinoPageRoute(builder: (_) => VisitorForm());
      case '/verify/otp':
        return CupertinoPageRoute(builder: (_) => OneTimePin());
      case '/nearby/gas-stations':
        return CupertinoPageRoute(builder: (_) => NearbyGasStations());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (context) {
      return Scaffold(appBar: AppBar(title: const Text('Welcome')));
    });
  }
}
