import 'package:app/utilities/constants.dart';
import 'package:app/utilities/responsive_screen.dart';
import 'package:app/widgets/calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPopupView extends StatefulWidget {
  const CalendarPopupView(
      {this.selectionMode,
      this.offerIds,
      this.initialStartDate,
      this.initialEndDate,
      required this.singleDaySelection,
      required this.onApplyClick,
      required this.onCancelClick,
      required this.onReset,
      this.minimumDate,
      this.maximumDate,
      this.barrierDismissible = true,
      Key? key})
      : super(key: key);

  final String? selectionMode;
  final List<String>? offerIds;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final bool barrierDismissible;
  final bool singleDaySelection;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function onReset;
  final Function(DateTime?, DateTime?) onApplyClick;

  final Function onCancelClick;
  @override
  State<CalendarPopupView> createState() => _CalendarPopupViewState();
}

class _CalendarPopupViewState extends State<CalendarPopupView>
    with TickerProviderStateMixin {
  late DateTime? startDate;
  late DateTime? endDate;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, _) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: animationController.value,
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                if (widget.barrierDismissible) {
                  Navigator.pop(context);
                }
              },
              child: Center(
                child: Container(
                  width: isMobile(context) ? width * .90 : 400,
                  decoration: BoxDecoration(
                    color: textColor2,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: const Offset(4, 4),
                          blurRadius: 8.0),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.singleDaySelection ? 'Date' : 'From',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 16,
                                      color: Colors.grey.withOpacity(0.8)),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  startDate == null
                                      ? "Select date"
                                      : DateFormat('EEE, dd MMM')
                                          .format(startDate!),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 74,
                            width: widget.singleDaySelection ? 0 : 1,
                            color: Colors.grey,
                          ),
                          if (!widget.singleDaySelection)
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'To',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 16,
                                        color: Colors.grey.withOpacity(0.8)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    endDate == null
                                        ? "Select date"
                                        : DateFormat('EEE, dd MMM')
                                            .format(endDate!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                      const Divider(height: 1),
                      CustomCalendarView(
                        selectionMode: widget.selectionMode,
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        initialEndDate: endDate,
                        singleDaySelection: widget.singleDaySelection,
                        initialStartDate: startDate,
                        onReset: () {
                          setState(() {
                            startDate = null;
                            endDate = null;
                          });
                          widget.onReset();
                        },
                        startEndDateChange:
                            (DateTime startDateData, DateTime? endDateData) {
                          if (mounted) {
                            setState(() {
                              startDate = startDateData;
                              endDate = endDateData;
                            });
                          }
                        },
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: ActionButton(
                                label: "Apply",
                                onPress: () {
                                  try {
                                    widget.onApplyClick(startDate, endDate);
                                    Navigator.pop(context);
                                  } catch (_) {
                                    print(_);
                                  }
                                }),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  Function onPress;
  Color? color;
  String label;
  ActionButton(
      {Key? key, required this.onPress, required this.label, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color ?? Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            highlightColor: Colors.transparent,
            onTap: () => onPress(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: textColor2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
