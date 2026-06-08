import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final TextEditingController otpController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() async {

    if (passwordController.text !=
        confirmPasswordController.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final result =
          await ApiService.resetPassword(
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
          const SnackBar(
            content: Text(
              "Password reset successful",
            ),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ??
                  "Password reset failed",
            ),
          ),
        );
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              const SizedBox(height: 100),

              const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: otpController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: "OTP",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller:
                    passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      "New Password",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller:
                    confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Confirm Password",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : resetPassword,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Reset Password",
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}