import 'package:mockito/annotations.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:yegna_eqif_new/features/transactions/viewmodel/transaction_viewmodel.dart';
import 'package:yegna_eqif_new/features/budget/viewmodel/budget_viewmodel.dart';
import 'package:yegna_eqif_new/features/dashboard/viewmodel/dashboard_viewmodel.dart';

@GenerateMocks([
  AuthViewModel,
  TransactionViewModel,
  BudgetViewModel,
  DashboardViewModel,
])
void main() {}
