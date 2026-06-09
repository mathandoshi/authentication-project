import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/auth_shell.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.forgotPassword(
        emailController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResetPasswordScreen(email: emailController.text.trim()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Could not send OTP")),
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
      icon: Icons.mark_email_read_rounded,
      title: "Recover access",
      subtitle: "Enter your email and we will help you reset your password.",
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!isLoading) sendOtp();
          },
          decoration: authInputDecoration(
            label: "Email",
            icon: Icons.alternate_email,
          ),
        ),
        const SizedBox(height: 22),
        AuthPrimaryButton(
          label: "Send OTP",
          icon: Icons.send_rounded,
          isLoading: isLoading,
          onPressed: sendOtp,
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
