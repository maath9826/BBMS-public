import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user_roles/user_roles.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  String userName;
  @JsonKey(fromJson: _rolesFromJson, toJson: _rolesToJson)
  UserRoles roles;
  @JsonKey(fromJson: _dateFromJson)
  final DateTime? creationDate;

  User({
    required this.userName,
    required this.roles,
    this.creationDate,
  });

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  static DateTime _dateFromJson(Timestamp value) => value.toDate();

  static UserRoles _rolesFromJson(Map<String,dynamic> json) => UserRoles.fromJson(json);
  static Map<String,dynamic> _rolesToJson(UserRoles roles) => roles.toJson();
}