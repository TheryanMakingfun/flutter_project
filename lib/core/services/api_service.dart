import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_5a/core/models/delete_user_response_model.dart';
import 'package:flutter_5a/core/models/login_request_model.dart';
import 'package:flutter_5a/core/models/login_response_model.dart';
import 'package:flutter_5a/core/models/register_request_model.dart';
import 'package:flutter_5a/core/models/register_response_model.dart';
import 'package:flutter_5a/core/models/update_user_request_model.dart';
import 'package:flutter_5a/core/models/update_user_response_model.dart';
import 'package:flutter_5a/core/models/user_response_model.dart';

class ApiService {
  final logger = Logger();
  final Dio _dio = Dio();
  final String _baseUrl = 'https://dummyjson.com';


  Future<List<User>> getListUsers() async {
    try {
      final response = await _dio.get('$_baseUrl/users');
      if (response.statusCode == 200) {
        final userResponse = UserResponse.fromJson(response.data);
        return userResponse.users;
      } else {
        throw Exception('Gagal memuat daftar pengguna');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Register User
  Future<RegisterResponseModel> registerUser(RegisterRequestModel requestModel) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/users/add',
        data: requestModel.toJson(), // kirim body JSON dari model
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      } else {
        throw Exception('Gagal melakukan registrasi');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Login User
  Future<LoginResponseModel> loginUser(LoginRequestModel requestModel) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/auth/login',
        data: jsonEncode(requestModel.toJson()), // <<<<< ini penting
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
        logger.i("Request body: ${requestModel.toJson()}");
        logger.i("Response status: ${response.statusCode}");
        logger.i("Response data: ${response.data}");
        logger.i("Login request body: ${jsonEncode(requestModel.toJson())}");

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception('Login gagal, periksa username/password');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update User
  Future<UpdateUserResponseModel> updateUser(
      int userId, UpdateUserRequestModel requestModel) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/users/$userId',
        data: requestModel.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UpdateUserResponseModel.fromJson(response.data);
      } else {
        throw Exception('Gagal memperbarui pengguna');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete User
  Future<DeleteUserResponseModel> deleteUser(int userId) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/users/$userId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return DeleteUserResponseModel.fromJson(response.data);
      } else {
        throw Exception('Gagal menghapus pengguna');
      }
    } catch (e) {
      rethrow;
    }
  }
}
