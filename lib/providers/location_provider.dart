import 'package:agro_vision/services/location_service/location_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  // Constructor initializes current location
  LocationProvider() {
    setCurrentLocation();
  }

  LatLng? _selectedLocation;
  String? _selectedLocationAddress;
  bool _isLoading = false;

  // Getters
  LatLng? get selectedLocation => _selectedLocation;
  String? get selectedLocationAddress => _selectedLocationAddress;
  bool get isLoading => _isLoading;

  // Sets the user's current location using geolocation services
  setCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      LocationService locationService = LocationService();

      // Get current geolocation position
      Position position = await locationService.determinePosition();

      // Update location only if it's different from the previously selected one
      if (position.latitude != _selectedLocation?.latitude &&
          position.longitude != _selectedLocation?.longitude) {
        _selectedLocation = LatLng(position.latitude, position.longitude);

        // Reverse geocode to get human-readable address
        _selectedLocationAddress =
            await locationService.getAddressFromCoordinates(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        debugPrint("Some error occurred while setting current Location: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Manually sets a new selected location and fetches its address
  setLocation({required LatLng location}) async {
    LocationService locationService = LocationService();
    _isLoading = true;
    notifyListeners();

    try {
      // Update location only if it's different
      if (location.latitude != _selectedLocation?.latitude &&
          location.longitude != _selectedLocation?.longitude) {
        _selectedLocation = location;

        // Get address from the given coordinates
        _selectedLocationAddress =
            await locationService.getAddressFromCoordinates(
          latitude: location.latitude,
          longitude: location.longitude,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error occurred while setting the location: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Directly set both location and address without calling external services
  setLocationAndAddress({required LatLng location, required String address}) {
    _selectedLocation = location;
    _selectedLocationAddress = address;
    notifyListeners();
  }

  // Clears both location and address values
  clearLocationData() {
    _selectedLocation = null;
    _selectedLocationAddress = null;
    notifyListeners();
  }
}
