import 'package:blood_bank_system/services/bags_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/user/user.dart';
import '../services/clients_service.dart';
import '../services/donor_forms_service.dart';
import '../services/storage_service.dart';

class Variable{
  static User? currentUser;
  static get currentUserId{
    return firebase_auth.FirebaseAuth.instance.currentUser!.uid;
  }
}

class Service{
  static final donorForms = DonorFormsService();
  static final clients = ClientsService();
  static final bags = BagsService();
  static final storage = StorageService();
}

