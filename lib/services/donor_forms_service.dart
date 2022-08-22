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

class DonorFormsService with ChangeNotifier {
  final _collectionRef =
      FirebaseFirestore.instance.collection(CollectionsName.donorForms);


  Future<DocumentSnapshot<Map<String, dynamic>>> get(String formId) async {
    return await _collectionRef.doc(formId).get();
  }

  DocumentReference<Map<String, dynamic>> getReference(String formId)  {
    return _collectionRef.doc(formId);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getList({
    int? limit,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
    String? searchText,
  }) async {
    if (limit != null) {
      if (lastDoc != null) {
        return await _collectionRef
            .orderBy('creationDate', descending: true)
            .startAfterDocument(lastDoc)
            .limit(limit)
            .get();
      }
      if (isAssigned(searchText)) {
        return await _collectionRef
            .orderBy('creationDate', descending: true)
            .where('code', isEqualTo: searchText)
            .limit(limit)
            .get();
      }
      return await _collectionRef
          .orderBy('creationDate', descending: true)
          .limit(limit)
          .get();
    }
    return await _collectionRef.orderBy('creationDate', descending: true).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListFromList({
    int? limit,
    required List list,
    required field,
  }) async {
    if (limit != null) {
      return await _collectionRef
          .orderBy('creationDate', descending: true)
          .where(field, whereIn: list)
          .limit(limit)
          .get();
    }
    return await _collectionRef
        .orderBy('creationDate', descending: true)
        .where(field, whereIn: list)
        .get();
  }

  Future<int> getCount() async =>
      await _collectionRef.get().then((snapshot) => snapshot.size);

  Future<DocumentSnapshot<Map<String, dynamic>>> add(
    DonorForm donorForm,
  ) async{
    var docSnapshot = await _collectionRef.add(donorForm.toJson()).then((doc) => doc.get());
    notifyListeners();
    return docSnapshot;
  }

  Future<void> update(
    String donorFormId,
    Map<String,dynamic> data,
  ) async =>
    await _collectionRef.doc(donorFormId).update(data);

  Future<void> addBagsAndGoNext({
    required String donorFormId,
    required List<Map<String, dynamic>> dataList,
    required double numberOfBags,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    for(var data in dataList){
      var docRef = _collectionRef.doc(donorFormId).collection('bags').doc();
      batch.set(docRef, data);
    }
    var donorFormDocRef = _collectionRef.doc(donorFormId);
    batch.update(donorFormDocRef, {
      'stage': enumToString(DonorFormStage.diseasesDetection),
      'numberOfBags': numberOfBags,
    });
    await batch.commit();
  }

}
