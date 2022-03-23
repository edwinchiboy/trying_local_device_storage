import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final String tableDB = 'dbTable';

class DBField {
  static final List<String> values = [
    id,
    userEmail,
    userPassword,
    userDOB,
    userLocation,
    userGender
  ];
  static final String id = '_id';
  static final String userEmail = 'userEmail';
  static final String userPassword = 'userPassword';
  static final String userDOB = 'userDOB';
  static final String userLocation = 'userLocation';
  static final String userGender = 'userGender';
}

class DBModel {
  final int? id;
  final String userEmail;
  final String userPassword;
  final DateTime userDOB;
  final String userLocation;
  final String userGender;
  const DBModel({
    this.id,
    required this.userEmail,
    required this.userPassword,
    required this.userDOB,
    required this.userLocation,
    required this.userGender,
  });
  DBModel copy({
    int? id,
    String? userEmail,
    String? userPassword,
    DateTime? userDOB,
    String? userLocation,
    String? userGender,
  }) =>
      DBModel(
        id: id ?? this.id,
        userEmail: userEmail ?? this.userEmail,
        userPassword: userPassword ?? this.userPassword,
        userDOB: userDOB ?? this.userDOB,
        userLocation: userLocation ?? this.userLocation,
        userGender: userGender ?? this.userGender,
      );
  Map<String, Object?> toJson() => {
        DBField.id: id,
        DBField.userEmail: userEmail,
        DBField.userPassword: userPassword,
        DBField.userDOB: userDOB.toString(),
        DBField.userLocation: userLocation,
        DBField.userGender: userGender,
      };
  static DBModel fromJson(Map<String, Object?> json) => DBModel(
        id: json[DBField.id] as int?,
        userEmail: json[DBField.userEmail] as String,
        userPassword: json[DBField.userPassword] as String,
        userDOB: DateTime.parse(json[DBField.userDOB] as String),
        userLocation: json[DBField.userLocation] as String,
        userGender: json[DBField.userLocation] as String,
      );
}
