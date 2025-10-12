// To parse this JSON data, do
//
//     final UpdateUserRequestModel = UpdateUserRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateUserRequestModel updateUserRequestModelFromJson(String str) => UpdateUserRequestModel.fromJson(json.decode(str));

String updateUserRequestModelToJson(UpdateUserRequestModel data) => json.encode(data.toJson());

class UpdateUserRequestModel {
    String firstName;
    String lastName;
    String email;

    UpdateUserRequestModel({
        required this.firstName,
        required this.lastName,
        required this.email,
    });

    factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) => UpdateUserRequestModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
    };
}
