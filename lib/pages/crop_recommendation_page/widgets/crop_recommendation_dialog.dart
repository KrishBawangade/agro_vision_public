import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a dialog showing the recommended crop to the user.
///
/// [context] - BuildContext used to display the dialog.
/// [recommendedCrop] - The crop predicted based on user input.
/// [onCropUsed] - Callback to execute when the user chooses to use the recommended crop.
Future<void> showRecommendedCropDialog({
  required BuildContext context,
  required String recommendedCrop,
  required Function() onCropUsed,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      // Access the provider to update the selected crop
      final farmPlotProvider = Provider.of<FarmPlotProvider>(context);

      return AlertDialog(
        title: Text(
          "Recommended Crop",
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Recommended Crop based on the given parameters:",
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 8),
            Text(
              recommendedCrop,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel button closes the dialog
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              // Use button saves the crop and calls the callback
              TextButton(
                onPressed: () {
                  farmPlotProvider.setRecommendedCrop(cropName: recommendedCrop);
                  Navigator.of(context).pop();
                  onCropUsed();
                },
                child: const Text("Use"),
              ),
            ],
          ),
        ],
      );
    },
  );
}
