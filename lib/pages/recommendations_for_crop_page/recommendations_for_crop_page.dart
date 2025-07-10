// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/common_pests_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/fertilization_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/harvesting_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/pesticide_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/planting_tips_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/soil_type_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/storage_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/widgets/watering_card.dart';
import 'package:agro_vision/providers/recommendations_for_crop_provider.dart';
import 'package:agro_vision/providers/translation_provider.dart';
import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:agro_vision/widgets/custom_app_bar.dart';
import 'package:agro_vision/widgets/select_language_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationsForCropPage extends StatefulWidget {
  final String cropName; // Crop name passed to this page

  const RecommendationsForCropPage({super.key, required this.cropName});

  @override
  State<RecommendationsForCropPage> createState() =>
      _RecommendationsForCropPageState();
}

class _RecommendationsForCropPageState
    extends State<RecommendationsForCropPage> {
  bool _isLoading = false;
  bool _isTranslated = false;

  // Holds the translated crop suggestion map
  Map<String, String>? translatedCropSuggestionMap;

  // Final data to be rendered, either original or translated
  RecommendationsForCropResponseModel? cropSuggestionResponse;

  @override
  void initState() {
    super.initState();

    // Load crop suggestions using provider
    Future.microtask(() async {
      RecommendationsForCropProvider recommendationsForCropProvider =
          Provider.of<RecommendationsForCropProvider>(context, listen: false);
      await recommendationsForCropProvider.loadRecommendationsForCrop(
        cropName: widget.cropName,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access providers
    RecommendationsForCropProvider recommendationsForCropProvider =
        Provider.of<RecommendationsForCropProvider>(context);
    TranslationProvider translationProvider =
        Provider.of<TranslationProvider>(context);

    // Check if crop suggestions have a translated version
    bool hasTranslatedCropSuggestionMap = translationProvider
        .isTranslatedCropSuggestionsList
        .any((isTranslatedMap) {
      bool matched = isTranslatedMap["id"] ==
          (recommendationsForCropProvider.recommendationsForCropResponse?.id ??
              "");
      if (matched) {
        translatedCropSuggestionMap = isTranslatedMap;
      }
      return matched;
    });

    // Reset if not translated
    if (!hasTranslatedCropSuggestionMap) {
      translatedCropSuggestionMap = null;
    }

    // Determine if currently selected suggestion is translated
    _isTranslated = !(translatedCropSuggestionMap == null ||
        translatedCropSuggestionMap?["selectedLocale"] ==
            (recommendationsForCropProvider
                    .recommendationsForCropResponse?.languageCode ??
                "en"));

    // If translated, use translated data
    if (_isTranslated && !_isLoading) {
      translationProvider.selectedLocaleCropSuggestion = translationProvider
          .translatedCropSuggestionsList
          .firstWhere((cropCalendar) =>
              cropCalendar.id == translatedCropSuggestionMap?["id"] &&
              cropCalendar.languageCode ==
                  translatedCropSuggestionMap?["selectedLocale"]);
    }

    // Choose final suggestion data
    cropSuggestionResponse = _isTranslated
        ? translationProvider.selectedLocaleCropSuggestion
        : recommendationsForCropProvider.recommendationsForCropResponse;

    return Scaffold(
      appBar: CustomAppBar(
        title: toBeginningOfSentenceCase(widget.cropName.toLowerCase()),
      ),
      body: SafeArea(
        child: _isLoading || recommendationsForCropProvider.isLoading
            // Show loader
            ? const Center(child: CircularProgressIndicator())
            : cropSuggestionResponse == null
                // Show fallback if no suggestions available
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        AppStrings.cropSuggestionsRequestsLimitReachedMessage
                            .tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  )
                // Show crop recommendation cards
                : SizedBox(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Translate Button
                                ElevatedButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          // Show language selector
                                          Locale? selectedLanguage =
                                              await SelectLanguageBottomSheet
                                                  .show(
                                            context,
                                            Locale(
                                              cropSuggestionResponse
                                                      ?.languageCode ??
                                                  "en",
                                            ),
                                          );

                                          // Translate if new language selected
                                          if (selectedLanguage != null &&
                                              recommendationsForCropProvider
                                                      .recommendationsForCropResponse !=
                                                  null &&
                                              (recommendationsForCropProvider
                                                          .recommendationsForCropResponse!
                                                          .languageCode ??
                                                      "en") !=
                                                  selectedLanguage
                                                      .languageCode) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await translationProvider
                                                .translateCropSuggestion(
                                              selectedLocale:
                                                  selectedLanguage.languageCode,
                                              cropSuggestion:
                                                  recommendationsForCropProvider
                                                      .recommendationsForCropResponse!,
                                            );
                                            _isLoading = false;
                                            setState(() {});
                                          } else {
                                            // Reset translation if same language reselected
                                            if (translatedCropSuggestionMap !=
                                                null) {
                                              translatedCropSuggestionMap![
                                                      "selectedLocale"] =
                                                  (recommendationsForCropProvider
                                                          .recommendationsForCropResponse!
                                                          .languageCode ??
                                                      "en");
                                              setState(() {});
                                            }
                                          }
                                        },
                                  icon: Icon(Icons.translate,
                                      size: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  label: Text(
                                    AppStrings.translate.tr(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // All crop recommendation sections
                            SoilTypeCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                            const SizedBox(height: 16),
                            WateringCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                            const SizedBox(height: 16),
                            PlantingTipsCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                            const SizedBox(height: 16),
                            CommonPestsCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                            const SizedBox(height: 16),
                            PesticideCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                            const SizedBox(height: 16),
                            FertilizationCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                            const SizedBox(height: 16),
                            HarvestingCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                            const SizedBox(height: 16),
                            StorageCard(
                                recommendationsForCropResponse:
                                    cropSuggestionResponse!),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
