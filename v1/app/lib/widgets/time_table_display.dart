import 'package:app/models/place_model.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';

class TimeTableDisplay extends StatelessWidget {
  bool? isLightMode;

  List<TimeTable> timeTable;
  TimeTableDisplay({Key? key, this.isLightMode, required this.timeTable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        DayOfWeek(isLightMode: isLightMode, timeOfDay: timeTable[0]),
        DayOfWeek(isLightMode: isLightMode, timeOfDay: timeTable[1])
      ]),
      Row(children: [
        DayOfWeek(isLightMode: isLightMode, timeOfDay: timeTable[2]),
        DayOfWeek(isLightMode: isLightMode, timeOfDay: timeTable[3])
      ]),
      Row(children: [
        DayOfWeek(isLightMode: isLightMode, timeOfDay: timeTable[4]),
        DayOfWeek(isLightMode: isLightMode, timeOfDay: timeTable[5])
      ]),
      Row(children: [
        DayOfWeek(isLightMode: isLightMode, timeOfDay: timeTable[6]),
      ])
    ]);
  }
}

class DayOfWeek extends StatelessWidget {
  TimeTable timeOfDay;
  bool? isLightMode;
  DayOfWeek({Key? key, this.isLightMode, required this.timeOfDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(
                label: timeOfDay.day,
                color: isLightMode ?? false ? Colors.black : textColor2,
                // fontWeight: FontWeight.bold,
              ),
              if (timeOfDay.other == "CLOSED")
                IconText(
                    label: "Closed",
                    fontWeight: FontWeight.bold,
                    color: isLightMode ?? false ? Colors.black : textColor2)
              else if (timeOfDay.other == "247")
                IconText(
                    label: "Open 24/7",
                    fontWeight: FontWeight.bold,
                    color: Colors.amber)
              else
                Row(children: [
                  IconText(
                      color: isLightMode ?? false ? Colors.black : textColor2,
                      label:
                          "${TimeOfDay(hour: timeOfDay.timeFromHour, minute: timeOfDay.timeFromMinute).format(context)} to "),
                  IconText(
                      color: isLightMode ?? false ? Colors.black : textColor2,
                      label: TimeOfDay(
                              hour: timeOfDay.timeToHour,
                              minute: timeOfDay.timeToMinute)
                          .format(context))
                ]),
            ]),
      ),
    );
  }
}
