import 'package:cloud_firestore/cloud_firestore.dart';

import '../client/client.dart';
import '../donor_form/donor_form.dart';

class DonorFormAndClient{
  final DonorForm donorForm;
  final Client client;
  DonorFormAndClient({required this.client, required this.donorForm,});
}

