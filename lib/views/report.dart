import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_5a/core/providers/report_provider.dart';
import 'package:flutter_5a/views/report_success_page.dart';

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

  final List<String> _bullyingTypes = [
    'Verbal',
    'Fisik',
    'Sosial',
    'Cyberbullying',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      Provider.of<ReportProvider>(context, listen: false).loadReportData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportProvider>(context);
    final isLoading = provider.isLoading;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255,201, 230, 246),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 230, 246),
        elevation: 0,
        title: const Text(
          "Laporkan",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Color.fromARGB(255, 14, 141, 156)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9E9E9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF0B3B3)),
              ),
              padding: const EdgeInsets.all(12),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.clipboardList, size: 35,
                      color: Colors.black),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Ceritakan kejadian yang menimpa anda! Informasi Anda bersifat rahasia dan hanya digunakan untuk penanganan kasus.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Container putih besar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: isLoading ? _buildShimmerPlaceholder() : _buildForm(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 👉 Form asli dari kode kamu
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Jenis Perundungan"),
        const SizedBox(height: 8),
        _buildDropdownField(),
        const SizedBox(height: 16),

        _buildLabel("Kapan kejadian terjadi?"),
        const SizedBox(height: 8),
        GestureDetector(onTap: _selectDate, child: _buildDateField()),
        const SizedBox(height: 16),

        _buildLabel("Dimana kejadian terjadi?"),
        const SizedBox(height: 8),
        _buildTextField(_locationController, "Kantin, Kelas 8B, ..."),
        const SizedBox(height: 16),

        _buildLabel("Ceritakan Kejadian"),
        const SizedBox(height: 8),
        _buildTextField(_storyController, "Ceritakan detail kejadian...", 5),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportSuccessPage()),
              );},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 14, 141, 156),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              "LAPORKAN",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 👉 Shimmer Placeholder
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 14, color: Colors.grey),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: index == 3 ? 100 : 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // 🔹 Helper functions
  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      );

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: const Color.fromARGB(255, 14, 141, 156), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBullyingType,
          hint: const Text("Pilih Jenis Perundungan"),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onChanged: (value) => setState(() => _selectedBullyingType = value),
          items: _bullyingTypes
              .map((type) =>
                  DropdownMenuItem<String>(value: type, child: Text(type)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: const Color.fromARGB(255, 14, 141, 156), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedDate == null
                ? "dd/mm/yyyy"
                : DateFormat('dd/MM/yyyy').format(_selectedDate!),
            style: TextStyle(
              color:
                  _selectedDate == null ? Colors.grey.shade600 : Colors.black87,
              fontSize: 14,
            ),
          ),
          const Icon(Icons.calendar_today_rounded,
              size: 20, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String hint,
      [int maxLines = 1]) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 14, 141, 156), width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 14, 141, 156), width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }
}