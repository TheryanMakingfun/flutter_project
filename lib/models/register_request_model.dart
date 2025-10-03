// To parse this JSON data, do
//
//     final RegisterRequestModel = RegisterRequestModelFromJson(jsonString);

import 'dart:convert';

RegisterRequestModel registerRequestModelFromJson(String str) => RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) => json.encode(data.toJson());

class RegisterRequestModel {
    String firstName;
    String lastName;
    int age;
    String email;
    String username;
    String password;

    RegisterRequestModel({
        required this.firstName,
        required this.lastName,
        required this.age,
        required this.email,
        required this.username,
        required this.password,
    });

    factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => RegisterRequestModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        age: json["age"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "age": age,
        "email": email,
        "username": username,
        "password": password,
    };
}
