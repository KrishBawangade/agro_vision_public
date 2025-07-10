// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agro_vision/pages/main_page/main_page.dart';
import 'package:agro_vision/utils/constants.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late final User _user;
  bool _isEmailVerified = false;
  bool _isSendingEmail = false;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // Get the currently signed-in user
    _user = FirebaseAuth.instance.currentUser!;
    _isEmailVerified = _user.emailVerified;

    // If email is not yet verified, send a verification email
    if (!_isEmailVerified) {
      _sendVerificationEmail();
    }
  }

  // Sends the verification email to the user's email address
  Future<void> _sendVerificationEmail() async {
    setState(() => _isSendingEmail = true);
    try {
      await _user.sendEmailVerification();
      if (context.mounted) {
        AppFunctions.showSnackBar(
          context: context,
          msg: AppStrings.verificationEmailSent.tr(),
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppFunctions.showSnackBar(
          context: context,
          msg: AppStrings.errorSendingEmail,
        );
      }
    } finally {
      setState(() => _isSendingEmail = false);
    }
  }

  // Reloads the user and checks whether email has been verified
  Future<void> _checkVerificationStatus() async {
    setState(() => _isChecking = true);
    await _user.reload(); // Refresh user info
    final refreshedUser = FirebaseAuth.instance.currentUser!;
    setState(() => _isEmailVerified = refreshedUser.emailVerified);

    // If verified, navigate to MainPage
    if (_isEmailVerified && context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MainPage(),
          settings: const RouteSettings(arguments: AppConstants.mainPage),
        ),
      );
    } else {
      // Show message if still not verified
      if (context.mounted) {
        AppFunctions.showSnackBar(
          context: context,
          msg: AppStrings.emailNotVerifiedYet.tr(),
        );
      }
    }

    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Email icon
              Icon(Icons.email_outlined, size: 80, color: Colors.green.shade700),

              const SizedBox(height: 20),

              // Page title
              Text(
                AppStrings.verifyYourEmail.tr(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 15),

              // Instructional text
              Text(
                AppStrings.verificationEmailSentCheckInboxMessage.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 30),

              // "I have verified" button
              ElevatedButton.icon(
                onPressed: _isChecking ? null : _checkVerificationStatus,
                icon: const Icon(Icons.check_circle_outline),
                label: _isChecking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppStrings.iHaveVerified.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),

              const SizedBox(height: 15),

              // "Resend Email" button
              TextButton.icon(
                onPressed: _isSendingEmail ? null : _sendVerificationEmail,
                icon: const Icon(Icons.refresh),
                label: _isSendingEmail
                    ? Text(AppStrings.resending.tr())
                    : Text(AppStrings.resendEmail.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
