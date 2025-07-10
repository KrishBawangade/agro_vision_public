// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/pages/sign_in_sign_up_page.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class ChooseLanguagePage extends StatefulWidget {
  const ChooseLanguagePage({super.key});

  @override
  State<ChooseLanguagePage> createState() => _ChooseAppLanguagePageState();
}

class _ChooseAppLanguagePageState extends State<ChooseLanguagePage> {
  // List of supported languages and their locale codes
  final List<Map<String, dynamic>> languages = [
    {"name": "English", "locale": const Locale("en")},
    {"name": "हिन्दी", "locale": const Locale("hi")},
    {"name": "मराठी", "locale": const Locale("mr")},
    {"name": "తెలుగు", "locale": const Locale("te")},
    {"name": "தமிழ்", "locale": const Locale("ta")},
    {"name": "ગુજરાતી", "locale": const Locale("gu")},
    {"name": "বাংলা", "locale": const Locale("bn")},
    {"name": "ਪੰਜਾਬੀ", "locale": const Locale("pa")},
    {"name": "ಕನ್ನಡ", "locale": const Locale("kn")},
  ];

  // Currently selected locale
  Locale? selectedLocale;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Title
            Text(
              "🌍 Choose Your Language",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Please select your preferred language to continue using AgroVision.",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
              ),
            ),

            const SizedBox(height: 10),

            // Grid of language options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: languages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = selectedLocale == lang['locale'];

                    return GestureDetector(
                      onTap: () {
                        // Update selected locale on tap
                        setState(() {
                          selectedLocale = lang['locale'];
                        });
                      },
                      child: Stack(
                        children: [
                          // Language selection card
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surface,
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.outline.withAlpha(85),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black26
                                      : Colors.grey.withAlpha(57),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                lang['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),

                          // Check icon if selected
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Ionicons.checkmark_circle,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedLocale == null
                        ? colorScheme.primary.withAlpha(127)
                        : colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: selectedLocale == null
                      ? null
                      : () async {
                          // Set selected language to EasyLocalization
                          await EasyLocalization.of(context)!
                              .setLocale(selectedLocale!);

                          // Save selected language in local storage
                          await AppFunctions.setSharedPreferenceString(
                            key: AppConstants.selectedAppLanguagePrefKey,
                            value: selectedLocale!.languageCode,
                          );

                          // Navigate to sign in/sign up screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SignInSignUpPage(),
                            ),
                          );
                        },
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
