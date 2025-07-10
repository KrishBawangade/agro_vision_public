import "dart:convert";

import "package:agro_vision/services/weather_history_api/models/hourly_humidity_weather_history_response_model.dart";
import "package:agro_vision/services/weather_history_api/models/temperature_rainfall_weather_history_response_model.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

class WeatherHistoryApiClient {
  // Base URL for the Open-Meteo weather history API
  final _baseUrl = "https://archive-api.open-meteo.com/v1";

  // 🔹 Get hourly humidity history for a location between given dates
  getHourlyHumidityWeatherHistory({
    required double latitude,
    required double longitude,
    required String startDate, // Format: yyyy-MM-dd
    required String endDate, // Format: yyyy-MM-dd
  }) async {
    // Construct API URL with parameters for humidity data
    final url = Uri.parse(
      "$_baseUrl/archive?latitude=$latitude&longitude=$longitude"
      "&start_date=$startDate&end_date=$endDate"
      "&hourly=relative_humidity_2m&timezone=auto",
    );

    try {
      // Make GET request to fetch hourly humidity history
      final response = await http.get(url);

      // If response is successful, parse and return data
      if (response.statusCode == 200) {
        HourlyHumidityWeatherHistoryResponseModel
            hourlyHumidityWeatherHistoryResponse =
            HourlyHumidityWeatherHistoryResponseModel.fromJson(
          jsonDecode(response.body),
        );
        return hourlyHumidityWeatherHistoryResponse;
      } else {
        // Log and throw error if response code is not 200
        if (kDebugMode) {
          debugPrint(
            "Error: ${response.statusCode} : ${response.reasonPhrase}",
          );
        }
        return Future.error(
          "Error: ${response.statusCode} : ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      // Catch and report any exceptions (e.g., network issues)
      if (kDebugMode) debugPrint("Failed to fetch data: $e");
      return Future.error("Failed to fetch data: $e");
    }
  }

  // 🔹 Get daily average temperature and total rainfall for given date range
  getTemperatureRainfallWeatherHistory({
    required double latitude,
    required double longitude,
    required String startDate, // Format: yyyy-MM-dd
    required String endDate, // Format: yyyy-MM-dd
  }) async {
    // Construct API URL with parameters for temperature and rainfall data
    final url = Uri.parse(
      "$_baseUrl/archive?latitude=$latitude&longitude=$longitude"
      "&start_date=$startDate&end_date=$endDate"
      "&daily=temperature_2m_mean,rain_sum&timezone=auto",
    );

    try {
      // Make GET request to fetch temperature & rainfall history
      final response = await http.get(url);

      // Debug print the URL being hit
      debugPrint("$url");

      // If response is successful, parse and return data
      if (response.statusCode == 200) {
        TemperatureRainfallWeatherHistoryResponseModel
            temperatureRainfallWeatherHistoryResponse =
            TemperatureRainfallWeatherHistoryResponseModel.fromJson(
          jsonDecode(response.body),
        );
        return temperatureRainfallWeatherHistoryResponse;
      } else {
        // Log and throw error if response code is not 200
        if (kDebugMode) {
          debugPrint(
            "Error: ${response.statusCode} : ${response.reasonPhrase}",
          );
        }
        return Future.error(
          "Error: ${response.statusCode} : ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      // Catch and report any exceptions (e.g., timeout, bad response)
      if (kDebugMode) debugPrint("Failed to fetch data: $e");
      return Future.error("Failed to fetch data: $e");
    }
  }
}
