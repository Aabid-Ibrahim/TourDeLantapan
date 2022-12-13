import 'package:app/models/place_model.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/chips.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:time_range_picker/time_range_picker.dart';

class TimeTableManager extends StatefulWidget {
  Function onSave;
  List<TimeTable> value;
  TimeTableManager({Key? key, required this.onSave, required this.value})
      : super(key: key);

  @override
  State<TimeTableManager> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTableManager>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  List<dynamic> currentValue = [];
  List<TimeTable> timeTable = [
    TimeTable(
        day: "MONDAY",
        timeFromHour: 6,
        timeFromMinute: 30,
        timeToHour: 19,
        timeToMinute: 30,
        other: ""),
    TimeTable(
        day: "TUESDAY",
        timeFromHour: 6,
        timeFromMinute: 30,
        timeToHour: 19,
        timeToMinute: 30,
        other: ""),
    TimeTable(
        day: "WEDNESDAY",
        timeFromHour: 6,
        timeFromMinute: 30,
        timeToHour: 19,
        timeToMinute: 30,
        other: ""),
    TimeTable(
        day: "THURSDAY",
        timeFromHour: 6,
        timeFromMinute: 30,
        timeToHour: 19,
        timeToMinute: 30,
        other: ""),
    TimeTable(
        day: "FRIDAY",
        timeFromHour: 6,
        timeFromMinute: 30,
        timeToHour: 19,
        timeToMinute: 30,
        other: ""),
    TimeTable(
        day: "SATURDAY",
        timeFromHour: 6,
        timeFromMinute: 30,
        timeToHour: 19,
        timeToMinute: 30,
        other: ""),
    TimeTable(
        day: "SUNDAY",
        timeFromHour: 6,
        timeFromMinute: 30,
        timeToHour: 19,
        timeToMinute: 30,
        other: ""),
  ];

  @override
  void initState() {
    if (widget.value.isEmpty) {
      currentValue = List<dynamic>.filled(7, null);
    } else {
      currentValue = widget.value.map((e) => e.toJson()).toList();
      timeTable = widget.value;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: timeTable.length,
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              toolbarHeight: 0,
              backgroundColor: textColor2,
              bottom: TabBar(
                isScrollable: true,
                labelColor: textColor2,
                unselectedLabelColor: Colors.black,
                indicator: MaterialIndicator(
                    bottomLeftRadius: 100,
                    bottomRightRadius: 100,
                    topLeftRadius: 100,
                    topRightRadius: 100),
                onTap: (val) => setState(() => selectedIndex = val),
                tabs: [
                  for (int i = 0; i < timeTable.length; i++)
                    Tab(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Opacity(
                        opacity: selectedIndex == i ? 1 : .5,
                        child: Column(
                          children: [
                            IconText(
                              label: timeTable[i].day,
                              backgroundColor: Colors.transparent,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              borderRadius: 100,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                            ),
                            if (currentValue[i] == null)
                              IconText(
                                  label: "Not Set",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber)
                            else if (timeTable[i].other == "CLOSED")
                              IconText(
                                  label: "Closed",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)
                            else if (timeTable[i].other == "247")
                              IconText(
                                  label: "Open 24/7",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)
                            else
                              Row(children: [
                                IconText(
                                    color: Colors.black,
                                    label: TimeOfDay(
                                            hour: timeTable[i].timeFromHour,
                                            minute: timeTable[i].timeFromMinute)
                                        .format(context)),
                                const Icon(
                                  Icons.arrow_right_rounded,
                                  color: Colors.black,
                                ),
                                IconText(
                                    color: Colors.black,
                                    label: TimeOfDay(
                                            hour: timeTable[i].timeToHour,
                                            minute: timeTable[i].timeToMinute)
                                        .format(context))
                              ]),
                          ],
                        ),
                      ),
                    )),
                ],
              )),
          body: Column(
            children: [
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                    ...List.generate(
                        timeTable.length,
                        (index) => TimeDayPicker(
                            value: timeTable[index],
                            onChange: (value) {
                              setState(() {
                                timeTable[index] = value;
                                currentValue[index] = timeTable[index].toJson();
                              });
                            }))
                  ])),
              Container(
                  color: Colors.grey[200],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Button(
                      label: "Save",
                      onPress: () {
                        if (currentValue.contains(null)) {
                          launchSnackbar(
                              context: context,
                              mode: "ERROR",
                              message:
                                  "Please set all days with their respective open and close time.");
                          return;
                        }
                        widget
                            .onSave(timeTable.map((e) => e.toJson()).toList());
                      }))
            ],
          )),
    );
  }
}

// SizedBox(height: MediaQuery.of(context).viewInsets.bottom)

class TimeDayPicker extends StatefulWidget {
  TimeTable value;
  Function onChange;
  TimeDayPicker({Key? key, required this.value, required this.onChange})
      : super(key: key);

  @override
  State<TimeDayPicker> createState() => _TimeDayPickerState();
}

class _TimeDayPickerState extends State<TimeDayPicker> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    _startTime = TimeOfDay(
        hour: widget.value.timeFromHour, minute: widget.value.timeFromMinute);
    _endTime = TimeOfDay(
        hour: widget.value.timeToHour, minute: widget.value.timeToMinute);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TimeRangePicker(
              hideButtons: true,
              rotateLabels: false,
              paintingStyle: PaintingStyle.fill,
              use24HourFormat: false,
              backgroundColor: Colors.grey.withOpacity(0.2),
              labels: [
                "12 am",
                "3 am",
                "6 am",
                "9 am",
                "12 pm",
                "3 pm",
                "6 pm",
                "9 pm"
              ].asMap().entries.map((e) {
                return ClockLabel.fromIndex(
                    idx: e.key, length: 8, text: e.value);
              }).toList(),
              start: _startTime,
              end: _endTime,
              ticks: 8,
              strokeColor: Theme.of(context).primaryColor.withOpacity(0.5),
              ticksColor: Theme.of(context).primaryColor,
              labelOffset: 15,
              padding: 60,
              onStartChange: (start) {
                setState(() {
                  _startTime = start;
                });

                widget.value.timeFromHour = start.hour;
                widget.value.timeFromMinute = start.minute;
                widget.value.timeToHour = _endTime.hour;
                widget.value.timeToMinute = _endTime.minute;
                widget.onChange(widget.value);
              },
              onEndChange: (end) {
                setState(() {
                  _endTime = end;
                });

                widget.value.timeFromHour = _startTime.hour;
                widget.value.timeFromMinute = _startTime.minute;
                widget.value.timeToHour = end.hour;
                widget.value.timeToMinute = end.minute;
                widget.onChange(widget.value);
              }),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Chippy(
              backgroundColor:
                  widget.value.other == "CLOSED" ? Colors.black : Colors.grey,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              label: "Closed",
              onPress: () {
                widget.value.other =
                    widget.value.other == "CLOSED" ? "" : "CLOSED";
                widget.onChange(widget.value);
              }),
          Chippy(
              backgroundColor:
                  widget.value.other == "247" ? Colors.black : Colors.grey,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              label: "Open 24/7",
              onPress: () {
                widget.value.other = widget.value.other == "247" ? "" : "247";
                widget.onChange(widget.value);
              }),
        ]),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
