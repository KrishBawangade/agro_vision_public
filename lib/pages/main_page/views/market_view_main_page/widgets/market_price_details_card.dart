import 'package:agro_vision/services/current_market_price_api/models/current_market_price_record_model.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// A card widget that displays detailed market price info for a specific commodity
class MarketPriceDetailsCard extends StatelessWidget {
  final CurrentMarketPriceRecordModel currentMarketPriceRecord;

  const MarketPriceDetailsCard({
    super.key,
    required this.currentMarketPriceRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: SizedBox(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Commodity name (fallback to 'Unknown' if null)
                Text(
                  currentMarketPriceRecord.commodity ?? AppStrings.unknown.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 32),

                // Detailed information section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Market name
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${AppStrings.market.tr()}: ",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          TextSpan(
                            text: currentMarketPriceRecord.market ?? "-",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // District and state
                    Text(
                      "${currentMarketPriceRecord.district!}, ${currentMarketPriceRecord.state}",
                    ),

                    const SizedBox(height: 16),

                    // Quality/Grade
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${AppStrings.quality.tr()}: ",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          TextSpan(
                            text: currentMarketPriceRecord.grade ?? "-",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price range per quintal
                    Text(
                      "₹${currentMarketPriceRecord.min_price} - ₹${currentMarketPriceRecord.max_price} ${AppStrings.quintal.tr()}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
