import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/pesticide_card_item.dart';
import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';

class PesticideCard extends StatelessWidget {
  // Contains the pesticide recommendations for the selected crop
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const PesticideCard({super.key, required this.recommendationsForCropResponse});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row with title and icon
        Row(
          children: [
            Text(
              AppStrings.pesticides.tr(),
              style: TextStyle(fontSize: 18, color: Theme.of(context).hintColor),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.science),
          ],
        ),
        const SizedBox(height: 8),
        
        // Horizontally scrollable list of pesticide cards
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendationsForCropResponse.pest_management.pesticides.length,
            itemBuilder: (context, index) {
              return PesticideCardItem(
                pesticidesRecommendation: recommendationsForCropResponse.pest_management.pesticides[index],
              );
            },
          ),
        )
      ],
    );
  }
}
