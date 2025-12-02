import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:yegna_eqif_new/features/dashboard/view/dashboard_container_screen.dart';
import 'package:yegna_eqif_new/features/auth/view/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return authViewModel.user != null
        ? const DashboardContainerScreen()
        : const SignIn();
  }
}
