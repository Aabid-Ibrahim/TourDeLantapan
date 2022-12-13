import 'dart:ui';

import 'package:app/provider/dashboard_provider.dart';
import 'package:app/provider/place_provider.dart';
import 'package:app/provider/review_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'provider/app_provider.dart';
import 'provider/location_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  await dotenv.load(fileName: "dotenv");
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => PlaceProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ReviewProvider()),
          ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ],
        child: MaterialApp(
          title: 'Discover Lantapan',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.amber, fontFamily: 'Varela'),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
        ));
  }
}
