import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/helpers/firebase.dart';
import 'package:blood_bank_system/models/bag/bag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../helpers/constant_variables.dart';
import '../helpers/converters.dart';
import '../helpers/functions.dart';
import '../helpers/statics.dart';
import '../models/donor_form/donor_form.dart';
import '../models/local/donorForm_and_client.dart';

class BagsService with ChangeNotifier {
  final _collectionRef = FirebaseFirestore.instance.collection('bags');

  // Future<DocumentSnapshot<Map<String, dynamic>>> getByFormId(
  //     {required String donorFormId, BagStage? stage}) async {
  //   if (isAssigned(stage)) {
  //     var doc = await _collectionRef.where('donorFormId', isEqualTo: donorFormId).get().then(
  //           (snap) =>
  //               snap.docs.where((doc) => doc.data()['stage'] == enumToString(stage)).toList()[0],
  //         );
  //     return doc;
  //   }
  //   var doc = await _collectionRef.where('donorFormId', isEqualTo: donorFormId).get().then((snap) => snap.docs[0]);
  //   return doc;
  // }

  DocumentReference<Map<String, dynamic>> getReference(String bagId) {
    return _collectionRef.doc(bagId);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getList({
    String? donorFormId,
    DateTime? startingDate,
  }) async {
    if (isAssigned(donorFormId)) {
      return await _collectionRef.where('donorFormId', isEqualTo: donorFormId).get();
    }
    if (isAssigned(startingDate)) {
      return await _collectionRef
          .where('creationDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startingDate!))
          .get();
    }
    return await _collectionRef.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getListStream({
    DateTime? startingDate,
    required BagStage stage,
  }) {
    if (isAssigned(startingDate)) {
      return _collectionRef
          .where('creationDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startingDate!))
          .where('stage', isEqualTo: enumToString(stage))
          .snapshots();
    }
    return _collectionRef.where('stage', isEqualTo: enumToString(stage)).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> add(
    DonorForm donorForm,
  ) async {
    var docSnapshot = await _collectionRef.add(donorForm.toJson()).then((doc) => doc.get());
    notifyListeners();
    return docSnapshot;
  }

  Future<void> update(
    String bagId,
    Map<String, dynamic> data,
  ) async =>
      await _collectionRef.doc(bagId).update(data);

  Future<void> addAll({
    required List<Map<String, dynamic>> dataList,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    for (var data in dataList) {
      var docRef = _collectionRef.doc();
      batch.set(docRef, data);
    }
    await batch.commit();
  }
}
