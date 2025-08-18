
import 'package:yegna_eqif_new/features/dashboard/model/dashboard_model.dart';

class DashboardService {
  Future<DashboardModel> getDashboardData() async {
    // In a real app, you would fetch this from other services
    return Future.value(
      DashboardModel(
        totalBudget: 5000.0,
        totalSpent: 2500.0,
        bankCardsCount: 2,
      ),
    );
  }
}
