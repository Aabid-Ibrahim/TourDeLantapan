// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const bool IS_PODUCTION = true;
const String BUILD_MODE = "GUEST"; //ADMIN, GUEST

String BASE_URL = IS_PODUCTION
    ? dotenv.env['BASE_URL_PRODUCTION'] ?? ""
    : dotenv.env['BASE_URL_LOCAL'] ?? "";

const double HORIZONTAL_PADDING = 15.0;
const String placeholderImage =
    "https://tourdelantapan.s3.ap-northeast-1.amazonaws.com/app_assets/SM-placeholder.png";

double mapZoom = 15;

// Color colorBG1 = Color.fromARGB(255, 199, 52, 44);
Color colorBG1 = Color.fromARGB(255, 140, 26, 28);
Color colorBG2 = Color.fromARGB(255, 140, 26, 28);

Color textColor1 = Colors.white70;
Color textColor2 = Colors.white;
