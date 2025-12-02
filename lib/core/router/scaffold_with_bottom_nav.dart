import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Scaffold with persistent bottom navigation bar
class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _SpeedDialFAB(),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();

    int getCurrentIndex(String path) {
      if (path.startsWith('/app/dashboard')) return 0;
      if (path.startsWith('/app/reports')) return 1;
      if (path.startsWith('/app/budget')) return 2;
      if (path.startsWith('/app/debt')) return 3;
      return 0;
    }

    return BottomNavigationBar(
      currentIndex: getCurrentIndex(currentPath),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ShadTheme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/app/dashboard');
            break;
          case 1:
            context.go('/app/reports');
            break;
          case 2:
            context.go('/app/budget');
            break;
          case 3:
            context.go('/app/debt');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 28),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Icon(Icons.pie_chart, size: 24),
          ),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Icon(Icons.wallet, size: 24),
          ),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 24),
          label: 'Debt',
        ),
      ],
    );
  }
}

class _SpeedDialFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddMenu(context),
      backgroundColor: ShadTheme.of(context).colorScheme.primary,
      child: const Icon(Icons.add),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.payments, color: Colors.green),
              title: const Text('Add Transaction'),
              onTap: () {
                Navigator.pop(context);
                context.push('/app/add-transaction');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.account_balance_wallet, color: Colors.blue),
              title: const Text('Add Card or Wallet'),
              onTap: () {
                Navigator.pop(context);
                context.push('/app/add-bank-card');
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.orange),
              title: const Text('Add Budget'),
              onTap: () {
                Navigator.pop(context);
                context.push('/app/add-budget');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.red),
              title: const Text('Add Debt'),
              onTap: () {
                Navigator.pop(context);
                context.push('/app/add-debt');
              },
            ),
          ],
        ),
      ),
    );
  }
}
