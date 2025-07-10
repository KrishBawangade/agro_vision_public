// ignore_for_file: unnecessary_getters_setters

import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_item_model.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_response_model.dart';
import 'package:agro_vision/services/gemini_service/models/fertilization_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/growing_condition_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/harvesting_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/pest_management_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/pesticides_recommendation_model.dart';
import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:agro_vision/services/translation_service.dart';
import 'package:flutter/material.dart';

class TranslationProvider extends ChangeNotifier {
  // Instance of TranslationService to handle all text translations
  final TranslationService _translationService = TranslationService();

  // 🔹 State for Crop Calendar Translations
  final List<CropCalendarResponseModel> _translatedCropCalendarResponseList =
      [];
  // Keeps track of which CropCalendar has been translated to which locale
  final List<Map<String, String>> _isTranslatedCropCalendarList = [];
  // Holds the currently selected translated CropCalendar for UI
  CropCalendarResponseModel? _selectedLocaleCropCalendarResponse;

  // 🔹 State for Crop Suggestion Translations
  final List<RecommendationsForCropResponseModel>
      _translatedCropSuggestionsList = [];
  // Keeps track of which CropSuggestion has been translated to which locale
  final List<Map<String, String>> _isTranslatedCropSuggestionsList = [];
  // Holds the currently selected translated CropSuggestion for UI
  RecommendationsForCropResponseModel? _selectedLocaleCropSuggestion;

  // 🔹 State for FarmPlot Translations
  final List<Map<String, dynamic>> _isTranslatedFarmPlotsList = [];
  // Holds the currently selected translated FarmPlot list for UI
  Map<String, dynamic>? _selectedLocaleFarmPlotList;

  // 🔹 Getters for crop calendar
  List<CropCalendarResponseModel> get translatedCropCalendarResponseList =>
      _translatedCropCalendarResponseList;
  List<Map<String, String>> get isTranslatedCropCalendarList =>
      _isTranslatedCropCalendarList;
  CropCalendarResponseModel? get selectedLocaleCropCalendarResponse =>
      _selectedLocaleCropCalendarResponse;

  // 🔹 Getters for crop suggestions
  List<RecommendationsForCropResponseModel> get translatedCropSuggestionsList =>
      _translatedCropSuggestionsList;
  List<Map<String, String>> get isTranslatedCropSuggestionsList =>
      _isTranslatedCropSuggestionsList;
  RecommendationsForCropResponseModel? get selectedLocaleCropSuggestion =>
      _selectedLocaleCropSuggestion;

  // 🔹 Getters for farm plot
  List<Map<String, dynamic>> get isTranslatedFarmPlotsList =>
      _isTranslatedFarmPlotsList;
  Map<String, dynamic>? get selectedLocaleFarmPlot =>
      _selectedLocaleFarmPlotList;

  // 🔹 Setters to update selected translated crop calendar
  set selectedLocaleCropCalendarResponse(
      CropCalendarResponseModel? cropCalendarResponse) {
    _selectedLocaleCropCalendarResponse = cropCalendarResponse;
  }

  // 🔹 Setters to update selected translated crop suggestion
  set selectedLocaleCropSuggestion(
      RecommendationsForCropResponseModel? cropSuggestion) {
    _selectedLocaleCropSuggestion = cropSuggestion;
  }

  // 🔹 Translate a CropCalendarResponseModel to a selected locale
  Future<void> translateCropCalendar({
    required String selectedLocale,
    required CropCalendarResponseModel cropCalendarResponse,
  }) async {
    Map<String, String>? isTranslatedCropCalendarMap;

    // Check if this crop calendar has already been translated
    _isTranslatedCropCalendarList.any((isTranslatedMap) {
      bool matched = isTranslatedMap["id"] == cropCalendarResponse.id;
      if (matched) {
        isTranslatedCropCalendarMap = isTranslatedMap;
      }
      return matched;
    });

    // If no translation exists or locale has changed, create/update it
    if (isTranslatedCropCalendarMap == null ||
        isTranslatedCropCalendarMap?["selectedLocale"] != selectedLocale) {
      if (isTranslatedCropCalendarMap == null) {
        isTranslatedCropCalendarMap = {
          "id": cropCalendarResponse.id,
          "selectedLocale": selectedLocale,
        };
        _isTranslatedCropCalendarList.add(isTranslatedCropCalendarMap!);
      } else {
        isTranslatedCropCalendarMap!["selectedLocale"] = selectedLocale;
      }

      // Check if a translated version is already stored
      bool hasLocaleCropCalendar =
          _translatedCropCalendarResponseList.any((cropCalendar) {
        bool hasTranslation = cropCalendar.id == cropCalendarResponse.id &&
            cropCalendar.languageCode == selectedLocale;
        if (hasTranslation) {
          _selectedLocaleCropCalendarResponse = cropCalendar;
        }
        return hasTranslation;
      });

      // If not translated yet, translate and store it
      if (!hasLocaleCropCalendar) {
        CropCalendarResponseModel translatedCropCalendar =
            await _translateAddCropCalendarResponse(
          cropCalendarResponse: cropCalendarResponse,
          selectedLocale: selectedLocale,
        );
        _selectedLocaleCropCalendarResponse = translatedCropCalendar;
      }

      notifyListeners(); // Notify UI listeners of state change
    }
  }

  // 🔹 Translate and return a CropCalendarResponseModel
  Future<CropCalendarResponseModel> _translateAddCropCalendarResponse({
    required String selectedLocale,
    required CropCalendarResponseModel cropCalendarResponse,
  }) async {
    List<CropCalendarItemModel> translatedCropCalendarItemList = [];

    // Translate each stage and its description
    for (CropCalendarItemModel cropCalendarItem
        in cropCalendarResponse.crop_calendar) {
      CropCalendarItemModel translatedCropCalendarItem =
          cropCalendarItem.copyWith(
        stage: await _translationService.translate(
            cropCalendarItem.stage, selectedLocale),
        stage_description: await _translationService.translate(
            cropCalendarItem.stage_description, selectedLocale),
      );
      translatedCropCalendarItemList.add(translatedCropCalendarItem);
    }

    // Translate crop name and update the language code
    CropCalendarResponseModel translatedCropCalendarResponse =
        cropCalendarResponse.copyWith(
      crop: await _translationService.translate(
          cropCalendarResponse.crop, selectedLocale),
      crop_calendar: translatedCropCalendarItemList,
      languageCode: selectedLocale,
    );

    _translatedCropCalendarResponseList.add(translatedCropCalendarResponse);
    return translatedCropCalendarResponse;
  }

  // 🔹 Translate a RecommendationsForCropResponseModel to a selected locale
  Future<void> translateCropSuggestion({
    required String selectedLocale,
    required RecommendationsForCropResponseModel cropSuggestion,
  }) async {
    Map<String, String>? isTranslatedCropSuggestionMap;

    // Check if this suggestion is already translated
    _isTranslatedCropSuggestionsList.any((isTranslatedMap) {
      bool matched = isTranslatedMap["id"] == cropSuggestion.id;
      if (matched) {
        isTranslatedCropSuggestionMap = isTranslatedMap;
      }
      return matched;
    });

    // Add or update translation record
    if (isTranslatedCropSuggestionMap == null ||
        isTranslatedCropSuggestionMap?["selectedLocale"] != selectedLocale) {
      if (isTranslatedCropSuggestionMap == null) {
        isTranslatedCropSuggestionMap = {
          "id": cropSuggestion.id,
          "selectedLocale": selectedLocale,
        };
        _isTranslatedCropSuggestionsList.add(isTranslatedCropSuggestionMap!);
      } else {
        isTranslatedCropSuggestionMap!["selectedLocale"] = selectedLocale;
      }

      // Check if already translated
      bool hasLocaleCropSuggestion =
          _translatedCropSuggestionsList.any((suggestion) {
        bool hasTranslation = suggestion.id == cropSuggestion.id &&
            suggestion.languageCode == selectedLocale;
        if (hasTranslation) {
          _selectedLocaleCropSuggestion = suggestion;
        }
        return hasTranslation;
      });

      // If not translated yet, perform translation
      if (!hasLocaleCropSuggestion) {
        RecommendationsForCropResponseModel translatedCropSuggestion =
            await _translateAddCropSuggestion(
          cropSuggestion: cropSuggestion,
          selectedLocale: selectedLocale,
        );

        _selectedLocaleCropSuggestion = translatedCropSuggestion;
      }

      notifyListeners(); // Notify listeners of updated translation
    }
  }

  // 🔹 Translate and return a full RecommendationsForCropResponseModel
  Future<RecommendationsForCropResponseModel> _translateAddCropSuggestion({
    required String selectedLocale,
    required RecommendationsForCropResponseModel cropSuggestion,
  }) async {
    List<String> translatedCommonPestsList = [];
    List<PesticidesRecommendationModel> translatedPesticidesList = [];
    List<String> translatedPlantingTips = [];

    // Translate common pests
    for (String commonPest in cropSuggestion.pest_management.common_pests) {
      translatedCommonPestsList
          .add(await _translationService.translate(commonPest, selectedLocale));
    }

    // Translate pesticides
    for (PesticidesRecommendationModel pesticide
        in cropSuggestion.pest_management.pesticides) {
      PesticidesRecommendationModel translatedPesticide =
          PesticidesRecommendationModel(
        name:
            await _translationService.translate(pesticide.name, selectedLocale),
        usage: await _translationService.translate(
            pesticide.usage, selectedLocale),
      );
      translatedPesticidesList.add(translatedPesticide);
    }

    // Translate planting tips
    for (String plantingTip in cropSuggestion.planting_tips) {
      translatedPlantingTips.add(
          await _translationService.translate(plantingTip, selectedLocale));
    }

    // Construct translated Pest Management section
    PestManagementRecommendationModel translatedPestManagementRecommendation =
        PestManagementRecommendationModel(
            common_pests: translatedCommonPestsList,
            pesticides: translatedPesticidesList);

    // Construct translated full crop suggestion
    RecommendationsForCropResponseModel translatedCropSuggestion =
        cropSuggestion.copyWith(
      crop_name: await _translationService.translate(
          cropSuggestion.crop_name, selectedLocale),
      growing_conditions: GrowingConditionRecommendationModel(
        soil_type: await _translationService.translate(
            cropSuggestion.growing_conditions.soil_type, selectedLocale),
        watering: await _translationService.translate(
            cropSuggestion.growing_conditions.watering, selectedLocale),
      ),
      fertilization: FertilizationRecommendationModel(
        frequency: await _translationService.translate(
            cropSuggestion.fertilization.frequency, selectedLocale),
        type: await _translationService.translate(
            cropSuggestion.fertilization.type, selectedLocale),
      ),
      harvesting: HarvestingRecommendationModel(
        timing: await _translationService.translate(
            cropSuggestion.harvesting.timing, selectedLocale),
        storage: await _translationService.translate(
            cropSuggestion.harvesting.storage, selectedLocale),
      ),
      pest_management: translatedPestManagementRecommendation,
      planting_tips: translatedPlantingTips,
      languageCode: selectedLocale,
    );

    _translatedCropSuggestionsList.add(translatedCropSuggestion);
    return translatedCropSuggestion;
  }

  // 🔹 Translate list of FarmPlots to selected locale
  Future<void> translateFarmPlotList({
    required String selectedLocale,
    required List<FarmPlotModel> farmPlotList,
    required FarmPlotProvider farmPlotProvider,
  }) async {
    Map<String, dynamic>? isTranslatedFarmPlotListMap;

    // If already in selected locale, no translation needed
    if ((farmPlotList[0].languageCode ?? "en") == selectedLocale) {
      _selectedLocaleFarmPlotList = null;
      notifyListeners();
      return;
    }

    // Check if translation for the locale already exists
    _isTranslatedFarmPlotsList.any((isTranslatedMap) {
      bool matched = isTranslatedMap["selectedLocale"] == selectedLocale;
      if (matched) {
        isTranslatedFarmPlotListMap = isTranslatedMap;
      }
      return matched;
    });

    // Perform translation if not already stored
    if (isTranslatedFarmPlotListMap == null) {
      isTranslatedFarmPlotListMap = {
        "selectedLocale": selectedLocale,
      };

      List<FarmPlotModel> translatedFarmPlots = await _translateAddFarmPlot(
        farmPlotList: farmPlotList,
        selectedLocale: selectedLocale,
        farmPlotProvider: farmPlotProvider,
      );

      isTranslatedFarmPlotListMap!["farmPlotList"] = translatedFarmPlots;
      _selectedLocaleFarmPlotList = isTranslatedFarmPlotListMap;
      _isTranslatedFarmPlotsList.add(isTranslatedFarmPlotListMap!);
    } else {
      _selectedLocaleFarmPlotList = isTranslatedFarmPlotListMap;
    }

    notifyListeners(); // Notify listeners of state change
  }

  // 🔹 Translate crop names in farm plots
  Future<List<FarmPlotModel>> _translateAddFarmPlot({
    required String selectedLocale,
    required List<FarmPlotModel> farmPlotList,
    required FarmPlotProvider farmPlotProvider,
  }) async {
    List<FarmPlotModel> translatedFarmPlots = [];

    for (FarmPlotModel farmPlot in farmPlotList) {
      FarmPlotModel translatedFarmPlot = farmPlot.copyWith(
        crop: await farmPlotProvider.getLocalizedCropName(
            farmPlot.crop, selectedLocale),
      );
      translatedFarmPlots.add(translatedFarmPlot);
    }

    return translatedFarmPlots;
  }
}
