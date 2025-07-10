import 'dart:convert';
import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/services/firebase_service/firestore_service.dart';
import 'package:agro_vision/services/gemini_service/generative_ai_service.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_item_model.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_response_model.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CropCalendarProvider extends ChangeNotifier {
  CropCalendarProvider() {
    loadCropCalendarList();
  }

  List<CropCalendarResponseModel> _cropCalendarResponseList = [];
  bool _isLoading = false;
  String _selectedFarmPlotId = "";
  String _selectedFarmPlotName = "";
  CropCalendarResponseModel? _selectedCropCalendar;

  List<CropCalendarResponseModel> get cropCalendarResponseList =>
      _cropCalendarResponseList;
  bool get isLoading => _isLoading;
  String get selectedFarmPlotId => _selectedFarmPlotId;
  String get selectedFarmPlotName => _selectedFarmPlotName;
  CropCalendarResponseModel? get selectedCropCalendar => _selectedCropCalendar;

  generateAndAddCropCalendarResponse({
    required FarmPlotModel farmPlot,
    required String currentLanguageName,
    bool hasGeneratedAlone = false,
    Function()? onCropCalendarAdded,
    Function(String)? onError,
  }) async {
    try {
      CropCalendarResponseModel cropCalendarResponse =
          await generateCropCalendarResponse(
              farmPlot: farmPlot, currentLanguageName: currentLanguageName);

      cropCalendarResponse.languageCode =
          AppFunctions.getLanguageCodeByName(currentLanguageName);

      try {
        await FirestoreService.addCropCalendar(
          cropCalendarResponse: cropCalendarResponse,
          onCropCalendarAdded: () {
            if (onCropCalendarAdded != null) {
              onCropCalendarAdded();
            }
          },
        );

        if (hasGeneratedAlone) {
          _selectedCropCalendar = cropCalendarResponse;
        }
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Error adding crop calendar to Firestore: $e");
        }
        if (onError != null) {
          onError(AppStrings.errorMessage.tr());
        }
        return Future.error("Failed to save crop calendar. Please try again.");
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error generating crop calendar: $e");
      }
      if (onError != null) {
        onError(AppStrings.errorMessage.tr());
      }
      return Future.error(
          "Failed to generate crop calendar. Please try again.");
    }
  }

  generateAndUpdateCropCalendarResponse({
    required FarmPlotModel farmPlot,
    required CropCalendarResponseModel cropCalendar,
    required String currentLanguageName,
  }) async {
    try {
      CropCalendarResponseModel cropCalendarResponse =
          await generateCropCalendarResponse(
              farmPlot: farmPlot, currentLanguageName: currentLanguageName);

      cropCalendarResponse.id = cropCalendar.id;

      try {
        await FirestoreService.updateCropCalendar(
          cropCalendarResponse: cropCalendarResponse,
          onCropCalendarUpdated: () {},
        );
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Error updating crop calendar in Firestore: $e");
        }
        return Future.error(
            "Failed to update crop calendar. Please try again.");
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error generating crop calendar: $e");
      }
      return Future.error(
          "Failed to generate crop calendar. Please try again.");
    }
  }

  generateCropCalendarResponse(
      {required FarmPlotModel farmPlot,
      required String currentLanguageName}) async {
    var dateFormat = DateFormat("dd MMM yyyy");
    var formattedPlantationDate = dateFormat.format(
        DateTime.fromMillisecondsSinceEpoch(farmPlot.plantationDateMillis));

    var cropCalendarResponsejson =
        await GenerativeAiService.generateCropCalendar(
            crop: farmPlot.crop.toLowerCase(),
            formattedDate: formattedPlantationDate,
            currentLanguageName: currentLanguageName);

    CropCalendarResponseModel cropCalendarResponse =
        CropCalendarResponseModel.fromJson(
            jsonDecode(cropCalendarResponsejson));

    for (CropCalendarItemModel cropCalendar
        in cropCalendarResponse.crop_calendar) {
      var stageColor = AppFunctions.generateRandomColor();
      var stageColorHexString = AppFunctions.colorToHexString(stageColor);
      cropCalendar.colorHexString = stageColorHexString;
    }
    cropCalendarResponse.id = const Uuid().v4();
    cropCalendarResponse.farmPlotId = farmPlot.id;
    cropCalendarResponse.userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    return cropCalendarResponse;
  }

  getCropCalendarByFarmPlotId({required farmPlotId}) {
    return cropCalendarResponseList
        .firstWhere((cropCalendar) => cropCalendar.farmPlotId == farmPlotId);
  }

  setSelectedFarmPlotIdAndName(
      {required String farmPlotId, required String? farmPlotName}) {
    _selectedFarmPlotId = farmPlotId;
    _selectedCropCalendar = null;
    _selectedFarmPlotName = farmPlotName ?? "";
    for (int i = 0; i < cropCalendarResponseList.length; i++) {
      var cropCalendarResponse = cropCalendarResponseList[i];

      if (cropCalendarResponse.farmPlotId == farmPlotId) {
        _selectedCropCalendar = cropCalendarResponse;
        notifyListeners();
        return;
      }
    }
    notifyListeners();
  }

  setSelectedFarmPlotIdAndNameListenFalse(
      {required String farmPlotId, required String? farmPlotName}) {
    _selectedFarmPlotId = farmPlotId;
    _selectedFarmPlotName = farmPlotName ?? "";
    for (int i = 0; i < cropCalendarResponseList.length; i++) {
      var cropCalendarResponse = cropCalendarResponseList[i];
      if (cropCalendarResponse.farmPlotId == farmPlotId) {
        _selectedCropCalendar = cropCalendarResponse;
        return;
      }
    }
  }

  loadCropCalendarList() {
    _isLoading = true;
    notifyListeners();
    FirestoreService.getCropCalendarReponseList().listen((snapshot) {
      _cropCalendarResponseList = snapshot.docs.map((doc) {
        return CropCalendarResponseModel.fromJson(doc.data());
      }).toList();
      _isLoading = false;

      notifyListeners();
    }).onError((e) {
      if (kDebugMode) {
        debugPrint("Error fetching the crop calendars : $e");
      }
      _isLoading = false;
      notifyListeners();
    });
  }
}
