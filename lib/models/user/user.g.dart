// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userName: json['userName'] as String,
      roles: User._rolesFromJson(json['roles'] as Map<String, dynamic>),
      creationDate: User._dateFromJson(json['creationDate'] as Timestamp),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userName': instance.userName,
      'roles': User._rolesToJson(instance.roles),
      'creationDate': instance.creationDate?.toIso8601String(),
    };
