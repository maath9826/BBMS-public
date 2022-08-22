import 'package:blood_bank_system/models/donor_form/examining_form/examining_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../helpers/enums.dart';

part 'donor_form.g.dart';

@JsonSerializable()
class DonorForm {
  final String clientId;
  final RejectionCause? rejectionCause;
  final String? rejectionNote;
  final String code;
  double? hb;
  int numberOfStoredBags;
  int numberOfBags;
  DonorFormStatus status;
  DonorFormStage stage;
  @JsonKey(fromJson: _examiningFormFromJson, toJson: _examiningFormToJson)
  final ExaminingForm examiningForm;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime creationDate;

  DonorForm({
    required this.clientId,
    required this.creationDate,
    required this.code,
    required this.examiningForm,
    this.numberOfStoredBags = 0,
    this.numberOfBags = 0,
    this.status = DonorFormStatus.pending,
    this.stage = DonorFormStage.bloodClassificationAndHbLab,
    this.rejectionCause,
    this.rejectionNote,
    this.hb,
  });

  DonorFormStage get nextStage => DonorFormStage.values[DonorFormStage.values.indexOf(stage) + 1];

  factory DonorForm.fromJson(Map<String, dynamic> data) => _$DonorFormFromJson(data);

  Map<String, dynamic> toJson() => _$DonorFormToJson(this);

  static DateTime _dateFromJson(Timestamp value) => value.toDate();

  static Timestamp _dateToJson(DateTime value) => Timestamp.fromDate(value);

  static ExaminingForm _examiningFormFromJson(Map<String, dynamic> value) =>
      ExaminingForm.fromJson(value);

  static Map<String, dynamic> _examiningFormToJson(ExaminingForm value) => value.toJson();

// List<Detail> get details {
//   return [
//     // Detail(value: bloodGroup, key: 'blood group'),
//     // Detail(value: location, key: 'location'),
//     // Detail(value: gender.toString().split('.')[1], key: 'gender'),
//     // if (phoneNumber != null && phoneNumber!.isNotEmpty)
//     //   Detail(value: phoneNumber!, key: 'phone number'),
//   ];
// }

}

class FullDonorForm {
  final String id;
  final DonorForm donorForm;

  FullDonorForm({
    required this.donorForm,
    required this.id,
  });
}
