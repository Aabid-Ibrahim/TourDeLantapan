// import 'dart:html';
import 'dart:convert';

import 'package:app/models/visitor_model.dart';
import 'package:app/widgets/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

generatePDF(BuildContext context,
    {required List<Visitor> visitors, required String totalCount}) async {
  //Create a new PDF document
  PdfDocument document = PdfDocument();

//Create a PdfGrid class
  PdfGrid grid = PdfGrid();

//Add the columns to the grid
  grid.columns.add(count: 6);

//Add header to the grid
  grid.headers.add(1);

  document.pageSettings.orientation = PdfPageOrientation.landscape;

//Add the rows to the grid
  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'Destination';
  header.cells[1].value = 'Full Name';
  header.cells[2].value = 'Address';
  header.cells[3].value = 'Date of Visit';
  header.cells[4].value = 'Total Visitors';
  header.cells[5].value = 'Contact Number';

//Add rows to grid

  List.generate(visitors.length, (index) {
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = visitors[index].placeId.name;
    row.cells[1].value = visitors[index].fullName;
    row.cells[2].value =
        "${visitors[index].address.cityMunicipality}, ${visitors[index].address.province}, ${visitors[index].address.region}";

    row.cells[3].value =
        DateFormat("MMM dd, yyyy").format(visitors[index].dateOfVisit);
    row.cells[4].value = visitors[index].numberOfVisitors.toString();
    row.cells[5].value = "+63${visitors[index].contactNumber}";
  });

//Set the grid style
  grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.wheat,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 25));

//Draw the grid
  grid.draw(
      page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

  document.pages.add().graphics.drawString(
      "Total Count: $totalCount", PdfStandardFont(PdfFontFamily.timesRoman, 25),
      bounds: const Rect.fromLTWH(0, 0, 200, 50));

  try {
    if (kIsWeb) {
      // AnchorElement(
      //     href:
      //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(await document.save())}")
      //   ..setAttribute("download", "output.pdf")
      //   ..click();
    }
  } catch (e) {
    launchSnackbar(context: context, mode: "ERROR", message: "Failed to save");
  }

  document.dispose();
}
