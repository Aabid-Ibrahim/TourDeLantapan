import 'package:app/utilities/constants.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  bool? isLoading;
  IconData? icon;
  String label;
  Color? backgroundColor;
  Color? textColor;
  Color? borderColor;
  Function? onPress;
  EdgeInsets? padding;
  // bool? disabled;
  double? borderRadius;
  EdgeInsets? margin;
  double? fontSize;
  MainAxisAlignment? mainAxisAlignment;

  Button(
      {Key? key,
      this.icon,
      this.isLoading = false,
      required this.label,
      required this.onPress,
      this.backgroundColor,
      this.borderColor,
      this.padding,
      // this.disabled,
      this.borderRadius,
      this.margin,
      this.fontSize,
      this.mainAxisAlignment,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPress == null ? 0.5 : 1,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
            border: Border.all(color: borderColor ?? Colors.red)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: textColor2,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5)),
            onTap: (onPress == null || isLoading!) ? null : () => onPress!(),
            child: Padding(
              padding: padding ??
                  const EdgeInsets.only(
                      top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Row(
                  mainAxisAlignment:
                      mainAxisAlignment ?? MainAxisAlignment.center,
                  children: [
                    if (isLoading!)
                      SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: textColor ?? textColor2,
                          strokeWidth: 1,
                        ),
                      ),
                    if (icon != null && !isLoading!)
                      Icon(
                        icon,
                        color: textColor ?? textColor2,
                        size: fontSize ?? 14,
                      ),
                    if (icon != null || isLoading!)
                      SizedBox(
                        width: isLoading! ? 15 : 10,
                      ),
                    Text(
                      label,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize ?? 14,
                        letterSpacing: 0.27,
                        color: textColor ?? textColor2,
                      ),
                    ),
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
