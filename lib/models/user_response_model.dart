// To parse this JSON data, do
//
//     final UserResponse = UserResponseFromJson(jsonString);

import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
    List<User> users;
    int total;
    int skip;
    int limit;

    UserResponse({
        required this.users,
        required this.total,
        required this.skip,
        required this.limit,
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
    };
}

class User {
    int id;
    String firstName;
    String lastName;
    String maidenName;
    int age;
    String gender;
    String email;
    String username;
    String image;

    User({
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.maidenName,
        required this.age,
        required this.gender,
        required this.email,
        required this.username,
        required this.image,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        maidenName: json["maidenName"],
        age: json["age"],
        gender: json["gender"],
        email: json["email"],
        username: json["username"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "maidenName": maidenName,
        "age": age,
        "gender": gender,
        "email": email,
        "username": username,
        "image": image,
    };
}
