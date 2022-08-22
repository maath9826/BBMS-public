// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      name: json['name'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      birthDate: Client._dateFromJson(json['birthDate'] as Timestamp),
      creationDate: Client._dateFromJson(json['creationDate'] as Timestamp),
      bloodGroup: json['bloodGroup'] as String?,
      balance: json['balance'] as int? ?? 0,
      isPublic: json['isPublic'] as bool? ?? false,
      status: $enumDecodeNullable(_$ClientStatusEnumMap, json['status']) ??
          ClientStatus.available,
      phoneNumber: json['phoneNumber'] as String?,
      unbanDate: Client._unbanDateFromJson(json['unbanDate']),
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'name': instance.name,
      'gender': _$GenderEnumMap[instance.gender],
      'bloodGroup': instance.bloodGroup,
      'province': instance.province,
      'city': instance.city,
      'phoneNumber': instance.phoneNumber,
      'status': _$ClientStatusEnumMap[instance.status],
      'balance': instance.balance,
      'isPublic': instance.isPublic,
      'birthDate': Client._dateToJson(instance.birthDate),
      'unbanDate': Client._unbanDateToJson(instance.unbanDate),
      'creationDate': Client._dateToJson(instance.creationDate),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$ClientStatusEnumMap = {
  ClientStatus.available: 'available',
  ClientStatus.banned: 'banned',
};
