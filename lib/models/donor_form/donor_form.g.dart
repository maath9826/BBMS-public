// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonorForm _$DonorFormFromJson(Map<String, dynamic> json) => DonorForm(
      clientId: json['clientId'] as String,
      creationDate: DonorForm._dateFromJson(json['creationDate'] as Timestamp),
      code: json['code'] as String,
      examiningForm: DonorForm._examiningFormFromJson(
          json['examiningForm'] as Map<String, dynamic>),
      numberOfStoredBags: json['numberOfStoredBags'] as int? ?? 0,
      numberOfBags: json['numberOfBags'] as int? ?? 0,
      status: $enumDecodeNullable(_$DonorFormStatusEnumMap, json['status']) ??
          DonorFormStatus.pending,
      stage: $enumDecodeNullable(_$DonorFormStageEnumMap, json['stage']) ??
          DonorFormStage.bloodClassificationAndHbLab,
      rejectionCause:
          $enumDecodeNullable(_$RejectionCauseEnumMap, json['rejectionCause']),
      rejectionNote: json['rejectionNote'] as String?,
      hb: (json['hb'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DonorFormToJson(DonorForm instance) => <String, dynamic>{
      'clientId': instance.clientId,
      'rejectionCause': _$RejectionCauseEnumMap[instance.rejectionCause],
      'rejectionNote': instance.rejectionNote,
      'code': instance.code,
      'hb': instance.hb,
      'numberOfStoredBags': instance.numberOfStoredBags,
      'numberOfBags': instance.numberOfBags,
      'status': _$DonorFormStatusEnumMap[instance.status],
      'stage': _$DonorFormStageEnumMap[instance.stage],
      'examiningForm': DonorForm._examiningFormToJson(instance.examiningForm),
      'creationDate': DonorForm._dateToJson(instance.creationDate),
    };

const _$DonorFormStatusEnumMap = {
  DonorFormStatus.accepted: 'accepted',
  DonorFormStatus.rejected: 'rejected',
  DonorFormStatus.pending: 'pending',
};

const _$DonorFormStageEnumMap = {
  DonorFormStage.bloodClassificationAndHbLab: 'bloodClassificationAndHbLab',
  DonorFormStage.examining: 'examining',
  DonorFormStage.bloodDrawing: 'bloodDrawing',
  DonorFormStage.diseasesDetection: 'diseasesDetection',
  DonorFormStage.temporaryStorage: 'temporaryStorage',
  DonorFormStage.finnish: 'finnish',
};

const _$RejectionCauseEnumMap = {
  RejectionCause.hbDeficiency: 'hbDeficiency',
  RejectionCause.hIV: 'hIV',
  RejectionCause.hBV: 'hBV',
  RejectionCause.hCV: 'hCV',
  RejectionCause.syphilis: 'syphilis',
  RejectionCause.other: 'other',
};
