import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();
  String? _selectedBullyingType;
  DateTime? _selectedDate;

  final List<String> _bullyingTypes = ['Verbal', 'Fisik', 'Sosial'];

  @override
  void dispose() {
    _locationController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (!mounted) return;
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (!mounted) return;
    if (picked != null) {
      final now = _selectedDate ?? DateTime.now();
      setState(() {
        _selectedDate = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.red[100],
      appBar: AppBar(
        backgroundColor:  Colors.red[100],
        title: const Text(
          'Laporkan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        //centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Informasi
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 230, 230),
                  border: Border.all(color: Colors.red.shade400),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, size: 45, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Ceritakan kejadian yang menimpa anda!\nInformasi Anda bersifat rahasia dan hanya digunakan untuk penanganan kasus.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Jenis Perundungan Dropdown
              Text(
                'Jenis Perundungan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 230, 230),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedBullyingType,
                    hint: Text(
                      'Pilih jenis perundungan',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBullyingType = newValue;
                      });
                    },
                    items: _bullyingTypes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kapan Kejadian Terjadi? Date/Time Picker
              Text(
                'Kapan Kejadian Terjadi?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  await _selectDate();
                  if (!mounted) return;
                  if (_selectedDate != null) {
                    await _selectTime();
                    if (!mounted) return;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 230, 230),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Pilih waktu perundungan'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedDate!.hour}:${_selectedDate!.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _selectedDate == null
                              ? Colors.grey.shade600
                              : Colors.black,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Di Mana Kejadian Terjadi? TextField
              Text(
                'Di Mana Kejadian Terjadi?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Kantin, Kelas 8A...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Ceritakan Kejadian TextField
              Text(
                'Ceritakan Kejadian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _storyController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Jelaskan detail kejadian yang terjadi...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Darurat
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 24.0),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Darurat',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Butuh bantuan segera',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 55),
            ],
          ),
        ),
      ),
    );
  }
}