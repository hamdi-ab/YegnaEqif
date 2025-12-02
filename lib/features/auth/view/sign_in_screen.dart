import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yegna_eqif_new/core/router/route_constants.dart';
import 'package:yegna_eqif_new/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:yegna_eqif_new/core/generic_dialog.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    // Navigation logic handled by GoRouter redirect in AppRouter,
    // but we can also handle explicit success here if needed.
    // Ideally, the AuthViewModel state change triggers the router refresh.
    // For now, we'll keep the manual push for immediate feedback if the router doesn't auto-refresh.
    if (authViewModel.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(RouteConstants.dashboard);
        }
      });
    }

    if (authViewModel.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showErrorDialog(context, authViewModel.error!);
        }
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _signInKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.asset('assets/icon.png'),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: ShadTheme.of(context).textTheme.h2,
                ),
                Text(
                  'Log in to Yegna Eqif',
                  textAlign: TextAlign.center,
                  style: ShadTheme.of(context).textTheme.muted,
                ),
                const SizedBox(height: 32),
                ShadInputFormField(
                  controller: _emailController,
                  label: const Text('Email'),
                  placeholder: const Text('Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!emailValid.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ShadInputFormField(
                  controller: _passwordController,
                  label: const Text('Password'),
                  placeholder: const Text('Enter your password'),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShadButton.ghost(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _obscurePassword
                                ? LucideIcons.eye
                                : LucideIcons.eyeOff,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(_obscurePassword ? 'Show' : 'Hide'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                authViewModel.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ShadButton(
                        width: double.infinity,
                        onPressed: () async {
                          if (_signInKey.currentState!.validate()) {
                            await context.read<AuthViewModel>().signIn(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                          }
                        },
                        child: const Text('Log In'),
                      ),
                const SizedBox(height: 16),
                ShadButton.ghost(
                  width: double.infinity,
                  onPressed: () {
                    context.push(RouteConstants.signUp);
                  },
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
