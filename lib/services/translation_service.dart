import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';

class TranslationService {
  // Instance of the GoogleTranslator from the 'translator' package
  final GoogleTranslator _translator = GoogleTranslator();

  // 🔹 Translates a given [text] into the [targetLanguage]
  Future<String> translate(String text, String targetLanguage) async {
    try {
      // Attempt translation using GoogleTranslator
      var translation = await _translator.translate(text, to: targetLanguage);

      // Return the translated text
      return translation.text;
    } catch (e) {
      // Log the error in debug mode if translation fails
      if (kDebugMode) debugPrint("Translation error: $e");

      // Fallback: return original text if an exception occurs
      return text;
    }
  }
}
