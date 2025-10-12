import 'package:flutter/material.dart';
import 'package:flutter_5a/core/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Simulasi inisialisasi atau pengecekan koneksi ke Chatbot
  Future<bool> initChat() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Coba panggil API sederhana untuk memastikan chatbot siap
      final success = await _chatService.pingChatbot();

      if (!success) {
        _errorMessage = 'Gagal terhubung ke server chatbot.';
        _setLoading(false);
        return false;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}