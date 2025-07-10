import 'package:flutter/material.dart';

/// A bottom sheet widget to let users select their preferred app language.
class SelectLanguageBottomSheet {
  /// List of supported languages with their display name and corresponding locale.
  static final List<Map<String, dynamic>> languages = [
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

  /// Shows the language selection bottom sheet.
  ///
  /// Returns the selected [Locale] or null if no selection is made.
  static Future<Locale?> show(BuildContext context, Locale currentLocale) {
    return showModalBottomSheet<Locale>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Select Language",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const Divider(),

              // Language list
              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    // Check if this language is currently selected
                    bool isSelected =
                        languages[index]['locale'] == currentLocale;

                    return ListTile(
                      leading: Icon(Icons.language,
                          color: Theme.of(context).colorScheme.primary),
                      title: Text(
                        languages[index]['name'],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check,
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                      onTap: () {
                        // Return selected locale and close the sheet
                        Navigator.pop(context, languages[index]['locale']);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
