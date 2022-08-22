import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user/user.dart';

class UsersService{

  Future<void> set(User user, String userId) async {
    Map<String,dynamic> data = user.toJson();
    data['creationDate'] = FieldValue.serverTimestamp();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(data)
        .catchError((error) {
      throw error;
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> get(
      String userId) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

  Future<void> update(
      String userId,
      Map<String,dynamic> data,
      ) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(data)
          .catchError((error) {
        throw error;
      });

}








