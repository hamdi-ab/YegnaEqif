import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/features/reports/model/report_model.dart';
import 'package:yegna_eqif_new/features/reports/service/report_service.dart';

class ReportViewModel extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  ReportModel? _reportModel;
  ReportModel? get reportModel => _reportModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ReportViewModel() {
    loadReportData();
  }

  Future<void> loadReportData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reportModel = await _reportService.getReportData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
