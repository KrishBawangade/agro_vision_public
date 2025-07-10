import 'package:flutter/material.dart';

class PlantingTipsCardItem extends StatelessWidget {
  // Individual planting tip text to display
  final String plantingTip;

  const PlantingTipsCardItem({super.key, required this.plantingTip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bullet point row with the planting tip text
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("• ", style: TextStyle(fontSize: 20)), // Bullet
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                plantingTip,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Spacing between tips
      ],
    );
  }
}
