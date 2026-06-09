import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/auth_shell.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';
import 'verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(email: result['email']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Login failed")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      icon: Icons.lock_rounded,
      title: "Welcome back",
      subtitle: "Sign in to continue to your secure dashboard.",
      children: [
        TextField(
          controller: usernameController,
          textInputAction: TextInputAction.next,
          decoration: authInputDecoration(
            label: "Username",
            icon: Icons.person_outline,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!isLoading) login();
          },
          decoration: authInputDecoration(
            label: "Password",
            icon: Icons.key_outlined,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
              );
            },
            child: const Text("Forgot password?"),
          ),
        ),
        const SizedBox(height: 6),
        AuthPrimaryButton(
          label: "Log in",
          icon: Icons.login_rounded,
          isLoading: isLoading,
          onPressed: login,
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("New here?", style: TextStyle(color: Color(0xFF64748B))),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
            child: const Text("Create account"),
          ),
        ],
      ),
    );
  }
}
