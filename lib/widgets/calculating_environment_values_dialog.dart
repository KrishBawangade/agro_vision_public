import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CalculatingEnvironmentValuesDialog {
  static bool _isDialogShowing = false;

  /// Shows a non-dismissible loading dialog with a message.
  static void show(BuildContext context, {String? message}) {
    // Use default localized message if not provided
    message ??= AppStrings.calculatingEnvironmentValuesMessage.tr();

    // Prevent showing multiple dialogs at once
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Prevent back button from closing the dialog
          child: Dialog(
            backgroundColor: Colors.transparent, // Transparent background for overlay feel
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(), // Loader spinner
                const SizedBox(height: 16), // Spacing
                Text(
                  message!, // Message below the loader
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Hides the dialog if it's currently showing.
  static void hide(BuildContext context) {
    if (_isDialogShowing) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
      _isDialogShowing = false;
    }
  }
}
