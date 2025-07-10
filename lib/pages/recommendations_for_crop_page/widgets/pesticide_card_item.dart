import 'package:agro_vision/services/gemini_service/models/pesticides_recommendation_model.dart';
import 'package:flutter/material.dart';

class PesticideCardItem extends StatelessWidget {
  // Model containing pesticide name and usage info
  final PesticidesRecommendationModel pesticidesRecommendation;

  const PesticideCardItem({super.key, required this.pesticidesRecommendation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add horizontal spacing around the card
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: SizedBox(
        // Make the card take up 75% of screen width
        width: MediaQuery.of(context).size.width * 0.75,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the pesticide name in bold
                Text(
                  pesticidesRecommendation.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Display the pesticide usage instructions
                Text(pesticidesRecommendation.usage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
