import 'package:flutter/material.dart';

class NumberChooser extends StatelessWidget {
  String label;
  int min;
  int max;
  Function onChange;
  int value;
  bool? disabled;
  String? Function(String?)? validator;

  NumberChooser(
      {Key? key,
      required this.label,
      required this.min,
      required this.max,
      this.validator,
      required this.disabled,
      required this.value,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController(text: "$value");
    return Opacity(
      opacity: !disabled! ? 1 : 0.6,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: myController,
              validator: validator,
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                labelText: label,
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          PlusMinus(min: min, max: max, value: value, onChange: onChange, disabled: disabled!,)
        ],
      ),
    );
  }
}

class PlusMinus extends StatelessWidget {
  bool disabled;
  int min;
  int max;
  int value;
  Function onChange;
  PlusMinus({
    Key? key,
    required this.disabled,
    required this.min,
    required this.max,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Material(
          child: IconButton(
              onPressed: !disabled
                  ? () {
                      if (min == value) return;
                      // myController.text = (value -= 1).toString();
                      onChange(value -= 1);
                    }
                  : null,
              icon: const Icon(Icons.chevron_left_rounded))),
      const SizedBox(
        width: 10,
      ),
      Material(
          child: IconButton(
              onPressed: !disabled
                  ? () {
                      if (max == value) return;
                      // myController.text = (value += 1).toString();
                      onChange(value += 1);
                    }
                  : null,
              icon: const Icon(Icons.chevron_right_rounded)))
    ]);
  }
}
