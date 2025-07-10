import 'package:flutter/material.dart';

/// A simple bullet-point style card item widget used to display common pest names.
///
/// Example:
///   • Aphids
class CommonPestsCardItem extends StatelessWidget {
  /// The name of the pest to display.
  final String pestName;

  const CommonPestsCardItem({super.key, required this.pestName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bullet icon
        const Text("•", style: TextStyle(fontSize: 20)),

        const SizedBox(width: 8),

        // Pest name with wrapping support
        Flexible(
          child: Text(
            pestName,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
