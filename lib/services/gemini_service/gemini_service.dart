import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  // Singleton instance of the Gemini SDK
  static final _gemini = Gemini.instance;

  // Maximum allowed input tokens for Gemini model (limit set by API)
  static const _maxInputToken = 1048576;

  // 🔹 Generate output for simple text prompt (non-streaming, no return)
  static generateOutputBasedOnText({required String inputText}) {
    _gemini.text(inputText).then((value) async {
      // Currently empty block – can handle result if needed
    }).catchError((e) {
      // Logs the error if debug mode is enabled
      if (kDebugMode) debugPrint("Error: $e");
    });
  }

  // 🔹 Generate chat response based on list of Content (multi-turn conversation)
  static Future<String> generateOutputBasedOnChats({
    required List<Content> chats,
  }) async {
    List<Content> contextChat = []; // Holds filtered chat context
    var contextTokenCount = 0; // Tracks token usage
    var maxConversations = 6; // Limit max number of context messages
    String output = ""; // Final generated output

    // Traverse chats and build valid context without exceeding token limit
    await Future.forEach(chats, (chat) async {
      if (contextChat.length == maxConversations) {
        // Do nothing if max conversation limit reached
      } else {
        // Estimate token count for this chat part
        int tokenCount =
            await _gemini.countTokens(chat.parts?[0].text ?? "") ?? 0;
        contextTokenCount += tokenCount;

        // Only add chat to context if total token count stays within limit
        if (contextTokenCount < _maxInputToken) {
          contextChat.add(chat);
        }
      }
    });

    // Call Gemini's chat model with selected chat context
    await _gemini
        .chat(modelName: "gemini-1.5-pro-002", contextChat)
        .then((value) {
      // Set output to generated response or fallback
      output = value?.output ?? "No output";
    }).catchError((e) {
      // Set output to error string if failed
      output = e.toString();
    });

    return output;
  }
}
