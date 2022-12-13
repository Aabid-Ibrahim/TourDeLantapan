import 'package:app/provider/app_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/calendar_popup.dart';
import 'package:app/widgets/form/radiogroup.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateFilter extends StatelessWidget {
  Function onApplyFilter;
  String startDate; //YYYY-MM-DD
  String endDate; //YYYY-MM-DD
  DateFilter({
    Key? key,
    required this.onApplyFilter,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  getWeek(week, month, year) {
    DateTime startDate =
        DateTime(year, month[0], week[0] * 7).subtract(const Duration(days: 7));
    DateTime endDate = DateTime(year, month[0], week[0] * 7);
  }

  getMonth(month, year) {
    onApplyFilter(DateTime(year, month[0], 1), DateTime(year, month[0] + 1, 0));
  }

  getQuarter(quarter, year) {
    onApplyFilter(DateTime(year, quarter[0], 1), DateTime(year, quarter[1], 0));
  }

  getYear(int year) {
    onApplyFilter(DateTime(year, 1, 1), DateTime(year, 13, 0));
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = context.watch<AppProvider>();

    onChangeDate() {
      showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) => CalendarPopupView(
          singleDaySelection: false,
          initialStartDate: DateTime.parse(startDate),
          initialEndDate: DateTime.parse(endDate),
          onApplyClick: (DateTime? startDate, DateTime? endDate) {
            DateTime now = DateTime.now();
            onApplyFilter(startDate ?? DateTime(now.year, now.month, 1),
                endDate ?? DateTime(now.year, now.month + 1, 0));
          },
          onReset: () {},
          onCancelClick: () {},
        ),
      );
    }

    return Container(
        color: textColor2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(children: [
            RadioGroup(
                choices: const [
                  "Custom",
                  // "Weekly",
                  "Monthly",
                  "Quarterly",
                  "Yearly"
                ],
                color: Colors.black87,
                currentValue: appProvider.DATE_FILTER_TYPE,
                onChange: (e) {
                  appProvider.setDateFilterType(e);
                  if (e == "Monthly") {
                    getMonth(
                        appProvider.MONTH_SELECTED, appProvider.YEAR_SELECTED);
                  }
                  if (e == "Quarterly") {
                    getQuarter(appProvider.QUARTER_SELECTED,
                        appProvider.YEAR_SELECTED);
                  }
                  if (e == "Yearly") {
                    getYear(appProvider.YEAR_SELECTED);
                  }
                }),
            Expanded(child: Container()),
            if (["Weekly"].contains(appProvider.DATE_FILTER_TYPE))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: PopupMenuButton<List>(
                  child: IconText(
                    label: appProvider.WEEK_SELECTED[1],
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    icon: Icons.arrow_drop_down_rounded,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: [1, "Week 1"], child: Text("Week 1")),
                    const PopupMenuItem(
                        value: [2, "Week 2"], child: Text("Week 2")),
                    const PopupMenuItem(
                        value: [3, "Week 3"], child: Text("Week 3")),
                    const PopupMenuItem(
                        value: [4, "Week 4"], child: Text("Week 4")),
                    const PopupMenuItem(
                        value: [5, "Week 5"], child: Text("Week 5")),
                  ],
                  offset: const Offset(0, 30),
                  elevation: 2,
                  onSelected: (e) {
                    getWeek(e, appProvider.MONTH_SELECTED,
                        appProvider.YEAR_SELECTED);
                    appProvider.setWeek(e);
                  },
                ),
              ),
            if (["Monthly", "Weekly"].contains(appProvider.DATE_FILTER_TYPE))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: PopupMenuButton<List>(
                  child: IconText(
                    label: appProvider.MONTH_SELECTED[1],
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    icon: Icons.arrow_drop_down_rounded,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: [1, "January"], child: Text("January")),
                    const PopupMenuItem(
                        value: [2, "February"], child: Text("February")),
                    const PopupMenuItem(
                        value: [3, "March"], child: Text("March")),
                    const PopupMenuItem(
                        value: [4, "April"], child: Text("April")),
                    const PopupMenuItem(value: [5, "May"], child: Text("May")),
                    const PopupMenuItem(
                        value: [6, "June"], child: Text("June")),
                    const PopupMenuItem(
                        value: [7, "July"], child: Text("July")),
                    const PopupMenuItem(
                        value: [8, "August"], child: Text("August")),
                    const PopupMenuItem(
                        value: [9, "September"], child: Text("September")),
                    const PopupMenuItem(
                        value: [10, "October"], child: Text("October")),
                    const PopupMenuItem(
                        value: [11, "November"], child: Text("November")),
                    const PopupMenuItem(
                        value: [12, "December"], child: Text("December")),
                  ],
                  offset: const Offset(0, 30),
                  elevation: 2,
                  onSelected: (e) {
                    getMonth(e, appProvider.YEAR_SELECTED);
                    appProvider.setMonth(e);
                  },
                ),
              ),
            if (appProvider.DATE_FILTER_TYPE == "Quarterly")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: PopupMenuButton<List>(
                  child: IconText(
                    label: appProvider.QUARTER_SELECTED[2],
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    icon: Icons.arrow_drop_down_rounded,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: [1, 4, "1st Quarter"],
                        child: Text("1st Quarter")),
                    const PopupMenuItem(
                        value: [4, 7, "2nd Quarter"],
                        child: Text("2nd Quarter")),
                    const PopupMenuItem(
                        value: [7, 10, "3rd Quarter"],
                        child: Text("3rd Quarter")),
                    const PopupMenuItem(
                        value: [10, 13, "4th Quarter"],
                        child: Text("4th Quarter")),
                  ],
                  offset: const Offset(0, 30),
                  elevation: 2,
                  onSelected: (e) {
                    getQuarter(e, appProvider.YEAR_SELECTED);
                    appProvider.setQuarter(e);
                  },
                ),
              ),
            if (["Yearly", "Quarterly", "Monthly", "Weekly"]
                .contains(appProvider.DATE_FILTER_TYPE))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: PopupMenuButton<int>(
                  child: IconText(
                    label: appProvider.YEAR_SELECTED.toString(),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    icon: Icons.arrow_drop_down_rounded,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 2022, child: Text("2022")),
                    const PopupMenuItem(value: 2023, child: Text("2023")),
                    const PopupMenuItem(value: 2024, child: Text("2024")),
                    const PopupMenuItem(value: 2025, child: Text("2025")),
                    const PopupMenuItem(value: 2026, child: Text("2026")),
                    const PopupMenuItem(value: 2027, child: Text("2027")),
                    const PopupMenuItem(value: 2028, child: Text("2028")),
                    const PopupMenuItem(value: 2029, child: Text("2029")),
                  ],
                  offset: const Offset(0, 30),
                  elevation: 2,
                  onSelected: (e) {
                    getYear(e);
                    appProvider.setYear(e);
                  },
                ),
              ),
            if (["Custom"].contains(appProvider.DATE_FILTER_TYPE))
              Row(children: [
                Button(
                  label: DateFormat("MMMM dd, yyyy")
                      .format(DateTime.parse(startDate)),
                  onPress: onChangeDate,
                  borderColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  borderRadius: 5,
                  textColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.black87,
                ),
                const SizedBox(width: 10),
                Button(
                  label: DateFormat("MMMM dd, yyyy")
                      .format(DateTime.parse(endDate)),
                  onPress: onChangeDate,
                  borderColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  borderRadius: 5,
                  textColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
              ])
          ]),
        ));
  }
}
