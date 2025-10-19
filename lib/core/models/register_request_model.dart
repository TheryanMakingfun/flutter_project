// To parse this JSON data, do
//
//   final RegisterRequestModel = RegisterRequestModelFromJson(jsonString);

import 'dart:convert';

RegisterRequestModel registerRequestModelFromJson(String str) => RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) => json.encode(data.toJson());

class RegisterRequestModel {
  // Hanya simpan satu nama untuk display name
  String name; 
  String email;
  String password;

  RegisterRequestModel({
    required this.name, // Gabungan dari firstName dan lastName
    required this.email,
    required this.password,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => RegisterRequestModel(
    name: json["name"], 
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
  };
}