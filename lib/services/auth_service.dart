import 'dart:async';

import 'package:blood_bank_system/helpers/statics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';

import '../helpers/constant_variables.dart';
import '../helpers/converters.dart';
import '../helpers/enums.dart';
import '../models/client/client.dart';
import '../models/user/user.dart';
import 'users_service.dart';

class AuthService {
  late Stream authStateStream;
  AuthService(){
    authStateStream = _fbAuthInstance.authStateChanges().asBroadcastStream();
  }

  final firebase_auth.FirebaseAuth _fbAuthInstance = firebase_auth.FirebaseAuth.instance;
  final UsersService _usersService = UsersService();



  Future<bool> get isAuth async {
    if(_fbAuthInstance.currentUser != null){
      await _usersService.get(Variable.currentUserId).then((value) => Variable.currentUser =  User.fromJson(value.data()!));
      return true;
    }
    return false;
  }

  //firebase auth will automatically login when signup
  Future<void> signup({
    required String username,
    required String password,
    required User user,
  }) async {
    try{
      await _fbAuthInstance.createUserWithEmailAndPassword(email: username + domain, password: password).catchError((onError){
        throw onError;
      });
      await _usersService.set(user, Variable.currentUserId).then((_) => user);
      Variable.currentUser = user;
    }catch(e){
      rethrow;
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try{
      await _fbAuthInstance.signInWithEmailAndPassword(email: username + domain, password: password).catchError((onError){
        throw onError;
      });
      Variable.currentUser = User.fromJson((await _usersService.get(Variable.currentUserId)).data()!);
      await _unbanUsers();
    }catch(e){
      rethrow;
    }
  }

  Future<void> logout() async {
    await _fbAuthInstance.signOut().catchError((onError)=> throw onError);
    Variable.currentUser = null;
  }

  _unbanUsers() async {
    await Service.clients.getList().then((snapshot) async {
      var batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshot.docs) {
        var client = Client.fromJson(doc.data());
        final isBanned = client.status == ClientStatus.banned;
        if (isBanned && client.unbanDate == null) continue;
        if (isBanned && client.unbanDate!.isBefore(DateTime.now())) {
          var docReference = Service.clients.getReference(doc.id);
          batch.update(docReference, {'unbanDate': null, 'status':enumToString(ClientStatus.available)});
        }
      }
      await batch.commit();
    });
  }
}