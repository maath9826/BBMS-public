import 'dart:typed_data';

import 'package:blood_bank_system/api/pdf_donor_form_api.dart';
import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/models/local/data_table/data_table_data.dart';
import 'package:blood_bank_system/models/local/data_table/data_table_search_data.dart';
import 'package:blood_bank_system/widgets/search_field.dart';
import 'package:blood_bank_system/widgets/submit_button.dart';
import 'package:blood_bank_system/widgets/three_fields_date.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../helpers/constant_variables.dart';
import '../../helpers/converters.dart';
import '../../helpers/functions.dart';
import '../../helpers/service.dart';
import '../../models/client/client.dart';
import '../../models/donor_form/donor_form.dart';
import '../../models/local/data_table/data_table_page_data.dart';
import '../../models/local/detail.dart';
import '../../models/local/donor_form_main_info.dart';
import '../../models/local/donor_main_info.dart';
import '../../models/local/invoice.dart';
import '../../pages/create_form_page.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

final _tableHeaderTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54);

var _isLoading = false;

class CustomDataTable extends StatefulWidget {
  CustomDataTable({
    Key? key,
    required DataTableData dataTableData,
  })  : _dataTableData = dataTableData,
        super(key: key);

  DataTableData _dataTableData;

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  late final DTSource _dataTableSource;

  final _searchController = TextEditingController();
  final _dateSearchController = TextEditingController();
  final _paginatorController = PaginatorController();

  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  DateTime? _birthDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataTableSource = DTSource(
      dataTableData: widget._dataTableData,
      context: context,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dataTableSource.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (_isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
      PaginatedDataTable2(
        empty: Center(
            child: Text(
          'no data',
          style: _tableHeaderTextStyle,
        )),
        controller: _paginatorController,
        headingRowHeight: 30,
        dataRowHeight: 50,
        columns: _dataColumns,
        source: _dataTableSource,
        onPageChanged: _onPageChanged,
        showCheckboxColumn: false,
        header: Row(
          children: [
            SearchField(
              searchController: _searchController,
              onSubmitted: (text) => _onSearch(),
            ),
            const SizedBox(
              width: 16,
            ),
            // ThreeFieldsDate(
            //   dayController: _dayController,
            //   monthController: _monthController,
            //   yearController: _yearController,
            //   onChange: (DateTime date) {
            //     _birthDate = date;
            //   },
            // ),
            // const SizedBox(
            //   width: 16,
            // ),
            SearchField(
              searchController: _dateSearchController,
              onSubmitted: (text) => _onSearch(),
              maskFormatter: MaskTextInputFormatter(mask: "##/##/####"),
              maskType: MaskType.date,
            ),
            const SizedBox(
              width: 16,
            ),
            SizedBox(
              height: searchButtonHeight,
              child: ElevatedButton(
                onPressed: _onSearch,
                child: const Text('Search'),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: searchButtonHeight,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed(CreateFormPage.routeName);
                      },
                      child: const Text('New Form'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: 300,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  final _dataColumns = [
    DataColumn(
      label: Text(
        'form code'.toUpperCase(),
        style: _tableHeaderTextStyle,
      ),
    ),
    DataColumn(
      label: Text(
        'donor name'.toUpperCase(),
        style: _tableHeaderTextStyle,
      ),
    ),
    DataColumn(
      label: Text(
        'donor status'.toUpperCase(),
        style: _tableHeaderTextStyle,
      ),
    ),
    DataColumn(
      label: Text(
        'form status'.toUpperCase(),
        style: _tableHeaderTextStyle,
      ),
    ),
    DataColumn(
      label: Text(
        'date'.toUpperCase(),
        style: _tableHeaderTextStyle,
      ),
    ),
  ];

  _onPageChanged(rowIndex) async {
    if (rowIndex >= widget._dataTableData.totalDonorForms.length) {
      await _getData();
    }
  }

  void _onSearch() async {
    _updateBirthDate();

    String text = _searchController.text;

    _paginatorController.goToFirstPage();

    ///on empty search
    if (text.trim().isEmpty && _birthDate == null) {
      _wipeData();
      return;
    }

    ///on search
    ///show loading
    setState(() {
      _isLoading = true;
    });

    ///get data
    DataTableSearchData _searchData;

    print('_birthDate: $_birthDate');

    try {
      _searchData =
          await getSearchedDataTableData(limit: 20, searchText: text.trim(), birthDate: _birthDate);
    } catch (e, s) {
      print(e);
      print(s);
      _searchData = DataTableSearchData(
        rowCount: 0,
        donorForms: [],
        clientsGraph: {},
      );
    }

    ///insert data
    _dataTableSource._searchedDataTableData = _searchData;

    ///hide loading
    setState(() {
      _isLoading = false;
    });
    _dataTableSource.notifyListeners();
  }

  _getData() async {
    ///show loading
    setState(() {
      _isLoading = true;
    });

    ///get data
    DataTablePageData _pageData;
    try {
      _pageData = await getNextPage(
        limit: 10,
        lastDonorFormDocSnapshot: _dataTableSource._dataTableData.lastDonorFormDocSnapshot!,
      );
    } catch (e, s) {
      print(e);
      print(s);
      _pageData = DataTablePageData(
        donorForms: [],
        clientsGraph: {},
      );
    }

    ///insert data
    _dataTableSource._dataTableData.lastDonorFormDocSnapshot = _pageData.lastDonorFormDocSnapshot!;
    _dataTableSource._dataTableData.totalDonorForms.addAll(_pageData.donorForms);
    _dataTableSource._dataTableData.totalClientsGraph.addAll(_pageData.clientsGraph);

    ///hide loading
    setState(() {
      _isLoading = false;
    });
    _dataTableSource.notifyListeners();
  }

  _wipeData() {
    _dataTableSource._searchedDataTableData = null;
    _dataTableSource.notifyListeners();
  }

  void _updateBirthDate() {
    if (_dateSearchController.text.trim().isEmpty ||
        _dateSearchController.text.split("/").length != 3
    ) {
      _birthDate = null;
    }
    else{
      var dateList = _dateSearchController.text.split("/");
      _birthDate = DateTime(
        int.parse(dateList[2]),
        int.parse(dateList[1]),
        int.parse(dateList[0]),
      );
    }
  }
}

class DTSource extends DataTableSource {
  final DataTableData _dataTableData;
  DataTableSearchData? _searchedDataTableData;
  final BuildContext context;

  DTSource({
    required DataTableData dataTableData,
    required this.context,
    DataTableSearchData? searchedDataTableData,
  })  : _dataTableData = dataTableData,
        _searchedDataTableData = searchedDataTableData;

  @override
  DataRow? getRow(int index) {
    if (_isLoading) {
      return const DataRow(cells: [
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
      ]);
    }

    late final DonorForm donorForm;
    late final Client client;
    late final List<Detail> details;

    if (_searchedDataTableData == null) {
      donorForm = _dataTableData.totalDonorForms[index];
      client = _dataTableData.totalClientsGraph[donorForm.clientId]!;
      details = getDataTableFormDetails(
        client: client,
        donorForm: donorForm,
      );
    } else {
      donorForm = _searchedDataTableData!.donorForms[index];
      client = _searchedDataTableData!.clientsGraph[donorForm.clientId]!;
      details = getDataTableFormDetails(
        client: client,
        donorForm: donorForm,
      );
    }
    return _searchedDataTableData == null
        ? DataRow(
            onSelectChanged: (isSelected) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return Dialog(
                      child: SizedBox(
                        height: 450,
                        width: 350,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16),
                                child: SubmitButton(
                                  onPressed: () async {
                                    final font = await PdfGoogleFonts.openSansRegular();

                                    final donorFormPDF = DonorFormPDF(
                                      clientMainInfo: ClientMainInfo(
                                        name: client.name,
                                        province: client.province,
                                        city: client.city,
                                        age: ((client.birthDate
                                                        .difference(DateTime.now())
                                                        .abs()
                                                        .inDays /
                                                    365)
                                                .round())
                                            .toString(),
                                      ),
                                      donorFormMainInfo: DonorFormMainInfo(
                                        date: donorForm.creationDate,
                                        code: donorForm.code,
                                        donorCode: donorForm.clientId.substring(0,8),
                                      ),
                                      details: [
                                        Detail(
                                          key: 'Birth date',
                                          value: dateTimeToString(client.birthDate),
                                        ),
                                        Detail(
                                          key: 'Gender',
                                          value: enumToString(client.gender),
                                        ),
                                        Detail(
                                          key: 'Province',
                                          value: client.province,
                                        ),
                                        Detail(
                                          key: 'City',
                                          value: client.city,
                                        ),
                                        if (isAssigned(client.phoneNumber))
                                          Detail(
                                            key: 'Phone number',
                                            value: client.phoneNumber!,
                                          ),
                                      ],
                                    );

                                    final pdfDoc = await PdfDonorFormApi.generate(donorFormPDF);

                                    await Printing.layoutPdf(
                                      onLayout: (PdfPageFormat format) async => pdfDoc.save(),
                                    );
                                  },
                                  title: 'PRINT',
                                ),
                              ),
                              ...details
                                  .map(
                                    (detail) => Column(
                                      children: [
                                        ListTile(
                                          title: Text(detail.key),
                                          tileColor: detail.key == "unban date" || detail.key == "rejection cause"? Colors.redAccent : null,
                                          trailing: detail.key == "code" ? SelectableText(detail.value) : Text(detail.value),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 40),
                                        ),
                                        if (details[details.length - 1] != detail)
                                          Divider(
                                            thickness: 0,
                                            height: 0,
                                          ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ]),
                          ),
                        ),
                      ),
                    );
                  });
            },
            color: donorForm.status == DonorFormStatus.rejected
                ? MaterialStateProperty.all<Color?>(Colors.redAccent)
                : null,
            cells: [
              _buildDataCell(donorForm.code),
              _buildDataCell(
                client.name,
              ),
              _buildDataCell(
                enumToString(
                  client.status,
                ),
              ),
              _buildDataCell(enumToString(donorForm.status)),
              _buildDataCell(dateTimeToString(donorForm.creationDate)),
            ],
          )
        : DataRow(
            onSelectChanged: (isSelected) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return Dialog(
                      child: SizedBox(
                        height: 450,
                        width: 350,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16),
                                child: SubmitButton(
                                  onPressed: () async {
                                    final font = await PdfGoogleFonts.openSansRegular();

                                    final donorFormPDF = DonorFormPDF(
                                      clientMainInfo: ClientMainInfo(
                                        name: client.name,
                                        province: client.province,
                                        city: client.city,
                                        age: ((client.birthDate
                                                        .difference(DateTime.now())
                                                        .abs()
                                                        .inDays /
                                                    365)
                                                .round())
                                            .toString(),
                                      ),
                                      donorFormMainInfo: DonorFormMainInfo(
                                        date: donorForm.creationDate,
                                        code: donorForm.code,
                                        donorCode: donorForm.clientId.substring(0,8),
                                      ),
                                      details: [
                                        Detail(
                                          key: 'Birth date',
                                          value: dateTimeToString(client.birthDate),
                                        ),
                                        Detail(
                                          key: 'Gender',
                                          value: enumToString(client.gender),
                                        ),
                                        Detail(
                                          key: 'Province',
                                          value: client.province,
                                        ),
                                        Detail(
                                          key: 'City',
                                          value: client.city,
                                        ),
                                        if (isAssigned(client.phoneNumber))
                                          Detail(
                                            key: 'Phone number',
                                            value: client.phoneNumber!,
                                          ),
                                      ],
                                    );

                                    final pdfDoc = await PdfDonorFormApi.generate(donorFormPDF);

                                    await Printing.layoutPdf(
                                      onLayout: (PdfPageFormat format) async => pdfDoc.save(),
                                    );
                                  },
                                  title: 'PRINT',
                                ),
                              ),
                              ...details
                                  .map(
                                    (detail) => Column(
                                      children: [
                                        ListTile(
                                          title: Text(detail.key),
                                          tileColor: detail.key == "unban date" || detail.key == "rejection cause"? Colors.redAccent : null,
                                          trailing: Text(detail.value),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 40),
                                        ),
                                        if (details[details.length - 1] != detail)
                                          Divider(
                                            thickness: 0,
                                            height: 0,
                                          ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ]),
                          ),
                        ),
                      ),
                    );
                  });
            },
            color: donorForm.status == DonorFormStatus.rejected
                ? MaterialStateProperty.all<Color?>(Colors.redAccent)
                : null,
            cells: [
              _buildDataCell(donorForm.code),
              _buildDataCell(
                client.name,
              ),
              _buildDataCell(enumToString(
                client.status,
              )),
              _buildDataCell(
                enumToString(donorForm.status),
              ),
              _buildDataCell(dateTimeToString(donorForm.creationDate)),
            ],
          );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _searchedDataTableData == null
      ? _dataTableData.totalRowCount
      : _searchedDataTableData!.rowCount;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  DataCell _buildDataCell(String data) {
    return DataCell(
      Text(
        data,
      ),
    );
  }
}
