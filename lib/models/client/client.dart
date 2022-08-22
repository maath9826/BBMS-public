import 'package:blood_bank_system/helpers/converters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../helpers/enums.dart';
import '../local/detail.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  final String name;
  final Gender gender;
  final String? bloodGroup;
  final String province;
  final String city;
  final String? phoneNumber;
  final ClientStatus status;
  final int balance;
  final bool isPublic;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime birthDate;
  @JsonKey(fromJson: _unbanDateFromJson, toJson: _unbanDateToJson)
  final DateTime? unbanDate;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime creationDate;

  Client({
    required this.name,
    required this.province,
    required this.city,
    required this.gender,
    required this.birthDate,
    required this.creationDate,
    this.bloodGroup,
    this.balance = 0,
    this.isPublic = false,

    this.status = ClientStatus.available,
    this.phoneNumber,

    this.unbanDate,
  });

  factory Client.fromJson(Map<String, dynamic> data) => _$ClientFromJson(data);

  Map<String, dynamic> toJson() => _$ClientToJson(this);

  static DateTime _dateFromJson(Timestamp value) => value.toDate();

  static Timestamp _dateToJson(DateTime value) => Timestamp.fromDate(value);

  static DateTime? _unbanDateFromJson(dynamic value) =>
      value == '' || value == null ? null : value!.toDate();

  static Timestamp? _unbanDateToJson(dynamic value) =>
      value == '' || value == null ? null : Timestamp.fromDate(value!);

  List<Detail> get details {
    return [
        Detail(value: province, key: 'province'),
        Detail(value: enumToString(gender), key: 'gender'),
        Detail(value: enumToString(gender), key: 'gender'),
        Detail(value: enumToString(gender), key: 'gender'),
        if (phoneNumber != null && phoneNumber!.isNotEmpty)
          Detail(value: phoneNumber!, key: 'phone number'),
    ];
  }
}

class FullClient {
  final String id;
  final String name;
  final Client client;

  FullClient({
    required this.client,
    required this.id,
    required this.name,
  });
}
