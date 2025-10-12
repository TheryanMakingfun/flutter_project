import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_5a/core/models/login_request_model.dart';
import 'package:flutter_5a/core/models/login_response_model.dart';
import 'package:flutter_5a/core/models/register_request_model.dart';
import 'package:flutter_5a/core/models/register_response_model.dart';
import 'package:flutter_5a/core/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final logger = Logger();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  LoginResponseModel? _loginResponse;
  RegisterResponseModel? _registerResponse;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  LoginResponseModel? get loginResponse => _loginResponse;
  RegisterResponseModel? get registerResponse => _registerResponse;

  // 🔹 LOGIN
  Future<void> login(LoginRequestModel requestModel) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.loginUser(requestModel);
      _loginResponse = response;
      _isLoggedIn = true;
    } catch (e) {
      logger.e('Login error', error: e);
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔹 REGISTER
  Future<void> register(RegisterRequestModel requestModel) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.registerUser(requestModel);
      _registerResponse = response;
    } catch (e) {
      logger.e('Register error', error: e);
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔹 LOGOUT
  void logout() {
    _loginResponse = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
