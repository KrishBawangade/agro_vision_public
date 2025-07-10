// ignore_for_file: use_build_context_synchronously

// Importing required packages and providers
import 'package:agro_vision/providers/chat_bot_provider.dart';
import 'package:agro_vision/providers/connectivity_provider.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ChatBotViewMainPage extends StatefulWidget {
  const ChatBotViewMainPage({super.key});

  @override
  State<ChatBotViewMainPage> createState() => _ChatBotViewMainPageState();
}

class _ChatBotViewMainPageState extends State<ChatBotViewMainPage> {
  @override
  Widget build(BuildContext context) {
    // Accessing required providers
    ChatBotProvider chatBotProvider = Provider.of<ChatBotProvider>(context);
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    ConnectivityProvider connectivityProvider =
        Provider.of<ConnectivityProvider>(context);

    // Custom chat theme to match app's color scheme
    ChatTheme chatTheme = DefaultChatTheme(
      backgroundColor: Colors.transparent,
      primaryColor: Theme.of(context).colorScheme.inversePrimary,
      sentMessageBodyBoldTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      secondaryColor: Theme.of(context).colorScheme.surfaceContainerLow,
      receivedMessageBodyTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.onSurface),
      inputBackgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      inputTextColor: Theme.of(context).colorScheme.onSurface,
    );

    return SizedBox.expand(
      child: chatBotProvider.isLoadingList
          // Loading indicator while messages are loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Chat(
                    isLeftStatus: true,

                    // UI for when the chat is empty
                    emptyState: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(75),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppStrings.startConversation.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(180),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.emptyChatBotMessage.tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(150),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Message selection logic for deletion
                    onMessageLongPress: (context, message) {
                      if (!chatBotProvider.isDeletingMessages) {
                        chatBotProvider.setIsDeletingMessages(isDeleting: true);
                        chatBotProvider.selectMessage(message: message);
                      }
                    },

                    // Toggle selection/unselection on tap
                    onMessageTap: (context, message) {
                      if (chatBotProvider.isDeletingMessages) {
                        if (chatBotProvider.selectedMessageList
                                .contains(message) &&
                            chatBotProvider.selectedMessageList.length == 1) {
                          chatBotProvider.setIsDeletingMessages(
                              isDeleting: false);
                        } else {
                          if (chatBotProvider.selectedMessageList
                              .contains(message)) {
                            chatBotProvider.unselectMessage(message: message);
                          } else {
                            chatBotProvider.selectMessage(message: message);
                          }
                        }
                      }
                    },

                    // Loader at the bottom when bot is typing
                    listBottomWidget: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 50),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: chatBotProvider.isBotTyping
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    size: 40,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),

                    // Avatar UI for bot and user
                    avatarBuilder: (user) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: user.id == "bot"
                              ? const Icon(Icons.smart_toy, size: 16)
                              : const Icon(Icons.account_circle),
                        ),
                      );
                    },

                    showUserAvatars: true,
                    showUserNames: true,
                    theme: chatTheme,
                    messages: chatBotProvider.messageList,

                    // Handling message sending
                    onSendPressed: (message) async {
                      if (!chatBotProvider.isBotTyping) {
                        if (await connectivityProvider
                            .checkInternetConnection()) {
                          try {
                            // Check if user can send more messages today
                            bool is24HrPassed =
                                AppFunctions.is24HoursPassedSince(
                              mainProvider.currentUserData
                                      ?.lastTimeRequestsUpdated ??
                                  DateTime(2000),
                            );

                            // Allow message if quota not exhausted or 24hr passed
                            if ((mainProvider.currentUserData
                                            ?.chatBotRequestsLeft ??
                                        0) >
                                    0 ||
                                is24HrPassed) {
                              await chatBotProvider.addMessage(
                                message: message.text,
                                user: chatBotProvider.clientUser,
                              );
                              await chatBotProvider.generateResponse();
                            } else {
                              AppFunctions.showSnackBar(
                                context: context,
                                msg: AppStrings
                                    .chatbotRequestsLimitReachedMessage
                                    .tr(),
                                duration: const Duration(seconds: 4),
                              );
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              debugPrint("Error occurred adding message: $e");
                            }
                          }
                        } else {
                          // No internet warning
                          AppFunctions.showSnackBar(
                            context: context,
                            msg: AppStrings.noInternetRetryMessage.tr(),
                          );
                        }
                      }
                    },

                    // Required user data for chat package
                    user: chatBotProvider.clientUser,
                  ),
                ),
              ],
            ),
    );
  }
}
