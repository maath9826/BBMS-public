import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/client/client.dart';

class StorageService {
  final _collectionRef = FirebaseFirestore.instance.collection('storage');

  Stream<QuerySnapshot<Map<String, dynamic>>> getListStream() => _collectionRef.snapshots();

  Future<DocumentSnapshot<Map<String, dynamic>>> get(String storageName) async =>
      await _collectionRef.doc(storageName).get();

  DocumentReference<Map<String, dynamic>> getReference(String storageName) {
    return _collectionRef.doc(storageName);
  }

  Future<void> update(
    String storageName,
    Map<String, dynamic> data,
  ) async =>
      await _collectionRef.doc(storageName).update(data);
}
