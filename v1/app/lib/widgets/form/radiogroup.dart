import 'package:app/utilities/constants.dart';
import 'package:app/widgets/button.dart';
import 'package:flutter/material.dart';

class RadioGroup extends StatelessWidget {
  List<dynamic> choices;
  dynamic currentValue;
  Function onChange;
  Color? color;
  RadioGroup(
      {Key? key,
      required this.choices,
      required this.currentValue,
      this.color,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
          children: choices
              .map((e) => RadioButton(
                  label: e,
                  color: color,
                  isSelected: e == currentValue,
                  onPress: () => onChange(e)))
              .toList())
    ]);
  }
}

class RadioButton extends StatelessWidget {
  String label;
  bool isSelected;
  Function onPress;
  Color? color;

  RadioButton(
      {Key? key,
      required this.label,
      required this.isSelected,
      this.color,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Button(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          borderColor: color ?? Colors.black87,
          backgroundColor:
              isSelected ? color ?? Colors.black87 : Colors.transparent,
          textColor: !isSelected ? Colors.black87 : textColor2,
          label: label,
          onPress: onPress),
    );
  }
}
