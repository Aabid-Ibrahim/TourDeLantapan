import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';

dialogBuilder(context, {required String title, required String description}) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: IconText(
            label: "Dismiss",
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}
