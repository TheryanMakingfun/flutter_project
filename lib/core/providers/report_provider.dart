import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_5a/core/models/report_model.dart';

class ReportProvider extends ChangeNotifier {
  bool _isLoading = true;
  ReportModel? _report;

  bool get isLoading => _isLoading;
  ReportModel? get report => _report;

  Future<void> loadReportData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // simulasi shimmer loading

    _report = ReportModel();
    _isLoading = false;
    notifyListeners();
  }
}