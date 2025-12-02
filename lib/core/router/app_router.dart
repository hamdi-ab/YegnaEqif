import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/core/router/route_constants.dart';
import 'package:yegna_eqif_new/core/router/scaffold_with_bottom_nav.dart';
import 'package:yegna_eqif_new/features/auth/view/sign_in_screen.dart';
import 'package:yegna_eqif_new/features/auth/view/sign_up_screen.dart';
import 'package:yegna_eqif_new/features/auth/view/splash_screen.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:yegna_eqif_new/features/bank_cards/view/add_bank_card_screen.dart';
import 'package:yegna_eqif_new/features/budget/view/add_budget_screen.dart';
import 'package:yegna_eqif_new/features/budget/view/budget_screen.dart';
import 'package:yegna_eqif_new/features/dashboard/view/dashboard_screen.dart';
import 'package:yegna_eqif_new/features/debt/view/add_debt_transaction_screen.dart';
import 'package:yegna_eqif_new/features/debt/view/debt_tracker_screen.dart';
import 'package:yegna_eqif_new/features/reports/view/reports_screen.dart';
import 'package:yegna_eqif_new/features/settings/view/profile_screen.dart';
import 'package:yegna_eqif_new/features/settings/view/settings_screen.dart';
import 'package:yegna_eqif_new/features/transactions/view/add_transaction_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RouteConstants.splash,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final isAuthenticated = authViewModel.user != null;
        final isOnAuthPage = state.uri.path == RouteConstants.signIn ||
            state.uri.path == RouteConstants.signUp ||
            state.uri.path == RouteConstants.splash;

        // If not authenticated and trying to access app, redirect to sign in
        if (!isAuthenticated && !isOnAuthPage) {
          return RouteConstants.signIn;
        }

        // If authenticated and on auth page, redirect to dashboard
        if (isAuthenticated &&
            isOnAuthPage &&
            state.uri.path != RouteConstants.splash) {
          return RouteConstants.dashboard;
        }

        return null; // No redirect needed
      },
      routes: [
        // Auth Routes
        GoRoute(
          path: RouteConstants.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: RouteConstants.signIn,
          builder: (context, state) => const SignIn(),
        ),
        GoRoute(
          path: RouteConstants.signUp,
          builder: (context, state) => const SignUp(),
        ),

        // App Shell with Bottom Navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return ScaffoldWithBottomNav(child: child);
          },
          routes: [
            GoRoute(
              path: RouteConstants.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: RouteConstants.reports,
              builder: (context, state) => ReportsScreen(),
            ),
            GoRoute(
              path: RouteConstants.budget,
              builder: (context, state) =>
                  BudgetScreen(scrollToMonthlyBudget: false),
            ),
            GoRoute(
              path: RouteConstants.debt,
              builder: (context, state) => DebtTrackerPage(),
            ),
          ],
        ),

        // Modal Routes (outside shell)
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RouteConstants.addTransaction,
          builder: (context, state) => AddTransactionScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RouteConstants.addBankCard,
          builder: (context, state) => const AddBankCardScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RouteConstants.addBudget,
          builder: (context, state) => AddBudgetPage(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RouteConstants.addDebt,
          builder: (context, state) => AddDebtTransactionScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RouteConstants.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RouteConstants.settings,
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Page not found: ${state.uri.path}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(RouteConstants.dashboard),
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Prevent instantiation
  AppRouter._();
}
