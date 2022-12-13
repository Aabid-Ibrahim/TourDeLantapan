import 'package:app/utilities/constants.dart';
import 'package:flutter/material.dart';

InputDecoration textFieldStyle(
    {required String label,
    Widget? suffixIcon,
    String? prefix,
    Widget? prefixIcon}) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(5),
      ),
      prefix: prefix != null ? Text(prefix) : null,
      fillColor: Colors.red[900]!.withOpacity(.5),
      filled: true,
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 1),
      ),
      errorStyle: TextStyle(color: Colors.amber),
      iconColor: Colors.white,
      focusColor: Colors.white,
      labelStyle: TextStyle(color: Colors.white54),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelText: label);
}
