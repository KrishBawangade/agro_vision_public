import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/common_pests_card_item.dart';
import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A card widget that displays a list of common pests related to the crop recommendation.
///
/// It uses the [RecommendationsForCropResponseModel] to access the pests data.
class CommonPestsCard extends StatelessWidget {
  /// The recommendation response containing common pest information.
  final RecommendationsForCropResponseModel recommendationsForCropResponse;

  const CommonPestsCard({
    super.key,
    required this.recommendationsForCropResponse,
  });

  @override
  Widget build(BuildContext context) {
    final commonPests =
        recommendationsForCropResponse.pest_management.common_pests;

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
                  AppStrings.commonPests.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.bug_report),
              ],
            ),

            const SizedBox(height: 16),

            // Pests list
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: commonPests.length,
              itemBuilder: (context, index) {
                return CommonPestsCardItem(
                  pestName: commonPests[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
