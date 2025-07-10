// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/providers/crop_calendar_provider.dart';
import 'package:agro_vision/services/firebase_service/firestore_service.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_response_model.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FarmPlotProvider extends ChangeNotifier {
  final CropCalendarProvider cropCalendarProvider;

  // Constructor - loads initial farm plot list
  FarmPlotProvider({required this.cropCalendarProvider}) {
    _loadFarmPlotList();
  }

  List<FarmPlotModel> _farmPlotList = [];
  List<String> _cropList = [];
  bool _isLoading = false;
  String _recommendedCrop = "";
  String _loadingMessage = AppStrings.pleaseWaitMessage.tr();
  DateTime _selectedPlantationDate = DateTime.now();
  String _localizedCropResponse = "";

  // Getters
  List<FarmPlotModel> get farmPlotList => _farmPlotList;
  List<String> get cropList => _cropList;
  bool get isLoading => _isLoading;
  String get recommendedCrop => _recommendedCrop;
  String get loadingMessage => _loadingMessage;
  String get localizedCropResponse => _localizedCropResponse;
  DateTime get selectedPlantationDate => _selectedPlantationDate;

  // Setter for recommended crop
  setRecommendedCrop({required String cropName}) {
    _recommendedCrop = cropName;
    notifyListeners();
  }

  // Setter for selected plantation date
  setSelectedPlantationDate({required DateTime selectedPlantationDate}) {
    _selectedPlantationDate = selectedPlantationDate;
    notifyListeners();
  }

  // Add a farm plot and optionally generate crop calendar
  addFarmPlot({
    required FarmPlotModel farmPlot,
    required BuildContext context,
    required String currentLanguageName,
    required bool shouldGenerateCropCalendar,
    required onFarmPlotAdded,
    required onError,
  }) async {
    _isLoading = true;
    _loadingMessage = AppStrings.addingFarmPlotMessage.tr();
    notifyListeners();

    try {
      await FirestoreService.addFarmPlot(
        farmPlot: farmPlot,
        onFarmPlotAdded: () async {
          _isLoading = true;
          _loadingMessage = AppStrings.generatingCropCalendarMessage.tr();
          notifyListeners();

          if (shouldGenerateCropCalendar) {
            await cropCalendarProvider.generateAndAddCropCalendarResponse(
              farmPlot: farmPlot,
              currentLanguageName: currentLanguageName,
            );
          } else {
            AppFunctions.showSnackBar(
              context: context,
              msg: AppStrings.cropCalendarRequestsLimitReachedMessage.tr(),
              duration: const Duration(seconds: 4),
            );
          }

          onFarmPlotAdded();
          AppFunctions.showSnackBar(
            context: context,
            msg: AppStrings.farmPlotAddedSuccessMessage.tr(),
          );

          _isLoading = false;
          notifyListeners();
        },
      );
    } on Exception catch (e) {
      if (kDebugMode) debugPrint("Error adding farm plot: $e");
      onError();
      AppFunctions.showSnackBar(
        context: context,
        msg: AppStrings.errorMessage.tr(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing farm plot and regenerate crop calendar if needed
  updateFarmPlot({
    required FarmPlotModel oldFarmPlot,
    required FarmPlotModel newFarmPlot,
    required CropCalendarResponseModel cropCalendar,
    required String currentLanguageName,
    required BuildContext context,
    required Function onFarmPlotUpdated,
    required Function onError,
  }) async {
    _isLoading = true;
    _loadingMessage = "Updating Farm Plot...";
    notifyListeners();

    try {
      await FirestoreService.updateFarmPlot(
        farmPlot: newFarmPlot,
        onFarmPlotUpdated: () async {
          _isLoading = true;
          _loadingMessage = AppStrings.generatingCropCalendarMessage.tr();
          notifyListeners();

          // Check if crop name or plantation date changed
          var oldDateTime = DateTime.fromMicrosecondsSinceEpoch(
              oldFarmPlot.plantationDateMillis);
          var newDateTime = DateTime.fromMicrosecondsSinceEpoch(
              newFarmPlot.plantationDateMillis);
          if (oldFarmPlot.crop != newFarmPlot.crop ||
              (oldDateTime.day != newDateTime.day ||
                  oldDateTime.month != newDateTime.month ||
                  oldDateTime.year != newDateTime.year)) {
            await cropCalendarProvider.generateAndUpdateCropCalendarResponse(
              farmPlot: newFarmPlot,
              cropCalendar: cropCalendar,
              currentLanguageName: currentLanguageName,
            );
          }

          onFarmPlotUpdated();
          AppFunctions.showSnackBar(
            context: context,
            msg: AppStrings.farmPlotUpdatedSuccessMessage.tr(),
          );

          _isLoading = false;
          notifyListeners();
        },
      );
    } on Exception catch (e) {
      if (kDebugMode) debugPrint("Error updating farm plot: $e");
      onError();
      AppFunctions.showSnackBar(
        context: context,
        msg: AppStrings.errorMessage.tr(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a farm plot and optionally its crop calendar
  Future<void> deleteFarmPlot({
    required FarmPlotModel farmPlot,
    required Function() onFarmPlotDeleted,
    required List<CropCalendarResponseModel> cropCalendarResponseList,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool hasAnyCropCalendar = cropCalendarResponseList.any(
        (response) => response.farmPlotId == farmPlot.id,
      );

      if (hasAnyCropCalendar) {
        await FirestoreService.deleteFarmPlotAndCropCalendar(
          farmPlotId: farmPlot.id,
          onFarmPlotAndCropCalendarDeleted: () {
            onFarmPlotDeleted();
          },
        );
      } else {
        await FirestoreService.deleteFarmPlot(
          farmPlot: farmPlot,
          onFarmPlotDeleted: onFarmPlotDeleted,
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) debugPrint("Error deleting farm plot: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Loads farm plot list from Firestore
  _loadFarmPlotList() async {
    _isLoading = true;
    notifyListeners();

    FirestoreService.getFarmPlotList().listen((snapshot) {
      _farmPlotList = snapshot.docs
          .map((doc) => FarmPlotModel.fromJson(doc.data()))
          .toList();
      _isLoading = false;
      notifyListeners();
    }).onError((e) {
      if (kDebugMode) {
        debugPrint("error while fetching farm plot list: ${e.toString()}");
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  // Loads and localizes crop names from asset JSON file
  Future<void> loadCropList(BuildContext context) async {
    _localizedCropResponse =
        await rootBundle.loadString(AppConstants.cropNamesJsonFilePath);
    final Map<String, dynamic> data = jsonDecode(_localizedCropResponse);

    final String localeCode = AppFunctions.getCurrentLanguageCode(context);
    final Map<String, dynamic> localizedCrops = data["cropsLocalized"];

    _cropList = localizedCrops.entries
        .map((e) => (e.value[localeCode] ?? e.key) as String)
        .toList();

    notifyListeners();
  }

  // Returns localized crop name based on user input
  Future<String> getLocalizedCropName(
      String cropNameInput, String localeCode) async {
    final Map<String, dynamic> data = jsonDecode(_localizedCropResponse);
    final Map<String, dynamic> localizedCrops = data["cropsLocalized"];

    String? englishName;

    // Identify English crop name for the given input (which may be localized)
    localizedCrops.forEach((engName, translations) {
      if (engName.toLowerCase() == cropNameInput.toLowerCase()) {
        englishName = engName;
      } else if (translations.values.any(
          (v) => v.toString().toLowerCase() == cropNameInput.toLowerCase())) {
        englishName = engName;
      }
    });

    if (englishName != null) {
      return localizedCrops[englishName!]?[localeCode] ?? englishName!;
    }

    // Fallback to input itself if no translation found
    return cropNameInput;
  }

  // Validates if the crop exists in the available list
  bool isCropValid({required String crop}) {
    var normalizedCropNameQuery = crop.toLowerCase().replaceAll(" ", "");
    for (int i = 0; i < _cropList.length; i++) {
      var normalizedCropItem = _cropList[i].toLowerCase().replaceAll(" ", "");
      if (normalizedCropNameQuery == normalizedCropItem) {
        return true;
      }
    }
    return false;
  }
}
