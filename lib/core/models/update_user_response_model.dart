// To parse this JSON data, do
//
//     final UpdateUserResponseModel = UpdateUserResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateUserResponseModel updateUserResponseModelFromJson(String str) => UpdateUserResponseModel.fromJson(json.decode(str));

String updateUserResponseModelToJson(UpdateUserResponseModel data) => json.encode(data.toJson());

class UpdateUserResponseModel {
    int id;
    String firstName;
    String lastName;
    String email;
    int age;
    String gender;
    String image;
    DateTime updatedAt;

    UpdateUserResponseModel({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.age,
        required this.gender,
        required this.image,
        required this.updatedAt,
    });

    factory UpdateUserResponseModel.fromJson(Map<String, dynamic> json) => UpdateUserResponseModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        age: json["age"],
        gender: json["gender"],
        image: json["image"],
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "age": age,
        "gender": gender,
        "image": image,
        "updatedAt": updatedAt.toIso8601String(),
    };
}
