// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/providers/connectivity_provider.dart';
import 'package:agro_vision/services/firebase_service/firestore_service.dart';
import 'package:agro_vision/services/gemini_service/generative_ai_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

class ChatBotProvider extends ChangeNotifier {
  final ConnectivityProvider connectivtyProvider;

  ChatBotProvider({required this.connectivtyProvider}) {
    loadMessageList();
  }

  // Internal states
  final types.User clientUser = const types.User(id: "user");
  final types.User chatBotUser = const types.User(id: "bot", firstName: "Assistant");

  List<types.Message> _messageList = [];
  List<types.Message> _selectedMessageList = [];

  bool _isLoadingList = false;
  bool _isDeletingMessages = false;
  bool _isBotTyping = false;

  // Getters
  List<types.Message> get messageList => _messageList;
  List<types.Message> get selectedMessageList => _selectedMessageList;
  bool get isBotTyping => _isBotTyping;
  bool get isLoadingList => _isLoadingList;
  bool get isDeletingMessages => _isDeletingMessages;

  /// Add a new user/bot message and persist it
  Future<void> addMessage({
    required String message,
    required types.User user,
  }) async {
    try {
      final textMessage = types.TextMessage(
        author: user,
        id: const Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        roomId: FirebaseAuth.instance.currentUser?.uid ?? "",
        text: message,
      );

      _messageList.insert(0, textMessage);
      notifyListeners();

      await FirestoreService.addMessage(
        message: textMessage,
        onMessageAdded: () {},
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error occurred: $e");
      }
    }
  }

  /// Generate response using Gemini AI and append it to chat
  Future<void> generateResponse() async {
    _isBotTyping = true;
    notifyListeners();

    List<Content> chatList = [];

    // Limit to 8 latest messages
    for (int i = 0; i < _messageList.length && i < 8; i++) {
      final textMessage = _messageList[i] as types.TextMessage;

      final content = Content(
        textMessage.author.id == "bot" ? "model" : "user",
        [TextPart(textMessage.text)],
      );

      chatList.add(content);
    }

    // Add system instruction to guide Gemini
    chatList.add(
      Content("user", [
        TextPart("You are AgroVision AI, an intelligent farming assistant. Stay within farming-related topics."),
      ]),
    );

    final output = await GenerativeAiService.generateOutputBasedOnChats(
      chats: chatList.reversed.toList(),
    );

    _isBotTyping = false;
    notifyListeners();

    await addMessage(message: output, user: chatBotUser);
  }

  /// Load chat history from Firestore
  void loadMessageList() {
    _isLoadingList = true;
    notifyListeners();

    FirestoreService.getMessageList().listen((snapshot) {
      _messageList = snapshot.docs
          .map((message) => types.Message.fromJson(message.data()))
          .toList();

      _isLoadingList = false;
      notifyListeners();
    }).onError((e) {
      if (kDebugMode) {
        debugPrint("Error fetching messages: $e");
      }
      _isLoadingList = false;
      notifyListeners();
    });
  }

  /// Set deletion state
  void setIsDeletingMessages({required bool isDeleting}) {
    _isDeletingMessages = isDeleting;
    notifyListeners();
  }

  /// Select a message
  void selectMessage({required types.Message message}) {
    if (!_selectedMessageList.contains(message)) {
      _selectedMessageList.add(message);
      notifyListeners();
    }
  }

  /// Unselect a message
  void unselectMessage({required types.Message message}) {
    _selectedMessageList.remove(message);
    notifyListeners();
  }

  /// Select all messages
  void selectAllMessages() {
    _selectedMessageList = List.from(_messageList);
    notifyListeners();
  }

  /// Delete all messages from Firestore and memory
  Future<void> deleteAllMessages() async {
    await FirestoreService.deleteAllMessages(
      messageList: _messageList,
      onAllMessageDeleted: () {
        _messageList = [];
      },
    );

    notifyListeners();
  }
}
