import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final logger = Logger();
  final String _apiKey = dotenv.env['OPENROUTER_API_KEY']!;
  final String _baseUrl = "https://openrouter.ai/api/v1/chat/completions";

  /// 🔹 Kirim pesan ke Chatbot (OpenRouter API)
  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "https://openrouter.ai",
          "X-Title": "SABDA Chatbot",
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo", //atau pakai> openai/gpt-3.5-turbo
          "messages": [
            {
              "role": "system",
              "content":
                  "Kamu adalah chatbot empatik bernama SABDA yang menenangkan pengguna yang sedang sedih, cemas, atau mengalami bullying. Jawablah dengan lembut dan penuh empati."
            },
            {"role": "user", "content": userMessage}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data["choices"][0]["message"]["content"];
        return message;
      } else {
        logger.e("Error: ${response.statusCode} - ${response.body}");
        return "Maaf, terjadi kesalahan. Coba lagi nanti ya.";
      }
    } catch (e) {
      logger.w("Exception: $e");
      return "Terjadi kesalahan koneksi. Pastikan internetmu stabil.";
    }
  }

  /// 🔹 Fungsi pengecekan koneksi chatbot (dipanggil sebelum masuk halaman Chatbot)
  Future<bool> pingChatbot() async {
    try {
      // simulasi delay cek koneksi
      await Future.delayed(const Duration(seconds: 3));

      // kalau mau beneran test API, bisa ubah jadi request ringan seperti ini:
      // final res = await http.get(Uri.parse("https://openrouter.ai/api/v1/models"));
      // return res.statusCode == 200;

      return true; // ubah ke false buat tes error
    } catch (e) {
      logger.e("Ping error: $e");
      return false;
    }
  }
}
