import 'package:blood_bank_system/helpers/enums.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

String enumToString(dynamic theEnum) {
  return theEnum.toString().split('.')[1];
}

List<String> genderListToStringList(List<dynamic> enumList) {
  return enumList.map((theEnum) => _genderEnumMap[theEnum]!).toList();
}

List<String> diseaseListToStringList(List<dynamic> enumList) {
  return enumList.map((theEnum) => _diseaseEnumMap[theEnum]!).toList();
}

String dateTimeToString(DateTime dateTime) {
  return DateFormat.yMMMd().format(dateTime).toString();
}

RejectionCause diseaseToRejectionCause(Disease disease){
  return $enumDecode(_rejectionCauseEnumMap, enumToString(disease));
}

const _genderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};

const _diseaseEnumMap = {
  Disease.noDisease: 'noDisease',
  Disease.hIV: 'hIV',
  Disease.hBV: 'hBV',
  Disease.hCV: 'hCV',
  Disease.syphilis: 'syphilis',
};

const _rejectionCauseEnumMap = {
  RejectionCause.hbDeficiency: 'hbDeficiency',
  RejectionCause.hIV: 'hIV',
  RejectionCause.hBV: 'hBV',
  RejectionCause.hCV: 'hCV',
  RejectionCause.syphilis: 'syphilis',
  RejectionCause.other: 'other',
};