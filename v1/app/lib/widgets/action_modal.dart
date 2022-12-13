import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';

class ActionModal extends StatelessWidget {
  double? heightInPercentage;
  String title;
  String subTitle;
  Function callback;
  String? confirmAction;
  String? cancelAction;
  bool isLoading;
  ActionModal(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.callback,
      this.confirmAction,
      this.cancelAction,
      required this.isLoading,
      this.heightInPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
          height: height * (heightInPercentage ?? 0.20),
          width: isMobile(context) ? width * .90 : width * .30,
          decoration: BoxDecoration(
              color: textColor2, borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: (height * 0.70) * .07, left: 15, right: 15),
                  child: Column(children: [
                    IconText(
                        color: Colors.black,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: subTitle),
                    const Expanded(child: SizedBox()),
                    // if (isLoading) const LinearProgressIndicator(),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Button(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        label: cancelAction ?? "Cancel",
                        backgroundColor: Colors.transparent,
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        onPress: () => Navigator.pop(context),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Button(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            label: confirmAction ?? "Confirm",
                            backgroundColor: Colors.red,
                            borderColor: Colors.red,
                            onPress: () =>
                                callback(confirmAction ?? "CONFIRM")),
                      )
                    ]),
                    const SizedBox(
                      height: 15,
                    )
                  ])),
              Container(
                  padding: const EdgeInsets.only(left: 15),
                  height: (height * 0.70) * .07,
                  decoration: BoxDecoration(
                      color: textColor2,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded)),
                        ),
                      ]))
            ],
          )),
    );
  }
}
