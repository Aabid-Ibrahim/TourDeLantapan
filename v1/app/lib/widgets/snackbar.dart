import 'package:app/utilities/constants.dart';
import 'package:flutter/material.dart';

launchSnackbar(
    {required BuildContext context,
    required String mode,
    SnackBarAction? action,
    IconData? icon,
    int? duration,
    required String message}) {
  Color? color;
  IconData? _icon;

  if (mode == "SUCCESS") {
    color = Colors.green;
    _icon = Icons.check_box_outlined;
  }
  if (mode == "ERROR") {
    color = Colors.red;
    _icon = Icons.warning_amber_rounded;
  }

  final snackBar = SnackBar(
    duration: Duration(milliseconds: duration ?? 3000),
    action: action,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon ?? _icon, color: textColor2),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message,
              style:  TextStyle(
                  color: textColor2, fontWeight: FontWeight.bold)),
        )
      ],
    ),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
