import 'dart:convert';

import 'package:agro_vision/env.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  // Determines the current position of the device
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Locations service disabled");
    }

    // Request location permission from the user
    locationPermission = await Geolocator.requestPermission();

    // If permissions are permanently denied, throw an error
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions denied permanently, we cannot request permissions.");
    }

    // Get and return the current location
    return await Geolocator.getCurrentPosition();
  }

  // Converts geographic coordinates into a human-readable address
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    String apiKey = Env.googleMapApiKey;
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // If the API returns a valid result, extract the formatted address
      if (data['status'] == "OK") {
        final String address = data["results"][0]["formatted_address"];
        return address;
      } else {
        if (kDebugMode) debugPrint('Error: ${data['status']}');
        return Future.error(
          "Error occurred while getting the address: Error: ${data['status']}",
        );
      }
    } else {
      // Handle HTTP errors
      if (kDebugMode) debugPrint("HTTP error: ${response.statusCode}");
      return Future.error("HTTP error: ${response.statusCode}");
    }
  }

  // Extracts district and state from geographic coordinates
  Future<Map<String, String>> getDistrictAndStateFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    String apiKey = Env.googleMapApiKey;
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // If response is OK, extract address components
      if (data['status'] == "OK") {
        final List components = data['results'][0]['address_components'];

        String? district;
        String? state;

        // Iterate through components to find district and state
        for (final component in components) {
          final List types = component['types'];
          if (types.contains('administrative_area_level_2')) {
            district = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          }
        }

        // Return district and state if both are found
        if (district != null && state != null) {
          return {
            'district': district,
            'state': state,
          };
        } else {
          return Future.error("Could not extract district or state.");
        }
      } else {
        return Future.error("Error from API: ${data['status']}");
      }
    } else {
      return Future.error("HTTP error: ${response.statusCode}");
    }
  }
}
