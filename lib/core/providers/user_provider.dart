import 'package:flutter/material.dart';
import 'package:flutter_5a/core/models/user_response_model.dart';
import 'package:flutter_5a/core/models/update_user_request_model.dart';
import 'package:flutter_5a/core/models/update_user_response_model.dart';
import 'package:flutter_5a/core/models/delete_user_response_model.dart';
import 'package:flutter_5a/core/services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  List<User> _users = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<User> get users => _users;
  String? get errorMessage => _errorMessage;

  // 🔹 Ambil semua user
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _users = await _apiService.getListUsers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal memuat data user: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 🔹 Update user
  Future<UpdateUserResponseModel?> updateUser(int userId, UpdateUserRequestModel data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.updateUser(userId, data);
      // update data user di list
      final index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index] = User(
            id: response.id,
            firstName: response.firstName,
            lastName: response.lastName,
            email: response.email,
            maidenName: _users[index].maidenName,
            age: _users[index].age,
            gender: _users[index].gender,
            username: _users[index].username,
            image: _users[index].image,
        );
      }
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Gagal mengupdate user: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Hapus user
  Future<DeleteUserResponseModel?> deleteUser(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.deleteUser(userId);
      _users.removeWhere((user) => user.id == userId);
      _errorMessage = null;
      return response;
    } catch (e) {
      _errorMessage = 'Gagal menghapus user: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
