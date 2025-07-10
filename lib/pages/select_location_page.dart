// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/providers/location_provider.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  // Default to India's center
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(22.3511148, 78.6677428),
    zoom: 12,
  );

  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    LocationProvider locationProvider = Provider.of(context, listen: false);

    // Use previously selected location if available
    if (locationProvider.selectedLocation != null) {
      _selectedLocation = locationProvider.selectedLocation!;
      initialCameraPosition = CameraPosition(
        target: _selectedLocation!,
        zoom: 12,
      );
    }
  }

  // Callback for map tap
  void _onMapTap(LatLng position) {
    _selectedLocation = position;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Select Location"),
      body: SafeArea(
        child: Column(
          children: [
            // Google Map Display
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: initialCameraPosition,
                onTap: _onMapTap,
                markers: _selectedLocation == null
                    ? {}
                    : {
                        Marker(
                          markerId: const MarkerId("selectedLocation"),
                          position: _selectedLocation!,
                        ),
                      },
              ),
            ),

            // Use Location Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _selectedLocation == null
                        ? null
                        : () async {
                            await locationProvider.setLocation(
                                location: _selectedLocation!);
                            await AppFunctions.showToastMessage(
                              msg: "Location used successfully!",
                            );
                            Navigator.of(context).pop();
                          },
                    child: const Text("Use Selected Location"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
