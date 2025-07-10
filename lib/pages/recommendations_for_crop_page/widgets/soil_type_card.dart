import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SoilTypeCard extends StatelessWidget {
  // Contains the soil type recommendation data for a crop
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const SoilTypeCard({super.key, required this.recommendationsForCropResponse});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card title and icon
                  Row(
                    children: [
                      Text(
                        AppStrings.soilType.tr(),
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.grass),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Soil type text content
                  Text(
                    recommendationsForCropResponse.growing_conditions.soil_type,
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
