
import 'detail.dart';
import 'donor_form_main_info.dart';
import 'donor_main_info.dart';

class DonorFormPDF {
  final ClientMainInfo clientMainInfo;
  final DonorFormMainInfo donorFormMainInfo;
  final List<Detail> details;

  const DonorFormPDF({
    required this.clientMainInfo,
    required this.donorFormMainInfo,
    required this.details,
  });
}
