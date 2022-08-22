import 'package:blood_bank_system/helpers/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../local/detail.dart';

part 'examining_form.g.dart';

@JsonSerializable()
class ExaminingForm {
  final double? weight;
  final double? heartRate;
  final double? bloodPressure;
  final double? temperature;
  final String? doctorName;
  final String? vaccineName;
  final bool isDonatedBefore;
  final bool isRejectedBefore;
  final bool isTookAspirin;
  final bool isInfectedWithViralHepatitis;
  final bool isPersonWithEpilepsy;
  final bool isSufferedOtherDiseases;
  final bool isTookDrugs;
  final bool isHadCuppingOrOthers;
  final bool isVaccinated;
  @JsonKey(fromJson: _donationDateFromJson, toJson: _donationDateToJson)
  final DateTime? donationDate;

  ExaminingForm({
    this.weight,
    this.heartRate,
    this.bloodPressure,
    this.temperature,
    this.doctorName,
    this.vaccineName,
    this.isDonatedBefore = false,
    this.isRejectedBefore = false,
    this.isTookAspirin = false,
    this.isInfectedWithViralHepatitis = false,
    this.isPersonWithEpilepsy = false,
    this.isSufferedOtherDiseases = false,
    this.isTookDrugs = false,
    this.isHadCuppingOrOthers = false,
    this.isVaccinated = false,
    this.donationDate,
  });

  factory ExaminingForm.fromJson(Map<String, dynamic> data) =>
      _$ExaminingFormFromJson(data);

  Map<String, dynamic> toJson() => _$ExaminingFormToJson(this);

  static DateTime? _donationDateFromJson(Timestamp? value) =>
      isAssigned(value) ? value!.toDate() : null;

  static Timestamp? _donationDateToJson(DateTime? value) =>
      isAssigned(value) ? Timestamp.fromDate(value!) : null;

  List<Detail> get details {
    return [
    if(isAssigned(weight)) Detail(value: weight.toString(), key: 'weight'),
    if(isAssigned(heartRate)) Detail(value: heartRate.toString(), key: 'heart rate'),
    if(isAssigned(bloodPressure)) Detail(value: bloodPressure.toString(), key: 'blood pressure'),
    if(isAssigned(temperature)) Detail(value: temperature.toString(), key: 'temperature'),
    if(isAssigned(doctorName)) Detail(value: doctorName!, key: 'doctor name'),
    if(isAssigned(vaccineName)) Detail(value: vaccineName!, key: 'vaccine name'),
    Detail(value: isDonatedBefore.toString(), key: 'Did you donate before?'),
    Detail(value: isRejectedBefore.toString(), key: 'Have your donation been reject before?'),
    Detail(value: isTookAspirin.toString(), key: 'Did you take Aspirin in the past three days?'),
    Detail(value: isInfectedWithViralHepatitis.toString(), key: 'Did you been infected by Viral Hepatitis?'),
    Detail(value: isPersonWithEpilepsy.toString(), key: 'Are you a Person With Epilepsy?'),
    Detail(value: isSufferedOtherDiseases.toString(), key: 'Did you suffer from chronic diseases, blood, Urinary system diseases, chest diseases, heart diseases, blood pressure, diabetes ?'),
    Detail(value: isTookDrugs.toString(), key: "Have you took antibiotics or chronic diseases' drugs?"),
    Detail(value: isHadCuppingOrOthers.toString(), key: 'Have you had a surgery, tattoo, cupping, teeth extractions'),
    Detail(value: isVaccinated.toString(), key: 'Have you been vaccinated in the past two weeks?'),
    ];
  }
}
