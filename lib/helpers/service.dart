import 'package:blood_bank_system/helpers/functions.dart';
import 'package:blood_bank_system/models/donor_form/donor_form.dart';
import 'package:blood_bank_system/models/local/data_table/data_table_data.dart';
import 'package:blood_bank_system/models/local/data_table/data_table_page_data.dart';
import 'package:blood_bank_system/services/clients_service.dart';
import 'package:blood_bank_system/services/donor_forms_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/client/client.dart';
import '../models/local/data_table/data_table_search_data.dart';
import 'converters.dart';
import 'enums.dart';
import 'statics.dart';

Future<DataTableData> getDataTableData({
  required int limit,
}) async {
  final _donorFormsService = DonorFormsService();
  final _clientsService = ClientsService();

  var _dataTableData = DataTableData(
    totalClientsGraph: {},
    totalDonorForms: [],
    totalRowCount: 0,
  );

  _dataTableData.totalRowCount = await _donorFormsService.getCount();

  if(_dataTableData.totalRowCount == 0) return _dataTableData;

  _dataTableData.totalDonorForms =
      await _donorFormsService.getList(limit: limit).then((snapshot) {
    _dataTableData.lastDonorFormDocSnapshot = snapshot.docs.last;
    return snapshot.docs
        .map(
          (doc) => DonorForm.fromJson(doc.data()),
        )
        .toList();
  });


  var _clientsIds = _dataTableData.totalDonorForms
      .map((donorForm) => donorForm.clientId)
      .toList();


  var _clientsSnapshot = await _clientsService.getListFromList(
      list: _clientsIds, field: '__name__');

  for (var i = 0; i < _clientsSnapshot.size; i++) {
    _dataTableData.totalClientsGraph[_clientsSnapshot.docs[i].id] =
        Client.fromJson(_clientsSnapshot.docs[i].data());
  }

  return _dataTableData;
}

Future<DataTablePageData> getNextPage({
  required int limit,
  required QueryDocumentSnapshot<Map<String, dynamic>> lastDonorFormDocSnapshot,
}) async {
  final _donorFormsService = DonorFormsService();
  final _clientsService = ClientsService();

  var _dataTablePageData = DataTablePageData(
    clientsGraph: {},
    donorForms: [],
  );
  _dataTablePageData.donorForms = await _donorFormsService
      .getList(
    limit: limit,
    lastDoc: lastDonorFormDocSnapshot,
  )
      .then(
    (snapshot) {
      _dataTablePageData.lastDonorFormDocSnapshot = snapshot.docs.last;
      return snapshot.docs
          .map(
            (doc) => DonorForm.fromJson(doc.data()),
          )
          .toList();
    },
  );

  var _clientsIds = _dataTablePageData.donorForms
      .map((donorForm) => donorForm.clientId)
      .toList();

  var _clientsSnapshot = await _clientsService.getListFromList(
      list: _clientsIds, field: '__name__');

  for (var i = 0; i < _clientsSnapshot.size; i++) {
    _dataTablePageData.clientsGraph[_clientsSnapshot.docs[i].id] =
        Client.fromJson(_clientsSnapshot.docs[i].data());
  }

  return _dataTablePageData;
}

Future<DataTableSearchData> getSearchedDataTableData({
  required int limit,
  required String searchText,
  DateTime? birthDate,
}) async {
  final _donorFormsService = DonorFormsService();
  final _clientsService = ClientsService();

  var _dataTableSearchData = DataTableSearchData(
    clientsGraph: {},
    donorForms: [],
    rowCount: 0,
  );

  if (isNumeric(searchText)) {
    _dataTableSearchData.donorForms = await _donorFormsService
        .getList(
      limit: limit,
      searchText: searchText,
    )
        .then(
      (snapshot) {
        _dataTableSearchData.rowCount = snapshot.size;
        return snapshot.docs
            .map(
              (doc) => DonorForm.fromJson(doc.data()),
            )
            .toList();
      },
    );

    var _clientsIds = _dataTableSearchData.donorForms
        .map((donorForm) => donorForm.clientId)
        .toList();

    var _clientsSnapshot = await _clientsService.getListFromList(
        list: _clientsIds, field: '__name__');

    for (var i = 0; i < _clientsSnapshot.size; i++) {
      _dataTableSearchData.clientsGraph[_clientsSnapshot.docs[i].id] =
          Client.fromJson(_clientsSnapshot.docs[i].data());
    }
  } else {
    var _clientsSnapshot = await _clientsService.getList(
      limit: limit,
      searchText: searchText,
      birthDate: birthDate
    );
    _dataTableSearchData.rowCount = _clientsSnapshot.size;
    for (var i = 0; i < _clientsSnapshot.size; i++) {
      _dataTableSearchData.clientsGraph[_clientsSnapshot.docs[i].id] =
          Client.fromJson(_clientsSnapshot.docs[i].data());
    }

    var _clientsIds = _dataTableSearchData.clientsGraph.keys.toList();

    _dataTableSearchData.donorForms = await _donorFormsService
        .getListFromList(limit: limit, list: _clientsIds, field: 'clientId')
        .then(
      (snapshot) {
        _dataTableSearchData.rowCount = snapshot.size;
        return snapshot.docs
            .map(
              (doc) => DonorForm.fromJson(doc.data()),
            )
            .toList();
      },
    );
  }

  return _dataTableSearchData;
}

updateDonorFormStatus({
  required DonorFormStatus status,
  required String donorFormId,
  RejectionCause? rejectionCause,
  String? rejectionNote,
}) async {
  await Service.donorForms.update(donorFormId, {
    'status': enumToString(status),
    'rejectionCause': enumToString(rejectionCause),
    'rejectionNote': rejectionNote,
  });
}

updateClientStatus({
  required ClientStatus status,
  required String clientId,
  DateTime? unbanDate,
}) async {
  await Service.clients.update(clientId, {
    'status': enumToString(status),
    if(isAssigned(unbanDate)) 'unbanDate': Timestamp.fromDate(unbanDate!),
  });
}

updateDonorFormStage({
  required DonorFormStage stage,
  required String donorFormId,
}) async {
  await Service.donorForms.update(donorFormId, {
    'stage': enumToString(stage),
  });
}
