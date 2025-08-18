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
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Update Personal Information'),
            onTap: () {
              // Navigate to update personal information page
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Manage Notifications'),
            onTap: () {
              // Navigate to manage notifications page
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Change Theme'),
            trailing: Switch(
              value: settingsViewModel.userSettings?.themeMode == ThemeMode.dark,
              onChanged: (value) {
                final newThemeMode = value ? ThemeMode.dark : ThemeMode.light;
                settingsViewModel.setThemeMode(newThemeMode);
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy Settings'),
            onTap: () {
              // Navigate to privacy settings page
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () {
              // Navigate to help & support page
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}