import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanInformation extends StatefulWidget {
  const ScanInformation({super.key});

  @override
  State<ScanInformation> createState() => _ScanInformationState();
}

class _ScanInformationState extends State<ScanInformation> {
  String _scanResult = "Belum ada hasil scan";
  bool _isScanned = false; // ⬅️ Agar tidak spam
  final MobileScannerController _cameraController = MobileScannerController();

  bool _isURL(String text) {
    final urlPattern =
        r'^(https?:\/\/)?([\w\-])+(\.[\w\-]+)+(:\d+)?(\/\S*)?$';
    return RegExp(urlPattern, caseSensitive: false).hasMatch(text);
  }

  Future<void> _openURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith("http") ? url : "https://$url");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuka link")),
      );
    }
  }

  // Reset scanner dan mulai ulang
  void _resetScanner() {
    setState(() {
      _scanResult = "Belum ada hasil scan";
      _isScanned = false;
    });
    _cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246),

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 230, 246),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Scan QR Code",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          )),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 14, 141, 156)),
      ),

      body: Column(
        children: [
          // AREA KAMERA
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  controller: _cameraController,
                  onDetect: (capture) {
                    if (_isScanned) return; // ⬅️ Blokir scan berikutnya

                    final List<Barcode> barcodes = capture.barcodes;

                    for (final barcode in barcodes) {
                      final result = barcode.rawValue;
                      if (result != null) {
                        setState(() {
                          _scanResult = result;
                          _isScanned = true; // ⬅️ Tandai sudah scan
                        });

                        _cameraController.stop(); // ⬅️ Stop kamera setelah berhasil
                      }
                    }
                  },
                ),
              ),
            ),
          ),

          // AREA HASIL SCAN
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hasil Scan:",
                      style: TextStyle(fontSize: 18, color: Colors.black54)),
                  const SizedBox(height: 10),

                  // Teks hasil scan
                  _isURL(_scanResult)
                      ? GestureDetector(
                          onTap: () => _openURL(_scanResult),
                          child: Text(
                            _scanResult,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : Text(
                          _scanResult,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                  const SizedBox(height: 20),

                  // Tombol Scan Ulang jika sudah berhasil
                  if (_isScanned)
                    ElevatedButton(
                      onPressed: _resetScanner,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 14, 141, 156),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Scan Ulang",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
