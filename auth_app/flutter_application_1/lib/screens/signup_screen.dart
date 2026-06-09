import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/auth_shell.dart';
import 'verify_email_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.register(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (result['success'] == true) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                VerifyEmailScreen(email: emailController.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Registration failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      icon: Icons.person_add_alt_1_rounded,
      title: "Create account",
      subtitle: "Set up your profile and verify your email in one clean flow.",
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
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: authInputDecoration(
            label: "Email",
            icon: Icons.alternate_email,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: passwordController,
          obscureText: true,
          textInputAction: TextInputAction.next,
          decoration: authInputDecoration(
            label: "Password",
            icon: Icons.key_outlined,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!isLoading) register();
          },
          decoration: authInputDecoration(
            label: "Confirm password",
            icon: Icons.verified_user_outlined,
          ),
        ),
        const SizedBox(height: 22),
        AuthPrimaryButton(
          label: "Sign up",
          icon: Icons.auto_awesome_rounded,
          isLoading: isLoading,
          onPressed: register,
        ),
      ],
      footer: TextButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text("Back to login"),
      ),
    );
  }
}
