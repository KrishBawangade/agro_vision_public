import 'dart:convert';

import 'package:agro_vision/providers/connectivity_provider.dart';
import 'package:agro_vision/providers/current_market_price_filter_provider.dart';
import 'package:agro_vision/services/current_market_price_api/current_market_price_api_client.dart';
import 'package:agro_vision/services/current_market_price_api/models/current_market_price_record_model.dart';
import 'package:agro_vision/services/current_market_price_api/models/current_market_price_response_model.dart';
import 'package:agro_vision/services/location_service/location_service.dart';
import 'package:agro_vision/services/translation_service.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:flutter/foundation.dart';

class CropMarketProvider extends ChangeNotifier {
  final ConnectivityProvider connectivityProvider;
  final CurrentMarketPriceFilterProvider filterProvider;

  CropMarketProvider({
    required this.connectivityProvider,
    required this.filterProvider,
  });

  final List<CurrentMarketPriceRecordModel> dummyMarketDetailsList = [
    // Used as placeholder or fallback - for just giving demo
    CurrentMarketPriceRecordModel(
        state: "maharashtra",
        district: "nagpur",
        market: "kampthi",
        commodity: "onion",
        variety: "",
        grade: "FAQ",
        arrival_date: "22/10/2024",
        min_price: "2000",
        max_price: "3000",
        modal_price: "2500"),
    CurrentMarketPriceRecordModel(
        state: "maharashtra",
        district: "nagpur",
        market: "katol",
        commodity: "rice",
        variety: "",
        grade: "FAQ",
        arrival_date: "22/10/2024",
        min_price: "1500",
        max_price: "2000",
        modal_price: "1750"),
    CurrentMarketPriceRecordModel(
        state: "maharashtra",
        district: "nagpur",
        market: "nagpur",
        commodity: "wheat",
        variety: "",
        grade: "FAQ",
        arrival_date: "22/10/2024",
        min_price: "1000",
        max_price: "3000",
        modal_price: "2000"),
    CurrentMarketPriceRecordModel(
        state: "maharashtra",
        district: "nagpur",
        market: "katol",
        commodity: "Arhar",
        variety: "",
        grade: "FAQ",
        arrival_date: "22/10/2024",
        min_price: "2000",
        max_price: "3000",
        modal_price: "2500"),
    CurrentMarketPriceRecordModel(
        state: "maharashtra",
        district: "nagpur",
        market: "kampthi",
        commodity: "mango",
        variety: "",
        grade: "FAQ",
        arrival_date: "22/10/2024",
        min_price: "4000",
        max_price: "5000",
        modal_price: "4500"),
    // ... other dummy entries
  ];

  CurrentMarketPriceResponseModel? _currentMarketPriceResponse;
  List<CurrentMarketPriceRecordModel> _currentMarketPriceRecordList = [];
  final List<String> _availableMarketList = [];

  String? _currentMarketPriceResposeErrorMsg;
  bool _isSearching = false;
  bool _isLoading = false;
  String _searchQuery = "";

  // Getters
  CurrentMarketPriceResponseModel? get currentMarketPriceResponse =>
      _currentMarketPriceResponse;

  List<String> get availableMarketList => _availableMarketList;

  List<CurrentMarketPriceRecordModel> get currentMarketPriceRecordList =>
      _currentMarketPriceRecordList;

  bool get isSearching => _isSearching;

  bool get isLoading => _isLoading;

  String? get currentMarketPriceResposeErrorMsg =>
      _currentMarketPriceResposeErrorMsg;

  String get searchQuery => _searchQuery;

  Future<void> loadCurrentMarketPriceDetails(String currentLanguageCode) async {
    final translationService = TranslationService();
    final locationService = LocationService();

    _isLoading = true;
    notifyListeners();

    try {
      if (await connectivityProvider.checkInternetConnection()) {
        final apiClient = CurrentMarketPriceApiClient();
        final position = await locationService.determinePosition();
        final locationMap =
            await locationService.getDistrictAndStateFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        _currentMarketPriceResponse =
            await apiClient.getCurrentMarketPriceDetails(
          district: locationMap["district"]!,
        );

        _currentMarketPriceResponse?.languageCode = currentLanguageCode;
        _currentMarketPriceRecordList =
            _currentMarketPriceResponse?.records ?? [];

        // Translation if not English
        if (currentLanguageCode != "en") {
          final translated = await Future.wait(
            _currentMarketPriceRecordList.map((record) async {
              return record.copyWith(
                commodity: await translationService.translate(
                  record.commodity ?? "",
                  currentLanguageCode,
                ),
              );
            }),
          );

          _currentMarketPriceRecordList = translated;
          _currentMarketPriceResponse?.records = translated;
        }

        // Cache response
        if (_currentMarketPriceRecordList.isNotEmpty) {
          await AppFunctions.setSharedPreferenceString(
            key: AppConstants.marketPriceDetailsKey,
            value: jsonEncode(_currentMarketPriceResponse!.toJson()),
          );
        } else {
          await _loadFromCacheAndTranslate(currentLanguageCode);
        }
      } else {
        await _loadFromCacheAndTranslate(currentLanguageCode);
      }

      _evaluateAvailableMarketList();
    } catch (e) {
      if (kDebugMode) debugPrint("Market Price Error: $e");
      _currentMarketPriceResposeErrorMsg = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromCacheAndTranslate(String languageCode) async {
    final translationService = TranslationService();
    final cachedData = await AppFunctions.getSharedPreferenceString(
      key: AppConstants.marketPriceDetailsKey,
    );

    if (cachedData.isNotEmpty) {
      _currentMarketPriceResponse = CurrentMarketPriceResponseModel.fromJson(
        jsonDecode(cachedData),
      );
      _currentMarketPriceRecordList =
          _currentMarketPriceResponse?.records ?? [];

      if ((_currentMarketPriceResponse?.languageCode ?? "en") != languageCode) {
        final translated = await Future.wait(
          _currentMarketPriceRecordList.map((record) async {
            return record.copyWith(
              commodity: await translationService.translate(
                record.commodity ?? "",
                languageCode,
              ),
            );
          }),
        );

        _currentMarketPriceRecordList = translated;
        _currentMarketPriceResponse?.records = translated;
      }
    }
  }

  void _evaluateAvailableMarketList() {
    for (final record in _currentMarketPriceRecordList) {
      final market = record.market ?? "";
      if (!_availableMarketList.contains(market)) {
        _availableMarketList.add(market);
      }
    }
  }

  void searchCommodities({required String query}) {
    _searchQuery = query;
    final listToSearch = filterProvider.appliedFilters.isNotEmpty
        ? filterProvider.filteredRecordList
        : _currentMarketPriceResponse?.records ?? [];

    if (query.isEmpty) {
      _currentMarketPriceRecordList = listToSearch;
    } else {
      final normalized = query.toLowerCase().replaceAll(" ", "");
      _currentMarketPriceRecordList = listToSearch.where((record) {
        return record.commodity
                ?.toLowerCase()
                .replaceAll(" ", "")
                .contains(normalized) ??
            false;
      }).toList();
    }

    notifyListeners();
  }

  void applyFilters() {
    if (filterProvider.appliedFilters.isEmpty) {
      filterProvider
          .setFilteredRecordList(_currentMarketPriceResponse?.records ?? []);
      _currentMarketPriceRecordList =
          _currentMarketPriceResponse?.records ?? [];
      if (_isSearching) searchCommodities(query: _searchQuery);
      return;
    }

    final records = _currentMarketPriceResponse?.records ?? [];
    final filtered = records.where((record) {
      for (final filterName in filterProvider.appliedFilters.keys) {
        if (filterName == "market") {
          for (final value in filterProvider.appliedFilters[filterName]!) {
            if (value.contains(record.market ?? "")) return true;
          }
        }
      }
      return false;
    }).toList();

    filterProvider.setFilteredRecordList(filtered);
    _currentMarketPriceRecordList = filtered;

    if (_isSearching) searchCommodities(query: _searchQuery);

    notifyListeners();
  }

  void setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }
}
