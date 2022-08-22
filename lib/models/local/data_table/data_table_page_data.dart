import 'package:blood_bank_system/models/client/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../donor_form/donor_form.dart';

class DataTablePageData {
  List<DonorForm> donorForms;
  Map<String, Client> clientsGraph;
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDonorFormDocSnapshot;

  DataTablePageData({
    required this.clientsGraph,
    required this.donorForms,
    this.lastDonorFormDocSnapshot,
  });
}
