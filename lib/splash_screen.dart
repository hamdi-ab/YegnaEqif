import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yegna_eqif_new/providers/auth_provider.dart';
import 'package:yegna_eqif_new/screens/home_screen.dart';
import 'package:yegna_eqif_new/screens/sign_in_screen.dart';

class SplashScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          Future.microtask(() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          ));
        } else {
          Future.microtask(() => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
          ));
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
