import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/auth_shell.dart';
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

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

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
    return AuthShell(
      icon: Icons.verified_rounded,
      title: "Verify your email",
      subtitle: "Enter the OTP sent to ${widget.email}.",
      children: [
        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!isLoading) verifyOtp();
          },
          decoration: authInputDecoration(
            label: "OTP",
            icon: Icons.pin_outlined,
          ),
        ),
        const SizedBox(height: 22),
        AuthPrimaryButton(
          label: "Verify OTP",
          icon: Icons.task_alt_rounded,
          isLoading: isLoading,
          onPressed: verifyOtp,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: resendOtp,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text("Resend OTP"),
        ),
        if (message.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF9A3412),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
      footer: TextButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
        label: const Text("Back"),
      ),
    );
  }
}
