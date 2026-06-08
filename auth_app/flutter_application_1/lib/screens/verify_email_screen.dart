import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController otpController = TextEditingController();

  bool isLoading = false;
  String message = "";

  Future<void> verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    final response = await ApiService.verifyOtp(
      widget.email,
      otpController.text.trim(),
    );

    setState(() {
      isLoading = false;
      message = response['message'] ?? "";
    });

    if (response['success'] == true) {
      await AuthService.saveToken(response['access']);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> resendOtp() async {
    final response = await ApiService.sendOtp(widget.email);

    setState(() {
      message = response['message'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("OTP sent to: ${widget.email}"),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : verifyOtp,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Verify OTP"),
            ),

            TextButton(
              onPressed: resendOtp,
              child: const Text("Resend OTP"),
            ),

            const SizedBox(height: 10),

            Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}