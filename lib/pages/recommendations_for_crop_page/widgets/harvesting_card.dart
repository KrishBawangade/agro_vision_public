import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';

class HarvestingCard extends StatelessWidget {
  // Model containing harvesting information for the crop
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const HarvestingCard(
      {super.key, required this.recommendationsForCropResponse});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Use Expanded to take available horizontal space
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row with harvesting label and icon
                  Row(
                    children: [
                      Text(
                        AppStrings.harvesting.tr(),
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Display harvesting timing info
                  Text(
                    recommendationsForCropResponse.harvesting.timing,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
