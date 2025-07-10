// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  // List of supported languages with their display names and corresponding locales
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

  @override
  Widget build(BuildContext context) {
    // Get the current app locale
    Locale currentLocale = context.locale;

    return Scaffold(
      appBar: CustomAppBar(title: "Select Language".tr()), // Custom app bar with localized title
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          bool isSelected = currentLocale == lang["locale"]; // Check if this language is currently selected

          return ListTile(
            title: Text(lang["name"]), // Language name
            trailing: isSelected
                ? const Icon(Icons.check, color: Colors.green) // Show check if selected
                : null,
            onTap: () async {
              // Change app locale
              await EasyLocalization.of(context)!.setLocale(lang["locale"]);
              // Restart the app to apply changes across the app
              Restart.restartApp();
              if (context.mounted) {
                Navigator.pop(context); // Optionally pop the page after restart (though may not execute after restart)
              }
            },
          );
        },
      ),
    );
  }
}
