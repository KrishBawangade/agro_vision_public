// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/services/firebase_service/firestore_service.dart';
import 'package:agro_vision/services/gemini_service/generative_ai_service.dart';
import 'package:agro_vision/services/gemini_service/models/recommendations_for_crop_response_model.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RecommendationsForCropProvider extends ChangeNotifier {
  RecommendationsForCropProvider() {
    _loadRecommendationsForCropList();
  }

  RecommendationsForCropResponseModel? _recommendationsForCropResponse;
  List<RecommendationsForCropResponseModel> _recommendationsForCropList = [];
  bool _isLoading = false;

  // Completer to wait until Firestore data is initially loaded
  final Completer<void> _dataLoadedCompleter = Completer<void>();

  // Public getters
  RecommendationsForCropResponseModel? get recommendationsForCropResponse =>
      _recommendationsForCropResponse;
  List<RecommendationsForCropResponseModel> get recommendationsForCropList =>
      _recommendationsForCropList;
  bool get isLoading => _isLoading;

  // Generates AI-based crop recommendations and saves to Firestore
  Future<void> _generateAndAddRecommendationsForCrop({
    required String cropName,
    required BuildContext context,
  }) async {
    try {
      final currentLanguageCode = AppFunctions.getCurrentLanguageCode(context);

      // Generate response using Gemini AI (Generative AI)
      final output = await GenerativeAiService.generateRecommendationsForCrop(
        cropName: cropName,
        currentLanguage: AppFunctions.getLanguageName(currentLanguageCode),
      );

      // Decode and assign metadata
      _recommendationsForCropResponse =
          RecommendationsForCropResponseModel.fromJson(jsonDecode(output));
      _recommendationsForCropResponse!.id = const Uuid().v4();
      _recommendationsForCropResponse!.userId =
          FirebaseAuth.instance.currentUser?.uid ?? "";
      _recommendationsForCropResponse!.languageCode = currentLanguageCode;

      // Add to Firestore
      await FirestoreService.addRecommendationsForCrop(
        recommendationsForCropResponse: _recommendationsForCropResponse!,
        onRecommendationsAdded: () {},
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error generating recommendations for crop: $e");
      }
    }
  }

  // Load a recommendation from Firestore or generate if not present
  Future<void> loadRecommendationsForCrop({
    required String cropName,
    required BuildContext context,
  }) async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    // Wait for Firestore list to finish loading
    await _dataLoadedCompleter.future;

    int recommendationsIndex = 0;

    // Check if crop recommendation already exists locally
    final hasRecommendations = _recommendationsForCropList.any((item) {
      final isMatch = item.crop_name.toLowerCase() == cropName.toLowerCase();
      if (isMatch) {
        recommendationsIndex = _recommendationsForCropList.indexOf(item);
      }
      return isMatch;
    });

    if (hasRecommendations) {
      _recommendationsForCropResponse =
          _recommendationsForCropList[recommendationsIndex];
      _isLoading = false;
      notifyListeners();
    } else {
      // Check if 24 hours passed since last crop suggestion request
      final is24HrPassed = AppFunctions.is24HoursPassedSince(
        mainProvider.currentUserData?.lastTimeRequestsUpdated ?? DateTime(2000),
      );

      // Check if user has requests left or 24 hours passed
      if ((mainProvider.currentUserData?.cropSuggestionsRequestsLeft ?? 0) > 0 ||
          is24HrPassed) {
        await _generateAndAddRecommendationsForCrop(
          cropName: cropName,
          context: context,
        );
      } else {
        // Show limit warning if not allowed
        AppFunctions.showSnackBar(
          context: context,
          msg: AppStrings.cropSuggestionsRequestsLimitReachedMessage.tr(),
          duration: const Duration(seconds: 4),
        );
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  // Loads list of all crop recommendations from Firestore
  Future<void> _loadRecommendationsForCropList() async {
    try {
      FirestoreService.getRecommendationsForCropList().listen((snapshot) {
        _recommendationsForCropList = snapshot.docs.map((doc) {
          return RecommendationsForCropResponseModel.fromJson(doc.data());
        }).toList();

        // Mark data load as complete (for future `await _dataLoadedCompleter.future`)
        if (!_dataLoadedCompleter.isCompleted) {
          _dataLoadedCompleter.complete();
        }

        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error fetching recommendations for crop: $e");
      }
      notifyListeners();
    }
  }
}
