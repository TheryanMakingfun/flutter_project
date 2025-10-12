import 'package:flutter/material.dart';
import 'package:flutter_5a/core/services/chat_service.dart';
import 'package:flutter_5a/views/report.dart';


class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<Map<String, dynamic>> _messages = [
    {
      "sender": "bot",
      "text": "Selamat datang di SABDA!\nApakah ada yang ingin anda bicarakan?"
    }
  ];
  bool _isTyping = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
      _isTyping = true;
    });

    final selfHarmKeywords = [
      'ingin melukai diri', 'ingin menyakiti diri', 'bunuh diri', 'self harm', 'ingin mengakhiri hidup', 'mengakhiri hidupku', 'mati saja', 'ingin mati'
    ];
    final isSelfHarm = selfHarmKeywords.any(
      (keyword) => userMessage.toLowerCase().contains(keyword),
    );

    if (isSelfHarm) {
      _messages.add({"sender": "warning", "text": ""});
      _isTyping = false;
      setState(() {});
      return;
    }

    try {
      final botMessage = await _chatService.sendMessage(userMessage);
      setState(() {
        _messages.add({"sender": "bot", "text": botMessage});
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "sender": "bot",
          "text": "Terjadi kesalahan. Coba lagi nanti ya."
        });
        _isTyping = false;
      });
    }
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['sender'] == 'user';
    final isBot = message['sender'] == 'bot';
    final isWarning = message['sender'] == 'warning';

    if (isWarning) {
      return _buildWarningMessage();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot)
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/img/admin.jpg'),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.only(
                top: 5,
                left: isUser ? 50 : 0,
                right: isUser ? 0 : 50,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.white
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: isUser ? const Radius.circular(20) : Radius.zero,
                  topRight: isUser ? Radius.zero : const Radius.circular(20),
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                message['text'],
                style: const TextStyle(fontSize: 16, color: Color(0xFF5A5A5A)),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildWarningMessage() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 201, 201),
        border: Border.all(color: const Color.fromARGB(255, 14, 141, 156)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Warning! Terdeteksi Self-harm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 23, 23),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keselamatanmu penting. Kalau ada pikiran untuk menyakiti diri, segera cari bantuan. Tekan \'Laporkan\' untuk melaporkan kejadian ini. Atau coba aksi dibawah untuk merasa lebih baik.',
            style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255,201, 230, 246),
                    side: const BorderSide(color: Color.fromARGB(255, 14, 141, 156), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Bicara dengan Konselor',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Report()),
                    );},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255,201, 230, 246),
                    side: const BorderSide(color: Color.fromARGB(255, 14, 141, 156), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Laporkan',
                    style: TextStyle(color: Color.fromARGB(255, 255, 43, 43), fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255,201, 230, 246),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SABDA',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 14, 141, 156)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(top: 10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[_messages.length - 1 - index]);
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('SABDA is typing...'),
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
  return Container(
    color: Colors.transparent,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: TextField(
      controller: _controller,
      onSubmitted: (value) => _sendMessage(),
      decoration: InputDecoration(
        hintText: 'Saya dapat menanyakan apa saja di aplikasi ini?',
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF5A5A5A)),
        filled: true,
        fillColor: const Color(0xFFE3F4FB), // Warna latar belakang field
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 14, 141, 156), // Warna border
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 14, 141, 156), // Warna border saat tidak fokus
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 14, 141, 156), // Warna border saat fokus
            width: 2,
          ),
        ),
        suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            width: 60, // Lebar 
            height: 40, // Tinggi
            decoration: BoxDecoration( 
              color: const Color.fromARGB(255, 14, 141, 156),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
        ),
      ),
    ),
  );
}
}