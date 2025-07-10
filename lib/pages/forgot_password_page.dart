import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController(); // Controller for email input
  String _message = ''; // Message to display feedback to the user
  bool _isLoading = false; // Loading state for async operation

  // Sends a password reset email using Firebase
  Future<void> _resetPassword() async {
    setState(() {
      _message = '';
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      setState(() {
        _message = AppStrings.passwordResetLinkSent.tr(); // Success message
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message ?? AppStrings.somethingWentWrong.tr(); // Error message
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.resetPassword.tr()), // App bar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructional text
            Text(
              AppStrings.enterYourEmailToResetPasswordMessage.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Email input field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: AppStrings.email.tr(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),

            // Reset button
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(AppStrings.sendResetLink.tr()),
            ),
            const SizedBox(height: 20),

            // Feedback message (success or error)
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _message.contains(AppStrings.sent.tr())
                      ? Colors.green
                      : Colors.red,
                ),
              )
          ],
        ),
      ),
    );
  }
}
