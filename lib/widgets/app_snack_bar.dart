import 'package:flutter/material.dart';

class AppSnackBar {
  /// Displays a custom SnackBar with a message and an action.
  static showSnackBar({
    required BuildContext context,
    required String msg,
    required SnackBarAction action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),                           // Message to display
        action: action,                               // Action button (e.g., Undo, Retry)
        duration: const Duration(minutes: 5),         // Duration the snackbar stays visible
        dismissDirection: DismissDirection.horizontal, // Allow horizontal swipe to dismiss
        showCloseIcon: true,                          // Show a close (X) icon
      ),
    );
  }
}
