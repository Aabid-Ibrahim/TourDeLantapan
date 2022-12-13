import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChooser extends StatelessWidget {
  String label;
  DateTime firstDate;
  DateTime lastDate;
  DateTime initialDate;
  Function onDone;
  String? initialValue;
  String? Function(String?)? validator;
  String? format;

  DateChooser(
      {Key? key,
      required this.label,
      required this.firstDate,
      required this.lastDate,
      required this.initialDate,
      this.validator,
      this.initialValue,
      this.format,
      required this.onDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController(text: "");
    myController.text = DateFormat(format).format(initialDate);

    return TextFormField(
      validator: validator,
      controller: myController,
      readOnly: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: label,
        suffixIcon: InkWell(
          onTap: () {
            showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: lastDate)
                .then((value) {
              if (value != null) {
                myController.text = DateFormat(format).format(value);
                onDone(value);
              }
            });
          },
          child: const Icon(Icons.calendar_today_sharp),
        ),
      ),
    );
  }
}
