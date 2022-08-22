
import 'dart:html';

import 'package:barcode/barcode.dart';
import 'package:blood_bank_system/models/donor_form/donor_form.dart';
import 'package:blood_bank_system/models/local/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../models/client/client.dart';
import 'converters.dart';
import 'enums.dart';

bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  return num.tryParse(s) != null;
}

bool isAssigned(dynamic variable){
  return variable != null && variable != "";
}

Widget? handleStreamErrors(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
  if (snapshot.hasError) {
    print(snapshot.error);
    print(snapshot.stackTrace);
    return const Text('Error!!!');
  }
  if (!snapshot.hasData) {
    return const Center(child: CircularProgressIndicator());
  }
  return null;
}

String getMaskHint(MaskType maskType){
  var hint = '';
  switch(maskType){

    case MaskType.date:
      hint = 'dd/mm/yyyy';
      break;
  }
  return hint;
}

List<Detail> getDataTableFormDetails(
    {required DonorForm donorForm, required Client client}) {
  return [
    Detail(
      key: 'is banned',
      value: client.status == ClientStatus.banned ? 'YES' : 'NO',
    ),
    if (client.status == ClientStatus.banned && isAssigned(client.unbanDate))
      Detail(
        key: 'unban date',
        value: dateTimeToString(client.unbanDate!),
      ),
    if (client.status == ClientStatus.banned && !isAssigned(client.unbanDate))
      Detail(
        key: 'unban date',
        value: 'permanent',
      ),
    if (client.status == ClientStatus.banned)
      Detail(
        key: 'rejection cause',
        value: generateRejectionCauseMessage(
          cause: donorForm.rejectionCause!,
          note: donorForm.rejectionNote,
        ),
      ),
    Detail(
      key: 'name',
      value: client.name,
    ),
    Detail(
      key: 'gender',
      value: enumToString(client.gender),
    ),
    if (isAssigned(client.phoneNumber))
      Detail(
        key: 'phone number',
        value: client.phoneNumber!,
      ),
    if (isAssigned(client.bloodGroup))
      Detail(
        key: 'blood group',
        value: client.bloodGroup!,
      ),
    Detail(
      key: 'province',
      value: client.province,
    ),
    Detail(
      key: 'city',
      value: client.city,
    ),
    Detail(
      key: 'birth date',
      value: dateTimeToString(client.birthDate),
    ),
    Detail(
      key: 'balance',
      value: client.balance.toString(),
    ),
    Detail(
      key: 'code',
      value: donorForm.code,
    ),
    Detail(
      key: 'status',
      value: enumToString(donorForm.status),
    ),
    Detail(
      key: 'stage',
      value: enumToString(donorForm.stage),
    ),
    Detail(
      key: 'numberOfBags',
      value: donorForm.numberOfBags.toString(),
    ),
  ];
}

DonorFormStage getNextStage(DonorFormStage currentStage){
   return DonorFormStage.values[DonorFormStage.values.indexOf(currentStage) + 1];
}


showToast({
  required String text,
  required BuildContext context,
  required color,
  int durationInSeconds = 5,
}){
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 12.0,
        ),
        Text(text),
      ],
    ),
  );

  FToast fToast = FToast();
  fToast.init(context);

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    toastDuration: Duration(seconds: durationInSeconds),
  );
}

String generateRejectionCauseMessage({required RejectionCause cause, String? note,}){
  if(cause == RejectionCause.hbDeficiency){
    return 'Hb deficiency';
  }
  if(cause == RejectionCause.hIV){
    return 'HIV';
  }
  if(cause == RejectionCause.hBV){
    return 'HBV';
  }
  if(cause == RejectionCause.hCV){
    return 'HCV';
  }
  if(cause == RejectionCause.syphilis){
    return 'Syphilis';
  }
  if(cause == RejectionCause.other){
    return note ?? '';
  }
  return '';
}

