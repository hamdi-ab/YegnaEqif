import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/settings/viewmodel/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Update Personal Information'),
            onTap: () {
              // Navigate to update personal information page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Manage Notifications'),
            onTap: () {
              // Navigate to manage notifications page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Change Theme'),
            trailing: Switch(
              value: settingsViewModel.userSettings?.themeMode == ThemeMode.dark,
              onChanged: (value) {
                final newThemeMode = value ? ThemeMode.dark : ThemeMode.light;
                settingsViewModel.setThemeMode(newThemeMode);
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy Settings'),
            onTap: () {
              // Navigate to privacy settings page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {
              // Navigate to help & support page
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}