import 'dart:io';
import 'package:blood_bank_system/helpers/converters.dart';
import 'package:blood_bank_system/models/local/donor_form_main_info.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../models/local/donor_main_info.dart';
import '../models/local/invoice.dart';
import '../models/local/supplier.dart';

class PdfDonorFormApi {
  static Future<Document> generate(DonorFormPDF invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return pdf;
  }

  static Widget buildHeader(DonorFormPDF donorFormPDF) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildClientMainInfo(donorFormPDF.clientMainInfo),
          Container(
            height: 48,
            width: 120,
            child: BarcodeWidget(
              barcode: Barcode.code39(),
              data: donorFormPDF.donorFormMainInfo.code,
            ),
          ),
        ],
      ),
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDonorFormMainInfo(donorFormPDF),
        ],
      ),
    ],
  );

  static Widget buildDonorFormMainInfo(DonorFormPDF donorFormPDF) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSimpleText(title: 'Donor Code ', value: donorFormPDF.donorFormMainInfo.donorCode,),
      buildSimpleText(title: 'Address ', value: '${donorFormPDF.clientMainInfo.province} - ${donorFormPDF.clientMainInfo.city}',),
    ],
  );

  static Widget buildClientMainInfo(ClientMainInfo clientMainInfo) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(clientMainInfo.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text('${clientMainInfo.age} years old'),
    ],
  );

  static Widget buildTitle(DonorFormPDF invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'INFO',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),

    ],
  );

  static Widget buildInvoice(DonorFormPDF invoice) {
    final headers = [
      'Key',
      'value',
      // 'Quantity',
      // 'Unit Price',
      // 'VAT',
      // 'Total'
    ];
    final data = invoice.details.map((item) {

      return [
        item.key,
        item.value,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildFooter(DonorFormPDF invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'CREATION DATE', value: dateTimeToString(invoice.donorFormMainInfo.date)),
    ],
  );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}