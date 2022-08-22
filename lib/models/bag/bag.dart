import 'package:blood_bank_system/helpers/converters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../helpers/enums.dart';
import '../local/detail.dart';

part 'bag.g.dart';

@JsonSerializable()
class Bag {
  final String donorFormId;
  final BagStage stage;
  final BagStatus status;
  final String bloodGroup;
  final String clientName;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime clientBirthDate;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime creationDate;

  Bag({
    required this.donorFormId,
    required this.clientName,
    required this.clientBirthDate,
    this.stage = BagStage.temporaryStorage,
    this.status = BagStatus.pending,
    required this.bloodGroup,
    required this.creationDate,
  });

  factory Bag.fromJson(Map<String, dynamic> data) => _$BagFromJson(data);

  Map<String, dynamic> toJson() => _$BagToJson(this);

  static DateTime _dateFromJson(Timestamp value) => value.toDate();

  static Timestamp _dateToJson(DateTime value) => Timestamp.fromDate(value);

List<Detail> get details {
  return [
    Detail(value: bloodGroup, key: 'blood group'),
    Detail(value: clientName, key: 'name'),
    Detail(value: dateTimeToString(clientBirthDate), key: 'birth date'),
  ];
}
}

class FullBag{
  final String id;
  final Bag bag;
  FullBag({required this.id, required this.bag,});
}
