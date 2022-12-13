import 'package:app/utilities/constants.dart';
import 'package:flutter/material.dart';

class Chippy extends StatelessWidget {
  IconData? icon;
  String label;
  Color? backgroundColor;
  Color? textColor;
  Color? borderColor;
  Function onPress;
  EdgeInsets? padding;
  bool? disabled;
  ChipAction? action;
  EdgeInsets? margin;
  IconButton? iconButton;

  Chippy(
      {Key? key,
      this.icon,
      required this.label,
      required this.onPress,
      this.backgroundColor,
      this.borderColor,
      this.padding,
      this.disabled,
      this.action,
      this.margin,
      this.iconButton,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled == null ? 1 : 0.5,
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.black,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            border: Border.all(color: borderColor ?? Colors.transparent)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: textColor2,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            onTap:
                disabled != null || disabled == true ? null : () => onPress(),
            child: Padding(
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Center(
                child: Row(
                  children: [
                    if (icon != null)
                      Icon(icon, color: textColor ?? textColor2),
                    if (icon != null)
                      const SizedBox(
                        width: 5,
                      ),
                    Text(label,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 0.27,
                          color: textColor ?? textColor2,
                        )),
                    if (action != null)
                      InkWell(
                        splashColor: Colors.transparent,
                        child: Container(
                            height: 24.0,
                            width: 24.0,
                            child: Icon(
                              Icons.cancel,
                              color: textColor2,
                              size: 16,
                            )),
                        onTap: () => action!.onPress(),
                      )
                    // IconButton(
                    //     color: textColor ?? textColor2,
                    //     splashRadius: 10,
                    //     padding: EdgeInsets.zero,
                    //     onPressed: () => action!.onPress(),
                    //     icon: Icon(
                    //       action!.icon,
                    //     ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChipLoader extends StatefulWidget {
  ChipLoader({Key? key}) : super(key: key);

  @override
  State<ChipLoader> createState() => _ChipLoaderState();
}

class _ChipLoaderState extends State<ChipLoader> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, item) => Chippy(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 50),
            backgroundColor: Colors.grey[300],
            label: "",
            onPress: () {}));
  }
}

class ChipAction {
  ChipAction(this.icon, this.onPress);
  final IconData icon;
  final Function onPress;
}
