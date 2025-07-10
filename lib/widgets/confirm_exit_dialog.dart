
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmExitDialog {
  /// Shows a confirmation dialog before exiting the app or screen.
  /// Returns `true` if user confirms exit, otherwise `false`.
  static Future<bool?> showConfirmExitDialog({required BuildContext context}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          // Dialog title with bold text
          title: Text(
            AppStrings.confirmExit.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // Dialog content message
          content: const Text(
            AppStrings.confirmExitMessage,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel / No button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Do not exit
                  },
                  child: Text(
                    AppStrings.no.tr(),
                    style: const TextStyle(color: Colors.greenAccent),
                  ),
                ),
                // Confirm / Yes button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Exit confirmed
                  },
                  child: Text(
                    AppStrings.yes.tr(),
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
