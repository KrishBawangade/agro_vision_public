import "dart:convert";
import "package:agro_vision/env.dart";
import "package:agro_vision/services/weather_api/models/weather_forecast_api_response_model.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

class WeatherApiClient {
  // Base URL for the Weather API
  final _baseUrl = Uri.parse("http://api.weatherapi.com/v1");

  // 🔹 Fetch weather forecast data based on latitude and longitude
  Future<WeatherForecastApiResponseModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    // Constructing the API endpoint with query parameters
    final url = Uri.parse(
      "$_baseUrl/forecast.json?q=$latitude,$longitude&days=3&alerts=yes",
    );

    // Request headers including API key
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Key": Env.weatherApiKey, // API key stored in environment config
    };

    try {
      // Sending HTTP GET request to the Weather API
      final response = await http.get(url, headers: headers);

      // If successful (HTTP 200), parse and return the weather data
      if (response.statusCode == 200) {
        var weatherForecastApiResponse =
            WeatherForecastApiResponseModel.fromJson(
          jsonDecode(response.body),
        );
        return weatherForecastApiResponse;
      } else {
        // Log and return error if status code is not 200
        if (kDebugMode) {
          debugPrint(
              "Error: ${response.statusCode} = ${response.reasonPhrase}");
        }
        return Future.error(
          "Error: ${response.statusCode} = ${response.reasonPhrase}",
        );
      }
    } catch (error) {
      // Handle exceptions (e.g., network failure, invalid response)
      if (kDebugMode) debugPrint("Failed to fetch data: $error");
      return Future.error("Failed to fetch data: $error");
    }
  }
}
