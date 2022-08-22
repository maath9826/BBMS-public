// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bag _$BagFromJson(Map<String, dynamic> json) => Bag(
      donorFormId: json['donorFormId'] as String,
      clientName: json['clientName'] as String,
      clientBirthDate: Bag._dateFromJson(json['clientBirthDate'] as Timestamp),
      stage: $enumDecodeNullable(_$BagStageEnumMap, json['stage']) ??
          BagStage.temporaryStorage,
      status: $enumDecodeNullable(_$BagStatusEnumMap, json['status']) ??
          BagStatus.pending,
      bloodGroup: json['bloodGroup'] as String,
      creationDate: Bag._dateFromJson(json['creationDate'] as Timestamp),
    );

Map<String, dynamic> _$BagToJson(Bag instance) => <String, dynamic>{
      'donorFormId': instance.donorFormId,
      'stage': _$BagStageEnumMap[instance.stage],
      'status': _$BagStatusEnumMap[instance.status],
      'bloodGroup': instance.bloodGroup,
      'clientName': instance.clientName,
      'clientBirthDate': Bag._dateToJson(instance.clientBirthDate),
      'creationDate': Bag._dateToJson(instance.creationDate),
    };

const _$BagStageEnumMap = {
  BagStage.temporaryStorage: 'temporaryStorage',
  BagStage.storage: 'storage',
  BagStage.disposed: 'disposed',
};

const _$BagStatusEnumMap = {
  BagStatus.pending: 'pending',
  BagStatus.accepted: 'accepted',
  BagStatus.rejected: 'rejected',
};
