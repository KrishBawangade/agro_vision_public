import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';

class WateringCard extends StatelessWidget {
  // Model containing all crop recommendations including watering info
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const WateringCard({super.key, required this.recommendationsForCropResponse});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // Card expands to full width inside the row
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading row with label and water drop icon
                  Row(
                    children: [
                      Text(
                        AppStrings.watering.tr(),
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.water_drop),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Display watering information text
                  Text(
                    recommendationsForCropResponse.growing_conditions.watering,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
