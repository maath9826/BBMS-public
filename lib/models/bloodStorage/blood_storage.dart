import 'package:json_annotation/json_annotation.dart';

part 'blood_storage.g.dart';

@JsonSerializable()
class BloodStorage {
  final int aPos;
  final int aNeg;
  final int bPos;
  final int bNeg;
  final int abPos;
  final int abNeg;
  final int oPos;
  final int oNeg;

  BloodStorage({
    required this.aPos,
    required this.aNeg,
    required this.bPos,
    required this.bNeg,
    required this.abPos,
    required this.abNeg,
    required this.oPos,
    required this.oNeg,
  });

  factory BloodStorage.fromJson(Map<String, dynamic> data) => _$BloodStorageFromJson(data);

  Map<String, dynamic> toJson() => _$BloodStorageToJson(this);
}

const Map<String, String> bloodGroupVarToStringMap = {
  'bPos': 'B+',
  'abPos': 'AB+',
  'aPos': 'A+',
  'oPos': 'O+',
  'oNeg': 'O-',
  'aNeg': 'A-',
  'abNeg': 'AB-',
  'bNeg': 'B-',
};

const Map<String, String> stringToBloodGroupVarMap = {
  'B+': 'bPos',
  'AB+': 'abPos',
  'A+': 'aPos',
  'O+': 'oPos',
  'O-': 'oNeg',
  'A-': 'aNeg',
  'AB-': 'abNeg',
  'B-': 'bNeg',
};
