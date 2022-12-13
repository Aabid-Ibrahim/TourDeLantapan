import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  Function onChanged;
  String searchKey;
  String? label;
  Color? backgroundColor;
  Color? textColor;
  SearchBar({
    Key? key,
    this.label,
    this.backgroundColor,
    this.textColor,
    required this.searchKey,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: searchKey,
        onChanged: (e) => onChanged(e),
        style:
            TextStyle(color: textColor != null ? Colors.white : Colors.black),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            fillColor: backgroundColor ?? Colors.grey[100],
            hintStyle: TextStyle(color: textColor ?? Colors.black),
            filled: true,
            hintText: label ?? "Search",
            prefixIcon: Icon(
              Icons.search_rounded,
              color: textColor ?? Colors.black,
            )));
  }
}
