import 'package:blood_bank_system/models/client/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../donor_form/donor_form.dart';

class DataTableData {
  List<DonorForm> totalDonorForms;
  Map<String, Client> totalClientsGraph;
  int totalRowCount;
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDonorFormDocSnapshot;

  DataTableData({
    required this.totalClientsGraph,
    required this.totalDonorForms,
    required this.totalRowCount,
    this.lastDonorFormDocSnapshot,
  });
}
