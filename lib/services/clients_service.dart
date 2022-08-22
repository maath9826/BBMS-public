import 'package:blood_bank_system/helpers/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/client/client.dart';

class ClientsService {
  var _collectionRef = FirebaseFirestore.instance.collection('clients');

  Future<QuerySnapshot<Map<String, dynamic>>> getList({
    int? limit,
    String searchText = "",
    DateTime? birthDate,
  }) async {
    if (limit != null) {
      if(isAssigned(birthDate)){
        print('isAssigned(birthDate): ${isAssigned(birthDate)}');
        return await _collectionRef
            .where('birthDate',isEqualTo: Timestamp.fromDate(birthDate!))
            .orderBy('name')
            .startAt([searchText])
            .endAt([searchText + "\uf8ff"])
            .limit(limit)
            .get();
      }
      return await _collectionRef
          .orderBy('name')
          .startAt([searchText])
          .endAt([searchText + "\uf8ff"])
          .limit(limit)
          .get();
    }
    if(isAssigned(birthDate)){
      return await _collectionRef
          .where('birthDate',isEqualTo: Timestamp.fromDate(birthDate!))
          .orderBy('name')
          .startAt([searchText])
          .endAt([searchText + "\uf8ff"])
          .get();
    }
    return await _collectionRef
        .orderBy('name')
        .startAt([searchText]).endAt([searchText + "\uf8ff"]).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListFromList({
    int? limit,
    required List list,
    required field,
  }) async {
    if (limit != null) {
      return await _collectionRef
          .where(field, whereIn: list)
          .limit(limit)
          .get();
    }

    return await _collectionRef
        .where(field, whereIn: list)
        .get();

  }

  Future<DocumentSnapshot<Map<String, dynamic>>> get(String clientId) async => await _collectionRef.doc(clientId).get();

  DocumentReference<Map<String, dynamic>> getReference(String clientId)  {
    return _collectionRef.doc(clientId);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> add(Client client) async => await _collectionRef.add(client.toJson()).then((doc) async => await doc.get());

  Future<void> update(
      String clientId,
      Map<String,dynamic> data,
      ) async =>
      await _collectionRef.doc(clientId).update(data);
}
