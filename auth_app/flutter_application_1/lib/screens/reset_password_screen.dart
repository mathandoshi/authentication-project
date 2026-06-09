import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/auth_shell.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
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
      final result = await ApiService.resetPassword(
        widget.email,
        otpController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      if (result['success'] == true) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successful")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Password reset failed")),
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
      icon: Icons.password_rounded,
      title: "Reset password",
      subtitle:
          "Use the OTP sent to ${widget.email} and choose a new password.",
      children: [
        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: authInputDecoration(
            label: "OTP",
            icon: Icons.pin_outlined,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: passwordController,
          obscureText: true,
          textInputAction: TextInputAction.next,
          decoration: authInputDecoration(
            label: "New password",
            icon: Icons.key_outlined,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!isLoading) resetPassword();
          },
          decoration: authInputDecoration(
            label: "Confirm password",
            icon: Icons.verified_user_outlined,
          ),
        ),
        const SizedBox(height: 22),
        AuthPrimaryButton(
          label: "Reset password",
          icon: Icons.check_circle_rounded,
          isLoading: isLoading,
          onPressed: resetPassword,
        ),
      ],
      footer: TextButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text("Back"),
      ),
    );
  }
}
