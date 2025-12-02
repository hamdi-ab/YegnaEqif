import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/features/dashboard/model/dashboard_model.dart';
import 'package:yegna_eqif_new/features/dashboard/service/dashboard_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  DashboardModel? _dashboardModel;
  DashboardModel? get dashboardModel => _dashboardModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  DashboardViewModel() {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _dashboardModel = await _dashboardService.getDashboardData();
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
