// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_roles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRoles _$UserRolesFromJson(Map<String, dynamic> json) => UserRoles(
      isConsultant: json['isConsultant'] as bool? ?? true,
      isStorageEmployee: json['isStorageEmployee'] as bool? ?? false,
      isAdmin: json['isAdmin'] as bool? ?? false,
      isExaminer: json['isExaminer'] as bool? ?? false,
      isHbLabEmployee: json['isHbLabEmployee'] as bool? ?? false,
      isPhlebotomist: json['isPhlebotomist'] as bool? ?? false,
      isBloodClassificationEmployee:
          json['isBloodClassificationEmployee'] as bool? ?? false,
      isDiseasesDetectionEmployee:
          json['isDiseasesDetectionEmployee'] as bool? ?? false,
      isTemporaryStorageEmployee:
          json['isTemporaryStorageEmployee'] as bool? ?? false,
    );

Map<String, dynamic> _$UserRolesToJson(UserRoles instance) => <String, dynamic>{
      'isAdmin': instance.isAdmin,
      'isConsultant': instance.isConsultant,
      'isHbLabEmployee': instance.isHbLabEmployee,
      'isBloodClassificationEmployee': instance.isBloodClassificationEmployee,
      'isExaminer': instance.isExaminer,
      'isPhlebotomist': instance.isPhlebotomist,
      'isDiseasesDetectionEmployee': instance.isDiseasesDetectionEmployee,
      'isTemporaryStorageEmployee': instance.isTemporaryStorageEmployee,
      'isStorageEmployee': instance.isStorageEmployee,
    };
