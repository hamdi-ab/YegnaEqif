import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/auth/view/splash_screen.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:yegna_eqif_new/features/bank_cards/viewmodel/bank_card_viewmodel.dart';
import 'package:yegna_eqif_new/features/budget/viewmodel/budget_viewmodel.dart';
import 'package:yegna_eqif_new/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:yegna_eqif_new/features/reports/viewmodel/report_viewmodel.dart';
import 'package:yegna_eqif_new/features/settings/viewmodel/settings_viewmodel.dart';
import 'package:yegna_eqif_new/features/transactions/viewmodel/transaction_viewmodel.dart';
import 'package:yegna_eqif_new/features/category/viewmodel/category_viewmodel.dart';
import 'package:yegna_eqif_new/features/debt/viewmodel/debt_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => BudgetViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
        ChangeNotifierProvider(create: (_) => BankCardViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ReportViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => DebtViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: settingsViewModel.userSettings?.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}