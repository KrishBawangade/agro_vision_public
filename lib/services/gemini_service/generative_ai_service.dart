import 'dart:convert';
import 'package:agro_vision/env.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class GenerativeAiService {
  // 🔹 Generates crop calendar using Gemini API with localized stage names and dates
  static generateCropCalendar({
    required String crop,
    required String formattedDate,
    required String currentLanguageName,
  }) async {
    final model = GenerativeModel(
      model: "gemini-2.0-flash",
      apiKey: Env.geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json", // Expecting JSON format response
      ),
    );

    // Prompt defines output structure and language requirements
    final prompt = """
Generate the crop calendar for $crop starting from the date $formattedDate. Only include essential stages specific to the crop's growth process. Use up to 10 words for each stage description. Return the response strictly in the following JSON format:
{
  "crop": "$crop",
  "crop_calendar": [
    {
      "stage": "<translated stage name in $currentLanguageName>",
      "stage_description": "<translated short description in $currentLanguageName>",
      "start_date": "dd-MM-yyyy",
      "end_date": "dd-MM-yyyy"
    },
    ...
  ]
}""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text; // Return the model's JSON string
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint("Exception while generating the output: ${e.toString()}");
      }
      return e.toString();
    }
  }

  // 🔹 Generates crop recommendations in a given language based on a predefined format
  static generateRecommendationsForCrop({
    required String cropName,
    required String currentLanguage,
  }) async {
    final model = GenerativeModel(
      model: "gemini-2.0-flash",
      apiKey: Env.geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
      ),
    );

    // Prompt includes structured example and translation instructions
    final prompt = """
Generate the same for $cropName using this template and give the response in $currentLanguage. 
Do not change the structure or keys. Only translate the values into $currentLanguage. 
Use this exact format as a reference and strictly return the output in this format only:

{
  "crop_name": "Apple",
  "growing_conditions": {
    "soil_type": "Well-drained loamy soil",
    "watering": "Regular but avoid waterlogging; keep soil moist"
  },
  "planting_tips": [
    "Ensure proper sunlight exposure.",
    "Prune trees annually to maintain healthy growth.",
    "Protect against frost in winter."
  ],
  "pest_management": {
    "common_pests": ["Codling moth", "Aphids", "Apple maggot"],
    "pesticides": [
      {
        "name": "Spinosad",
        "usage": "For codling moths, apply every 10-14 days during active season"
      },
      {
        "name": "Neem oil",
        "usage": "Effective against aphids; use in early morning or late evening"
      },
      {
        "name": "Insecticidal soap",
        "usage": "Apply when apple maggot flies are active; repeat every 7-10 days."
      }
    ]
  },
  "fertilization": {
    "frequency": "Apply in early spring and after harvest",
    "type": "High potassium and nitrogen fertilizers"
  },
  "harvesting": {
    "timing": "Harvest when apples are fully colored and firm to the touch.",
    "storage": "Store in a cool, dry place; avoid stacking to prevent bruising."
  }
}
""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text; // Return translated and structured JSON
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint("Exception while generating the output: ${e.toString()}");
      }
      return e.toString();
    }
  }

  // 🔹 Sends chat history to a Cloud Function to generate a conversational response
  static Future<String> generateOutputBasedOnChats({
    required List<Content> chats,
  }) async {
    const String firebaseFunctionUrl =
        "https://generategeminichatresponse-mxphv6qedq-uc.a.run.app";

    try {
      // Convert Content list into JSON-serializable format for the API
      List<Map<String, dynamic>> chatJsonList = chats.map((chat) {
        return {
          'role': chat.role,
          'parts':
              chat.parts.map((p) => {'text': (p as TextPart).text}).toList(),
        };
      }).toList();

      // Call the Firebase Cloud Function with the chat history
      final response = await http.post(
        Uri.parse(firebaseFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chats': chatJsonList}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['output'] ?? ''; // Return the generated text
      } else {
        return "Error: ${response.statusCode} ${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}
