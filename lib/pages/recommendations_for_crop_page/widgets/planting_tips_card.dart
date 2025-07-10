import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/planting_tips_card_item.dart';
import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';

class PlantingTipsCard extends StatelessWidget {
  // Model containing planting tips data
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const PlantingTipsCard(
      {super.key, required this.recommendationsForCropResponse});

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
                  // Title and icon row
                  Row(
                    children: [
                      Text(
                        AppStrings.plantingTips.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.agriculture),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // List of planting tips
                  SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // Prevent inner scroll
                            shrinkWrap: true,
                            itemCount: recommendationsForCropResponse
                                .planting_tips.length,
                            itemBuilder: (context, index) {
                              return PlantingTipsCardItem(
                                plantingTip: recommendationsForCropResponse
                                    .planting_tips[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
