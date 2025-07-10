import 'dart:convert';
import 'package:agro_vision/env.dart';
import 'package:agro_vision/services/current_market_price_api/models/current_market_price_response_model.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class CurrentMarketPriceApiClient {
  final _baseUrl = "https://api.data.gov.in";
  final apiKey = Env.currentMarketPriceApiKey;

  Future<CurrentMarketPriceResponseModel> getCurrentMarketPriceDetails(
      {required String district}) async {
    final url = Uri.parse(
        "$_baseUrl/resource/9ef84268-d588-465a-a308-a864a43d0070?format=json&limit=9999&api-key=$apiKey&filters%5Bdistrict%5D=$district");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        CurrentMarketPriceResponseModel currentMarketPriceResponse =
            CurrentMarketPriceResponseModel.fromJson(jsonDecode(response.body));
        if (currentMarketPriceResponse.records.isNotEmpty) {
          // debugPrint(currentMarketPriceResponse.records[0].market);
          // debugPrint(currentMarketPriceResponse.records[0].commodity);
        }
        return currentMarketPriceResponse;
      } else {
        debugPrint("Error: ${response.statusCode} = ${response.reasonPhrase}");
        return Future.error(
            "Error: ${response.statusCode} = ${response.reasonPhrase}");
      }
    } catch (e) {
      debugPrint("Failed to fetch data: $e");
      return Future.error("Failed to fetch data: $e");
    }
  }
}
