import 'package:app/models/visitor_model.dart';
import 'package:app/provider/app_provider.dart';
import 'package:app/provider/user_provider.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/utilities/generate_pdf.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/date_filter.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VisitorTable extends StatefulWidget {
  VisitorTable({Key? key}) : super(key: key);

  @override
  State<VisitorTable> createState() => _VisitorTableState();
}

class _VisitorTableState extends State<VisitorTable> {
  String startDate = "2022-07-01";
  String endDate = "2022-07-30";

  getVisitorsList() {
    Provider.of<UserProvider>(context, listen: false).getVisitors(
        query: {"startDate": startDate, "endDate": endDate},
        callback: (code, message) {
          if (code != 200) {
            launchSnackbar(context: context, mode: "ERROR", message: message);
          }
        });
  }

  @override
  void initState() {
    () async {
      await Future.delayed(Duration.zero);
      if (!mounted) return;
      Provider.of<AppProvider>(context, listen: false).resetFilter();
      DateTime now = DateTime.now();
      setState(() {
        startDate =
            DateFormat("yyyy-MM-dd").format(DateTime(now.year, now.month, 1));
        endDate = DateFormat("yyyy-MM-dd")
            .format(DateTime(now.year, now.month + 1, 0));
      });
      getVisitorsList();
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();

    DataTableSource dataSource(List<Visitor> visitorList) =>
        TableData(dataList: visitorList);

    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        color: textColor2,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconText(
              label: "Total Visitors",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              size: 18,
            ),
            IconText(
              label: userProvider.visitorCount.toString(),
              color: Colors.black,
              fontWeight: FontWeight.bold,
              size: 18,
            ),
          ]),
          if (kIsWeb)
            Button(
                label: "Generate PDF",
                onPress: () {
                  generatePDF(context,
                      visitors: userProvider.visitorList,
                      totalCount: userProvider.visitorCount.toString());
                })
        ]),
      ),
      DateFilter(
          onApplyFilter: (startDate, endDate) {
            setState(() {
              this.startDate = DateFormat("yyyy-MM-dd").format(startDate);
              this.endDate = DateFormat("yyyy-MM-dd").format(endDate);
            });
            getVisitorsList();
          },
          startDate: startDate,
          endDate: endDate),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(children: [
          IconText(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              label:
                  "Visitors inside Bukidnon: ${userProvider.visitorCountInBukidnon}"),
          const SizedBox(
            width: 20,
          ),
          IconText(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              label:
                  "Visitors outside Bukidnon: ${userProvider.visitorCountOutsideBukidnon}"),
        ]),
      ),
      const SizedBox(
        height: 15,
      ),
      if (userProvider.loading == "visitor-list")
        const Padding(
          padding: EdgeInsets.all(25),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (userProvider.visitorList.isNotEmpty)
        Expanded(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PaginatedDataTable(
            source: dataSource(userProvider.visitorList),
            rowsPerPage: userProvider.visitorList.length < 10
                ? userProvider.visitorList.length
                : 10,
            columns: [
              DataColumn(
                  label: IconText(
                label: 'Destination',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Full Name',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Address',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Date of Visit',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Total Visitors',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
              DataColumn(
                  label: IconText(
                label: 'Contact Number',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                size: 13,
              )),
            ],
            showCheckboxColumn: false,
          ),
        ))
    ]);
  }
}

class TableData extends DataTableSource {
  TableData({required this.dataList});
  final List<Visitor> dataList;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => dataList.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: [
        DataCell(
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          dataList[index].placeId.photos.isNotEmpty
                              ? dataList[index].placeId.photos[0].small!
                              : placeholderImage))),
            ),
            Text(dataList[index].placeId.name),
          ]),
        ),
        DataCell(
          Text(dataList[index].fullName),
        ),
        DataCell(
          Text(
              "${dataList[index].address.cityMunicipality}, ${dataList[index].address.province}, ${dataList[index].address.region}"),
        ),
        DataCell(
          Text(DateFormat("MMM dd, yyyy").format(dataList[index].dateOfVisit)),
        ),
        DataCell(
          Text(dataList[index].numberOfVisitors.toString()),
        ),
        DataCell(Text("+63${dataList[index].contactNumber}")),
      ],
    );
  }
}
