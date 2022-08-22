// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examining_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExaminingForm _$ExaminingFormFromJson(Map<String, dynamic> json) =>
    ExaminingForm(
      weight: (json['weight'] as num?)?.toDouble(),
      heartRate: (json['heartRate'] as num?)?.toDouble(),
      bloodPressure: (json['bloodPressure'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      doctorName: json['doctorName'] as String?,
      vaccineName: json['vaccineName'] as String?,
      isDonatedBefore: json['isDonatedBefore'] as bool? ?? false,
      isRejectedBefore: json['isRejectedBefore'] as bool? ?? false,
      isTookAspirin: json['isTookAspirin'] as bool? ?? false,
      isInfectedWithViralHepatitis:
          json['isInfectedWithViralHepatitis'] as bool? ?? false,
      isPersonWithEpilepsy: json['isPersonWithEpilepsy'] as bool? ?? false,
      isSufferedOtherDiseases:
          json['isSufferedOtherDiseases'] as bool? ?? false,
      isTookDrugs: json['isTookDrugs'] as bool? ?? false,
      isHadCuppingOrOthers: json['isHadCuppingOrOthers'] as bool? ?? false,
      isVaccinated: json['isVaccinated'] as bool? ?? false,
      donationDate: ExaminingForm._donationDateFromJson(
          json['donationDate'] as Timestamp?),
    );

Map<String, dynamic> _$ExaminingFormToJson(ExaminingForm instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'heartRate': instance.heartRate,
      'bloodPressure': instance.bloodPressure,
      'temperature': instance.temperature,
      'doctorName': instance.doctorName,
      'vaccineName': instance.vaccineName,
      'isDonatedBefore': instance.isDonatedBefore,
      'isRejectedBefore': instance.isRejectedBefore,
      'isTookAspirin': instance.isTookAspirin,
      'isInfectedWithViralHepatitis': instance.isInfectedWithViralHepatitis,
      'isPersonWithEpilepsy': instance.isPersonWithEpilepsy,
      'isSufferedOtherDiseases': instance.isSufferedOtherDiseases,
      'isTookDrugs': instance.isTookDrugs,
      'isHadCuppingOrOthers': instance.isHadCuppingOrOthers,
      'isVaccinated': instance.isVaccinated,
      'donationDate': ExaminingForm._donationDateToJson(instance.donationDate),
    };
