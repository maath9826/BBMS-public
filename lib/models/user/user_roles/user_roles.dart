import 'package:json_annotation/json_annotation.dart';

part 'user_roles.g.dart';

@JsonSerializable()
class UserRoles{
  bool isAdmin;
  bool isConsultant;
  bool isHbLabEmployee;
  bool isBloodClassificationEmployee;
  bool isExaminer;
  bool isPhlebotomist;
  bool isDiseasesDetectionEmployee;
  bool isTemporaryStorageEmployee;
  bool isStorageEmployee;

  UserRoles({
    this.isConsultant = true,
    this.isStorageEmployee = false,
    this.isAdmin = false,
    this.isExaminer = false,
    this.isHbLabEmployee = false,
    this.isPhlebotomist = false,
    this.isBloodClassificationEmployee = false,
    this.isDiseasesDetectionEmployee = false,
    this.isTemporaryStorageEmployee = false,
  });

  factory UserRoles.fromJson(Map<String,dynamic> json) => _$UserRolesFromJson(json);
  Map<String,dynamic> toJson() => _$UserRolesToJson(this);
}