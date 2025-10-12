// To parse this JSON data, do
//
//     final RegisterResponseModel = RegisterResponseModelFromJson(jsonString);

import 'dart:convert';

RegisterResponseModel registerResponseModelFromJson(String str) => RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) => json.encode(data.toJson());

class RegisterResponseModel {
    int id;
    String firstName;
    String lastName;
    int age;
    String email;
    String username;
    String password;

    RegisterResponseModel({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.age,
        required this.email,
        required this.username,
        required this.password,
    });

    factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => RegisterResponseModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        age: json["age"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "age": age,
        "email": email,
        "username": username,
        "password": password,
    };
}
