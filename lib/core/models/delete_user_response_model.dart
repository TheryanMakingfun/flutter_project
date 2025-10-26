/*

import 'dart:convert';

DeleteUserResponseModel deleteUserResponseModelFromJson(String str) =>
    DeleteUserResponseModel.fromJson(json.decode(str));

class DeleteUserResponseModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int age;
  final String gender;
  final String image;
  final String deletedOn;
  final bool isDeleted;

  DeleteUserResponseModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required this.gender,
    required this.image,
    required this.deletedOn,
    required this.isDeleted,
  });

  factory DeleteUserResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteUserResponseModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        age: json["age"],
        gender: json["gender"],
        image: json["image"],
        deletedOn: json["deletedOn"],
        isDeleted: json["isDeleted"],
      );
}
*/