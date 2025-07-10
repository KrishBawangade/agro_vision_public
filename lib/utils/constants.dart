class AppConstants {
  // 🔧 SharedPreferences keys
  static const themeModeKey = "THEMEMODE"; // Stores the selected theme mode (light/dark/system)
  static const weatherPrefKey = "weatherPrefKey"; // Stores cached weather data
  static const marketPriceDetailsKey = "marketPriceDetailsKey"; // Stores market price data
  static const cropCalendarListTranslationPrefKey = "cropCalendarListTranslationPrefKey"; // Stores translated crop calendar IDs
  static const selectedAppLanguagePrefKey = "selectedAppLanguagePrefKey"; // Stores selected app language

  // 🖼️ Asset base paths
  static const baseImagePath = "lib/assets/images"; // Base path for images
  static const baseMlModelsPath = "lib/assets/ml_models"; // Base path for ML models

  // 🌦️ Image assets for weather visuals
  static const temperatureImagePath = "$baseImagePath/temperature.svg";
  static const rainImagePath = "$baseImagePath/rain.svg";
  static const humidityImagePath = "$baseImagePath/humidity.svg";
  static const windImagePath = "$baseImagePath/wind.svg";

  // 🤖 ML Model & config paths
  static const cropRecommendationModelPath = "$baseMlModelsPath/crop_recommendation_model.tflite"; // TFLite crop model
  static const cropNamesJsonFilePath = "lib/assets/json_assets/common_crop_names.json"; // Crop names localization JSON
  static const scalerParamsJsonFilePath = "lib/assets/json_assets/scaler_params.json"; // Scaler parameters for ML
  static const pcaParamsJsonFilePath = "lib/assets/json_assets/pca_params.json"; // PCA parameters for ML

  // 🧱 Soil image assets
  static const clayeySoilImage = "$baseImagePath/clayey_soil_img.jpg";
  static const blackSoilImage = "$baseImagePath/black_soil_img.jpg";
  static const sandyLoamSoilImage = "$baseImagePath/sandy_loam_soil_img.jpg";

  // 📂 Firestore collection/document keys
  static const mainPage = "Main Page";
  static const userData = "User Data";
  static const profileImages = "profileImages";
  static const createdAt = "createdAt";
  static const messages = "Messages";
  static const farmPlots = "farm plots";
  static const cropCalendars = "crop calendars";
  static const recommendationsForCrops = "recommendations for crops";
}
