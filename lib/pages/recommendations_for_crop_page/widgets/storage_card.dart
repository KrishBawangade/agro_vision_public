import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';

class StorageCard extends StatelessWidget {
  // Contains storage recommendations data for the crop
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const StorageCard({super.key, required this.recommendationsForCropResponse});

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
                  // Title row with label and icon
                  Row(
                    children: [
                      Text(
                        AppStrings.storage.tr(),
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.inventory),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Displaying storage instructions
                  Text(
                    recommendationsForCropResponse.harvesting.storage,
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
