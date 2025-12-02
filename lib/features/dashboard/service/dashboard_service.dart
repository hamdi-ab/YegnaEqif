import 'package:yegna_eqif_new/features/dashboard/model/dashboard_model.dart';

class DashboardService {
  Future<DashboardModel> getDashboardData() async {
    // In a real app, you would fetch this from other services/ViewModels
    // For now, providing sample data
    return Future.value(
      DashboardModel(
        totalBudget: 5000.0,
        totalSpent: 2500.0,
        bankCardsCount: 2,
        totalBalance: 12500.0, // Sample balance
        totalIncome: 8000.0, // Sample income
      ),
    );
  }
}
