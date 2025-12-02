import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/auth/view/splash_screen.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:yegna_eqif_new/features/settings/view/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with user's profile picture
            ),
            const SizedBox(height: 16),
            Text(
              authViewModel.user?.displayName ?? 'N/A', // Replace with user's name
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              authViewModel.user?.email ?? 'N/A', // Replace with user's email
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                context.read<AuthViewModel>().logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SplashScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
