// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:agro_vision/models/drawer_item_model.dart';
import 'package:agro_vision/models/user_data_model.dart';
import 'package:agro_vision/providers/connectivity_provider.dart';
import 'package:agro_vision/services/current_market_price_api/models/current_market_price_response_model.dart';
import 'package:agro_vision/services/firebase_service/firebase_storage_class.dart';
import 'package:agro_vision/services/firebase_service/firestore_service.dart';
import 'package:agro_vision/services/location_service/location_service.dart';
import 'package:agro_vision/services/translation_service.dart';
import 'package:agro_vision/services/weather_api/models/weather_forecast_api_response_model.dart';
import 'package:agro_vision/services/weather_api/models/weather_forecast_day_model.dart';
import 'package:agro_vision/services/weather_api/weather_api_client.dart';
import 'package:agro_vision/services/weather_history_api/models/hourly_humidity_weather_history_response_model.dart';
import 'package:agro_vision/services/weather_history_api/models/temperature_rainfall_weather_history_response_model.dart';
import 'package:agro_vision/services/weather_history_api/weather_history_api_client.dart';
import 'package:agro_vision/utils/constants.dart';
import 'package:agro_vision/utils/enums.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MainProvider extends ChangeNotifier {
  // Injected connectivity provider for checking internet status
  final ConnectivityProvider connectivityProvider;

  // Service instances
  TranslationService translationService = TranslationService();

  // Theme and weather data
  ThemeModeApp themeModeApp = ThemeModeApp.system;
  WeatherForecastApiResponseModel? weatherForecastApiResponse;
  HourlyHumidityWeatherHistoryResponseModel?
      hourlyHumidityWeatherHistoryResponse;
  TemperatureRainfallWeatherHistoryResponseModel?
      temperatureRainfallWeatherHistoryResponse;

  // Error messages
  String? weatherResponseErrorMsg;
  String? hourlyHumidityWeatherHistoryErrorMsg;
  String? temperatureRainfallWeatherHistoryErrorMsg;

  // Historical data averages
  List<double> monthsHumidityAverageList = [];
  List<double> monthsTemperatureAverageList = [];
  List<double> monthsRainfallAverageList = [];

  // Location and crop data
  LatLng? _usedLocation;
  DateTime? _usedPlantationDate;
  String? _selectedSampleCrop;

  // Market price data
  CurrentMarketPriceResponseModel? currentMarketPriceResponse;
  String? currentMarketPriceResposeErrorMsg;

  // Drawer and UI states
  List<DrawerItemModel> _drawerItemList = [];
  int? _selectedDrawerItemIndex;

  // User-related states
  UserDataModel? _currentUserData;
  User? _currentFirebaseUser;
  XFile? _selectedProfileImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isEmailVerificationSended = false;
  bool _isUserLoading = false;

  // Getters
  LatLng? get usedLocation => _usedLocation;
  DateTime? get usedPlantationDate => _usedPlantationDate;
  String? get selectedSampleCrop => _selectedSampleCrop;
  List<DrawerItemModel> get drawerItemList => _drawerItemList;
  int? get selectedDrawerItemIndex => _selectedDrawerItemIndex;
  User? get currentFirebaseUser => _currentFirebaseUser;
  UserDataModel? get currentUserData => _currentUserData;
  XFile? get selectedProfileImage => _selectedProfileImage;
  bool get isEmailVerificationSended => _isEmailVerificationSended;
  bool get isUserLoading => _isUserLoading;

  MainProvider(this.connectivityProvider) {
    _loadMainProvider();
  }

  // Sets the current theme mode
  void setThemeModeApp(ThemeModeApp themeModeApp) {
    this.themeModeApp = themeModeApp;
    notifyListeners();
  }

  // Loads initial values: theme and user
  _loadMainProvider() async {
    _isUserLoading = true;
    notifyListeners();
    await _loadThemeModeApp();
    await _loadUserData();
    await _loadCurrentFirebaseUser();
  }

  // Loads saved theme from local storage
  Future<void> _loadThemeModeApp() async {
    var themeStringValue = await AppFunctions.getSharedPreferenceString(
        key: AppConstants.themeModeKey);
    themeModeApp = AppFunctions.themeModeFromString(themeStringValue);
    notifyListeners();
  }

  // Loads current weather data based on user's location
  Future<void> getLocationAndLoadWeatherResponse(BuildContext context) async {
    Position position;
    if (!await connectivityProvider.checkInternetConnection()) {
      // Load cached weather if no internet
      var cachedWeatherJsonString =
          await AppFunctions.getSharedPreferenceString(
              key: AppConstants.weatherPrefKey);
      if (cachedWeatherJsonString.isNotEmpty) {
        var weatherApiResponseMap = jsonDecode(cachedWeatherJsonString);
        weatherForecastApiResponse =
            WeatherForecastApiResponseModel.fromJson(weatherApiResponseMap);
        weatherResponseErrorMsg = null;
        notifyListeners();
      }
    } else {
      try {
        // Fetch weather from API
        position = await LocationService().determinePosition();
        weatherForecastApiResponse = await WeatherApiClient().getWeather(
            latitude: position.latitude, longitude: position.longitude);

        // Translate weather condition text
        List<WeatherForecastDayModel> translatedWeatherForecastDayList = [];
        for (WeatherForecastDayModel day
            in weatherForecastApiResponse?.forecast?.forecastday ?? []) {
          WeatherForecastDayModel translatedDay = day.copyWith(
            day: day.day?.copyWith(
              condition: day.day?.condition?.copyWith(
                text: await translationService.translate(
                    day.day?.condition?.text ?? "",
                    AppFunctions.getCurrentLanguageCode(context)),
              ),
            ),
          );
          translatedWeatherForecastDayList.add(translatedDay);
        }

        // Translate current condition text
        weatherForecastApiResponse = weatherForecastApiResponse!.copyWith(
          current: weatherForecastApiResponse!.current.copyWith(
            condition: weatherForecastApiResponse!.current.condition!.copyWith(
              text: await translationService.translate(
                  weatherForecastApiResponse!.current.condition?.text ?? "",
                  AppFunctions.getCurrentLanguageCode(context)),
            ),
          ),
          forecast: weatherForecastApiResponse!.forecast!.copyWith(
            forecastday: translatedWeatherForecastDayList,
          ),
        );

        // Save to cache
        AppFunctions.setSharedPreferenceString(
            key: AppConstants.weatherPrefKey,
            value: jsonEncode(weatherForecastApiResponse!.toJson()));
        weatherResponseErrorMsg = null;
        notifyListeners();
      } on Exception catch (e) {
        weatherResponseErrorMsg = e.toString();
        if (kDebugMode) debugPrint(weatherResponseErrorMsg);
        notifyListeners();
      }
    }
  }

  // Load historical humidity weather data
  getLocationAndLoadHourlyHumidityWeatherHistoryResponse({
    required LatLng selectedLocation,
    required DateTime selectedPlantationDate,
  }) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    _usedLocation = selectedLocation;
    _usedPlantationDate = selectedPlantationDate;

    if (!await connectivityProvider.checkInternetConnection()) {
      hourlyHumidityWeatherHistoryErrorMsg = "Network Error!";
    } else {
      try {
        var startDate = dateFormat.format(DateTime(
            _usedPlantationDate!.year - 1,
            _usedPlantationDate!.month,
            _usedPlantationDate!.day));
        var endDate = dateFormat.format(DateTime(_usedPlantationDate!.year,
            _usedPlantationDate!.month, _usedPlantationDate!.day - 1));

        hourlyHumidityWeatherHistoryResponse = await WeatherHistoryApiClient()
            .getHourlyHumidityWeatherHistory(
                latitude: selectedLocation.latitude,
                longitude: selectedLocation.longitude,
                startDate: startDate,
                endDate: endDate);

        monthsHumidityAverageList = AppFunctions.calculateAverageHumidity(
            hourlyHumidityList: hourlyHumidityWeatherHistoryResponse
                    ?.hourly?.relative_humidity_2m ??
                []);
        hourlyHumidityWeatherHistoryErrorMsg = null;
        notifyListeners();
      } catch (e) {
        hourlyHumidityWeatherHistoryErrorMsg = e.toString();
        if (kDebugMode) debugPrint(hourlyHumidityWeatherHistoryErrorMsg);
        notifyListeners();
      }
    }
  }

  // Load historical temperature and rainfall weather data
  getLocationAndLoadTemperatureRainfallWeatherHistoryResponse({
    required LatLng selectedLocation,
    required DateTime selectedPlantationDate,
  }) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    _usedLocation = selectedLocation;
    _usedPlantationDate = selectedPlantationDate;

    if (!await connectivityProvider.checkInternetConnection()) {
      temperatureRainfallWeatherHistoryErrorMsg = "Network Error!";
    } else {
      try {
        var startDate = dateFormat.format(DateTime(
            _usedPlantationDate!.year - 1,
            _usedPlantationDate!.month,
            _usedPlantationDate!.day));
        var endDate = dateFormat.format(DateTime(_usedPlantationDate!.year,
            _usedPlantationDate!.month, _usedPlantationDate!.day - 1));

        temperatureRainfallWeatherHistoryResponse =
            await WeatherHistoryApiClient()
                .getTemperatureRainfallWeatherHistory(
                    latitude: selectedLocation.latitude,
                    longitude: selectedLocation.longitude,
                    startDate: startDate,
                    endDate: endDate);

        monthsTemperatureAverageList = AppFunctions.calculateAverageTemperature(
            list: temperatureRainfallWeatherHistoryResponse
                    ?.daily?.temperature_2m_mean ??
                []);
        monthsRainfallAverageList = AppFunctions.calculateRainfallMonthlySum(
            list: temperatureRainfallWeatherHistoryResponse?.daily?.rain_sum ??
                []);
        temperatureRainfallWeatherHistoryErrorMsg = null;
        notifyListeners();
      } catch (e) {
        temperatureRainfallWeatherHistoryErrorMsg = e.toString();
        if (kDebugMode) debugPrint(temperatureRainfallWeatherHistoryErrorMsg);
        notifyListeners();
      }
    }
  }

  // Set selected sample crop
  setSampleCrop({required String? crop}) {
    _selectedSampleCrop = crop;
    if (crop != null) notifyListeners();
  }

  // Set selected drawer index
  setSelectedDrawerItemIndex({required int? selectedIndex}) {
    _selectedDrawerItemIndex = selectedIndex;
    notifyListeners();
  }

  // Set drawer items (once)
  setDrawerItemList({required List<DrawerItemModel> drawerItemList}) {
    if (_drawerItemList.isEmpty) {
      _drawerItemList = drawerItemList;
      notifyListeners();
    }
  }

  // Add user data to Firestore
  addUserData({
    required UserDataModel userData,
    required Function() onUserDataAdded,
    required Function() onError,
  }) async {
    try {
      await FirestoreService.addUserData(
          userData: userData, onUserDataAdded: onUserDataAdded);
    } catch (e) {
      if (kDebugMode) debugPrint("Error adding userData: $e");
      onError();
    }
  }

  // Update user data in Firestore
  updateUserData({
    required UserDataModel userData,
    required Function() onUserDataUpdated,
    required Function() onError,
  }) async {
    try {
      await FirestoreService.updateUserData(
          userData: userData, onUserDataUpdated: onUserDataUpdated);
    } catch (e) {
      if (kDebugMode) debugPrint("Error updating userData: $e");
      onError();
    }
  }

  // Load user data from Firestore by ID
  _loadUserData() async {
    try {
      Map<String, dynamic> fallback = UserDataModel(
              name: "",
              email: "",
              image: "",
              imageFileName: "",
              lastTimeRequestsUpdated: DateTime.now())
          .toJson();

      FirestoreService.getUserDataById().listen((doc) {
        _currentUserData = UserDataModel.fromJson(doc.data() ?? fallback);
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) debugPrint("Error fetching user data: $e");
    }
  }

  // Upload profile image to Firebase Storage
  Future<String> uploadProfileImage({
    required File imageFile,
    required String imageFileName,
    required Function(String) onError,
  }) async {
    try {
      return await FirebaseStorageClass.uploadImage(
        imageFile: imageFile,
        folderPath: AppConstants.profileImages,
        fileName: imageFileName,
      );
    } catch (e) {
      if (kDebugMode) debugPrint("Upload error: $e");
      onError(e.toString());
      return Future.error("Upload error: $e");
    }
  }

  // Delete profile image from Firebase Storage
  deleteProfileImage({
    required String imageFileName,
    required Function(String) onError,
  }) async {
    try {
      await FirebaseStorageClass.deleteImage(
          filePath: "${AppConstants.profileImages}/$imageFileName");
    } catch (e) {
      if (kDebugMode) debugPrint("Delete error: $e");
      onError(e.toString());
    }
  }

  // Update profile image by deleting the old one and uploading a new one
  Future<String> updateProfileImage({
    required oldImageFileName,
    required File newImageFile,
    required String newImageFileName,
    required Function(String) onError,
  }) async {
    try {
      await deleteProfileImage(
          imageFileName: oldImageFileName, onError: (_) {});
      return await uploadProfileImage(
        imageFile: newImageFile,
        imageFileName: newImageFileName,
        onError: onError,
      );
    } catch (e) {
      if (kDebugMode) debugPrint("Update image error: $e");
      return Future.error("Update image error: $e");
    }
  }

  // Set the picked profile image from gallery
  setSelectedProfileImage({required XFile? image}) {
    _selectedProfileImage = image;
    notifyListeners();
  }

  // Request permission before accessing media
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted || (await permission.request()).isGranted;
  }

  // Pick image from gallery
  pickImageFromGallery() async {
    final hasPermission = await requestPermission(Permission.photos);
    if (hasPermission) {
      try {
        final XFile? image =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          _selectedProfileImage = image;
          notifyListeners();
        }
      } catch (e) {
        if (kDebugMode) debugPrint("Error picking image: $e");
      }
    } else {
      if (kDebugMode) debugPrint("Gallery permission denied!");
    }
  }

  // Clear selected profile image
  clearProfileImage() {
    _selectedProfileImage = null;
    notifyListeners();
  }

  // Set email verification status
  setIsEmailVerificationSended(bool isSent) {
    _isEmailVerificationSended = isSent;
    notifyListeners();
  }

  // Load current Firebase user
  _loadCurrentFirebaseUser() {
    _isUserLoading = true;
    notifyListeners();
    try {
      FirebaseAuth.instance.userChanges().listen((currentUser) {
        _currentFirebaseUser = currentUser;
        _isUserLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isUserLoading = false;
      notifyListeners();
      if (kDebugMode) debugPrint("Error loading firebase user!");
    }
  }
}
