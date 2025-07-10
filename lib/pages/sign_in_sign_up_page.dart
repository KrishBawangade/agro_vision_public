// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/models/user_data_model.dart';
import 'package:agro_vision/pages/email_verification_page.dart';
import 'package:agro_vision/pages/forgot_password_page.dart';
import 'package:agro_vision/pages/main_page/main_page.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInSignUpPage extends StatefulWidget {
  const SignInSignUpPage({super.key});

  @override
  State<SignInSignUpPage> createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String _errorText = '';

  /// Toggle between SignIn and SignUp form
  void _toggleFormType() {
    setState(() {
      _isLogin = !_isLogin;
      _errorText = '';
    });
  }

  /// Handles user authentication
  Future<void> _submit(MainProvider mainProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      UserCredential cred;

      if (_isLogin) {
        // Login
        cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Sign Up
        cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save user data to Firestore
        UserDataModel userData = UserDataModel(
          id: cred.user!.uid,
          name: _nameController.text.trim(),
          email: cred.user!.email ?? "",
          image: cred.user!.photoURL ?? "",
          imageFileName: "",
          lastTimeRequestsUpdated: DateTime.now(),
        );

        await mainProvider.addUserData(
          userData: userData,
          onUserDataAdded: () async {
            await AppFunctions.showToastMessage(
              msg: AppStrings.accountCreatedMessage.tr(),
            );
          },
          onError: () {},
        );

        // Send email verification
        await cred.user!.sendEmailVerification();
      }

      // Check if email is verified
      await cred.user!.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser != null && !updatedUser.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationPage()),
        );
        return;
      }

      // Navigate to MainPage if verified
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainPage(),
          settings: const RouteSettings(arguments: AppConstants.mainPage),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message ?? AppStrings.authenticationFailed.tr();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                _isLogin
                    ? "${AppStrings.welcomeBack.tr()} 👋"
                    : "${AppStrings.createAccount.tr()} 🌱",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 25),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name (Only for SignUp)
                    if (!_isLogin)
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: AppStrings.fullName.tr(),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) => value!.isEmpty
                            ? AppStrings.enterYourName.tr()
                            : null,
                      ),
                    const SizedBox(height: 15),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppStrings.email.tr(),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) => value!.contains('@')
                          ? null
                          : AppStrings.enterValidEmail.tr(),
                    ),
                    const SizedBox(height: 15),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppStrings.password.tr(),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      validator: (value) => value!.length < 6
                          ? AppStrings.minPasswordLengthMessage.tr()
                          : null,
                    ),
                    const SizedBox(height: 10),

                    // Forgot Password (Only for Login)
                    if (_isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordPage()),
                            );
                          },
                          child: Text(AppStrings.forgotPassword.tr()),
                        ),
                      ),
                    const SizedBox(height: 10),

                    // Error Message
                    if (_errorText.isNotEmpty)
                      Text(
                        _errorText,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 10),

                    // Submit Button
                    ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _submit(mainProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(_isLogin
                              ? AppStrings.signIn.tr()
                              : AppStrings.signUp.tr()),
                    ),

                    const SizedBox(height: 10),

                    // Switch between SignIn and SignUp
                    TextButton(
                      onPressed: _toggleFormType,
                      child: Text(
                        _isLogin
                            ? AppStrings.dontHaveAccountMessage.tr()
                            : AppStrings.alreadyHaveAccountMessage.tr(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
