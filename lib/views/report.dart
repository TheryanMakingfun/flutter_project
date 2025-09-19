// lib/views/report_page.dart
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _involvedController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUrgency;
  String _selectedDateText = 'Pilih Tanggal';
  String _selectedTimeText = 'Pilih Waktu';

  bool _agreeToPrivacy = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan Anda berhasil dikirim!')),
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    _involvedController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 208, 210),
      appBar: AppBar(
        title: const Text(
          'Laporkan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. Jenis Laporan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                  initialValue: _selectedCategory,
                  hint: const Text('Pilih kategori laporan'),
                  items: ['Bullying fisik', 'Bullying verbal', 'Cyberbullying', 'Pelecehan'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildFormSection(
                  '2. Lokasi Kejadian',
                  _buildTextField('Misal: sekolah, kampus, media sosial...', controller: _locationController),
                ),
                _buildFormSection(
                  '3. Tanggal & Waktu',
                  Row(
                    children: [
                      Expanded(
                        child: _buildClickableField(
                          _selectedDateText,
                          Icons.calendar_today,
                          () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                _selectedDateText = "${date.day}/${date.month}/${date.year}";
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildClickableField(
                          _selectedTimeText,
                          Icons.access_time,
                          () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                _selectedTimeText = "${time.hour}:${time.minute}";
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFormSection(
                  '4. Deskripsi Kejadian',
                  _buildTextField(
                    'Ceritakan apa yang terjadi...',
                    maxLines: 5,
                    controller: _descriptionController,
                  ),
                ),
                _buildFormSection(
                  '5. Pihak Terlibat',
                  _buildTextField('Nama pelaku/korban (boleh anonim)', controller: _involvedController),
                ),
                _buildFormSection(
                  '6. Bukti Pendukung',
                  _buildClickableField('Upload foto, screenshot, rekaman suara', Icons.upload, () {}),
                ),
                _buildFormSection(
                  '7. Kontak Pelapor',
                  _buildTextField('Email/nomor yang bisa dihubungi', controller: _contactController),
                ),
                const Text('8. Tingkat Urgensi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                  initialValue: _selectedUrgency,
                  hint: const Text('Pilih tingkat urgensi'),
                  items: ['Butuh bantuan segera', 'Perlu tindak lanjut biasa', 'Hanya untuk catatan'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedUrgency = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToPrivacy,
                      onChanged: (value) {
                        setState(() {
                          _agreeToPrivacy = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text('Saya setuju data saya disimpan sesuai kebijakan privasi', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'LAPORKAN',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField(String hint, {TextEditingController? controller, int? maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  // Perbaikan di fungsi ini
  Widget _buildClickableField(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded( // Tambahkan Expanded di sini
              child: Text(text, style: const TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}