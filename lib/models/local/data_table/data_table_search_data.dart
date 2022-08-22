import 'package:blood_bank_system/models/client/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../donor_form/donor_form.dart';

class DataTableSearchData {
  List<DonorForm> donorForms;
  Map<String, Client> clientsGraph;
  int rowCount;

  DataTableSearchData({
    required this.clientsGraph,
    required this.donorForms,
    required this.rowCount,
  });
}
