import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A card widget that displays fertilization recommendations
/// including type and frequency of fertilizer usage.
class FertilizationCard extends StatelessWidget {
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const FertilizationCard({
    super.key,
    required this.recommendationsForCropResponse,
  });

  @override
  Widget build(BuildContext context) {
    final fertilization = recommendationsForCropResponse.fertilization;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with icon
            Row(
              children: [
                Text(
                  AppStrings.fertilization.tr(),
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.eco),
              ],
            ),

            const SizedBox(height: 8),

            // Frequency
            Text(
              fertilization.frequency,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 32),

            // Fertilizer Type
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.type.tr(),
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                Flexible(
                  child: Text(
                    fertilization.type,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
