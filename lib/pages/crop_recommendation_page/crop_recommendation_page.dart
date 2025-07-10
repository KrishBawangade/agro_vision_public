// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/ml_model_integration/crop_recommendation_model.dart';
import 'package:agro_vision/pages/crop_recommendation_page/widgets/crop_recommendation_dialog.dart';
import 'package:agro_vision/pages/crop_recommendation_page/widgets/duration_drop_down_button.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:agro_vision/providers/location_provider.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:agro_vision/widgets/app_snack_bar.dart';
import 'package:agro_vision/widgets/calculating_environment_values_dialog.dart';
import 'package:agro_vision/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CropRecommendationPage extends StatefulWidget {
  final bool isChanged;
  const CropRecommendationPage({super.key, required this.isChanged});

  @override
  State<CropRecommendationPage> createState() => _CropRecommendationPageState();
}

class _CropRecommendationPageState extends State<CropRecommendationPage> {
  final CropRecommendationModel _model = CropRecommendationModel();

  MainProvider? disposeMainProvider;

  String? nitrogenErrorText;
  String? phosphorousErrorText;
  String? potassiumErrorText;
  String? phValueErrorText;

  String? temperatureErrorText;
  String? humidityErrorText;
  String? rainfallErrorText;

  TextEditingController nitrogenTextEditingController = TextEditingController();
  TextEditingController phosphorousTextEditingController =
      TextEditingController();
  TextEditingController potassiumTextEditingController =
      TextEditingController();
  TextEditingController phValueTextEditingController = TextEditingController();

  TextEditingController temperatureTextEditingController =
      TextEditingController();

  TextEditingController rainfallTextEditingController = TextEditingController();
  TextEditingController humidityTextEditingController = TextEditingController();
  // final List<int> _durationMonthList = [3, 6, 12];
  // int _durationMonth = 6;

  var demoInputFeatures = [
    98.0,
    7.0,
    45.0,
    27.79161808,
    92.51054946,
    6.157724816,
    26.85422624
  ];

  final List<double> _averageTemperatureList = [];
  final List<double> _averageRainfallList = [];
  final List<double> _averageHumidityList = [];

  @override
  void initState() {
    super.initState();

    // Load the machine learning model used for crop recommendation
    _model.loadModel();

    // Use a microtask to ensure async logic runs after the widget is fully mounted
    Future.microtask(() async {
      // Access required providers without listening for rebuilds
      disposeMainProvider = Provider.of<MainProvider>(context, listen: false);
      final mainProvider = Provider.of<MainProvider>(context, listen: false);
      final farmPlotProvider =
          Provider.of<FarmPlotProvider>(context, listen: false);
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);

      // Get the selected plantation date from the farm plot provider
      DateTime selectedPlantationDate = farmPlotProvider.selectedPlantationDate;

      // Log the selected plantation date for debugging
      debugPrint("Selected Plantation Date: $selectedPlantationDate");

      // Show dialog while environmental values are being calculated
      CalculatingEnvironmentValuesDialog.show(context);

      // Log current and new location/plantation date for debugging purposes
      debugPrint(
          "Before location: ${mainProvider.usedLocation?.latitude} and ${mainProvider.usedLocation?.longitude}, After: ${locationProvider.selectedLocation?.latitude} and ${locationProvider.selectedLocation?.longitude}");
      debugPrint(
          "Before date: ${mainProvider.usedPlantationDate} and ${farmPlotProvider.selectedPlantationDate}");

      // Check if data needs to be fetched again (new location/date or empty values)
      if (mainProvider.monthsHumidityAverageList.isEmpty ||
          mainProvider.usedLocation?.latitude !=
              locationProvider.selectedLocation?.latitude ||
          mainProvider.usedLocation?.longitude !=
              locationProvider.selectedLocation?.longitude ||
          mainProvider.usedPlantationDate !=
              farmPlotProvider.selectedPlantationDate) {
        // Fetch humidity and temperature/rainfall history based on selected location and date
        await mainProvider
            .getLocationAndLoadHourlyHumidityWeatherHistoryResponse(
          selectedLocation: locationProvider.selectedLocation!,
          selectedPlantationDate: selectedPlantationDate,
        );
        await mainProvider
            .getLocationAndLoadTemperatureRainfallWeatherHistoryResponse(
          selectedLocation: locationProvider.selectedLocation!,
          selectedPlantationDate: selectedPlantationDate,
        );
      }

      // ───────────── Handle Humidity API Errors ───────────── //
      if (mainProvider.hourlyHumidityWeatherHistoryErrorMsg != null) {
        AppSnackBar.showSnackBar(
          context: context,
          msg: mainProvider.hourlyHumidityWeatherHistoryErrorMsg!,
          action: SnackBarAction(
            label: AppStrings.retry.tr(),
            onPressed: () async {
              // Retry API calls when user taps "Retry"
              CalculatingEnvironmentValuesDialog.show(context);
              await mainProvider
                  .getLocationAndLoadHourlyHumidityWeatherHistoryResponse(
                selectedLocation: locationProvider.selectedLocation!,
                selectedPlantationDate: selectedPlantationDate,
              );
              await mainProvider
                  .getLocationAndLoadTemperatureRainfallWeatherHistoryResponse(
                selectedLocation: locationProvider.selectedLocation!,
                selectedPlantationDate: selectedPlantationDate,
              );

              // Show any errors and update environment values
              _checkForErrorsAndShowSnackBar(
                  mainProvider: mainProvider, context: context);
              _validateAndSetEnvironmentValues(
                  mainProvider: mainProvider, index: 1);
              CalculatingEnvironmentValuesDialog.hide(context);
            },
          ),
        );
      }

      // ───────────── Handle Temperature/Rainfall API Errors ───────────── //
      else if (mainProvider.temperatureRainfallWeatherHistoryErrorMsg != null) {
        AppSnackBar.showSnackBar(
          context: context,
          msg: mainProvider.temperatureRainfallWeatherHistoryErrorMsg!,
          action: SnackBarAction(
            label: AppStrings.retry.tr(),
            onPressed: () async {
              // Retry temperature/rainfall API if error
              CalculatingEnvironmentValuesDialog.show(context);
              await mainProvider
                  .getLocationAndLoadTemperatureRainfallWeatherHistoryResponse(
                selectedLocation: locationProvider.selectedLocation!,
                selectedPlantationDate: selectedPlantationDate,
              );

              // Show any errors and update environment values
              _checkForErrorsAndShowSnackBar(
                  mainProvider: mainProvider, context: context);
              _validateAndSetEnvironmentValues(
                  mainProvider: mainProvider, index: 1);
              CalculatingEnvironmentValuesDialog.hide(context);
            },
          ),
        );
      }

      // ───────────── Calculate Environmental Averages ───────────── //
      else {
        // Calculate 3-month, 6-month, and 12-month average humidity
        double totalHumidity = 0;
        for (int i = 0;
            i < mainProvider.monthsHumidityAverageList.length;
            i++) {
          double humidity = mainProvider.monthsHumidityAverageList[i];
          totalHumidity += humidity;
          if (i == 2) {
            _averageHumidityList.add(totalHumidity / 3);
          } else if (i == 5) {
            _averageHumidityList.add(totalHumidity / 6);
          } else if (i == 11) {
            _averageHumidityList.add(totalHumidity / 12);
          }
        }

        // Calculate 3-month, 6-month, and 12-month average rainfall
        double totalRainfall = 0;
        for (int i = 0;
            i < mainProvider.monthsRainfallAverageList.length;
            i++) {
          double rainfall = mainProvider.monthsRainfallAverageList[i];
          totalRainfall += rainfall;
          if (i == 2) {
            _averageRainfallList.add(totalRainfall / 3);
          } else if (i == 5) {
            _averageRainfallList.add(totalRainfall / 6);
          } else if (i == 11) {
            _averageRainfallList.add(totalRainfall / 12);
          }
        }

        // Calculate 3-month, 6-month, and 12-month average temperature
        double totalTemperature = 0;
        for (int i = 0;
            i < mainProvider.monthsTemperatureAverageList.length;
            i++) {
          double temperature = mainProvider.monthsTemperatureAverageList[i];
          totalTemperature += temperature;
          if (i == 2) {
            _averageTemperatureList.add(totalTemperature / 3);
          } else if (i == 5) {
            _averageTemperatureList.add(totalTemperature / 6);
          } else if (i == 11) {
            _averageTemperatureList.add(totalTemperature / 12);
          }
        }

        // Set the calculated 6-month average values in the corresponding input fields
        humidityTextEditingController.text = _averageHumidityList[1].toString();
        temperatureTextEditingController.text =
            _averageTemperatureList[1].toString();
        rainfallTextEditingController.text = _averageRainfallList[1].toString();
      }

      // Hide the environment values calculation dialog
      CalculatingEnvironmentValuesDialog.hide(context);
    });
  }

  // Checks for weather data loading errors and shows appropriate snack bars with retry logic
  _checkForErrorsAndShowSnackBar({
    required MainProvider mainProvider,
    required BuildContext context,
  }) {
    // Get required providers
    LocationProvider locationProvider = Provider.of(context);
    FarmPlotProvider farmPlotProvider = Provider.of(context);

    // Get the selected plantation date
    DateTime selectedPlantationDate = farmPlotProvider.selectedPlantationDate;

    // ───────────── Case 1: Hourly Humidity Data Error ───────────── //
    if (mainProvider.hourlyHumidityWeatherHistoryErrorMsg != null) {
      // Show snackbar with retry button
      AppSnackBar.showSnackBar(
        context: context,
        msg: mainProvider.hourlyHumidityWeatherHistoryErrorMsg!,
        action: SnackBarAction(
          label: AppStrings.retry.tr(),
          onPressed: () async {
            // Retry humidity and temperature/rainfall data loading
            CalculatingEnvironmentValuesDialog.show(context);

            await mainProvider
                .getLocationAndLoadHourlyHumidityWeatherHistoryResponse(
              selectedLocation: locationProvider.selectedLocation!,
              selectedPlantationDate: selectedPlantationDate,
            );

            await mainProvider
                .getLocationAndLoadTemperatureRainfallWeatherHistoryResponse(
              selectedLocation: locationProvider.selectedLocation!,
              selectedPlantationDate: selectedPlantationDate,
            );

            // Re-check for errors and update environment values
            _checkForErrorsAndShowSnackBar(
              mainProvider: mainProvider,
              context: context,
            );
            _validateAndSetEnvironmentValues(
              mainProvider: mainProvider,
              index: 1,
            );

            // Hide progress dialog after retry completes
            CalculatingEnvironmentValuesDialog.hide(context);
          },
        ),
      );
    }

    // ───────────── Case 2: Temperature & Rainfall Data Error ───────────── //
    else if (mainProvider.temperatureRainfallWeatherHistoryErrorMsg != null) {
      // Show snackbar with retry option
      AppSnackBar.showSnackBar(
        context: context,
        msg: mainProvider.temperatureRainfallWeatherHistoryErrorMsg!,
        action: SnackBarAction(
          label: AppStrings.retry.tr(),
          onPressed: () async {
            // Retry only temperature/rainfall data loading
            CalculatingEnvironmentValuesDialog.show(context);

            await mainProvider
                .getLocationAndLoadTemperatureRainfallWeatherHistoryResponse(
              selectedLocation: locationProvider.selectedLocation!,
              selectedPlantationDate: selectedPlantationDate,
            );

            // Re-check errors and update values
            _checkForErrorsAndShowSnackBar(
              mainProvider: mainProvider,
              context: context,
            );
            _validateAndSetEnvironmentValues(
              mainProvider: mainProvider,
              index: 1,
            );

            // Hide loading dialog
            CalculatingEnvironmentValuesDialog.hide(context);
          },
        ),
      );
    }

    // ───────────── Case 3: No Errors ───────────── //
    else {
      // Directly set 6-month averages (index 1) into input fields
      humidityTextEditingController.text =
          mainProvider.monthsHumidityAverageList[1].toString();
      temperatureTextEditingController.text =
          mainProvider.monthsTemperatureAverageList[1].toString();
      rainfallTextEditingController.text =
          mainProvider.monthsRainfallAverageList[1].toString();
    }
  }

  // Updates the environment input fields (temperature, rainfall, humidity)
// with the pre-computed average values for the selected duration (3, 6, or 12 months)
  _validateAndSetEnvironmentValues({
    required MainProvider mainProvider,
    required int index, // 0 = 3 months, 1 = 6 months, 2 = 12 months
  }) async {
    // Check if all three monthly average lists are loaded and not empty
    if (mainProvider.monthsHumidityAverageList.isNotEmpty &&
        mainProvider.monthsTemperatureAverageList.isNotEmpty &&
        mainProvider.monthsRainfallAverageList.isNotEmpty) {
      // If valid, update the UI with average values for the selected duration
      setState(() {
        humidityTextEditingController.text =
            _averageHumidityList[index].toString();
        temperatureTextEditingController.text =
            _averageTemperatureList[index].toString();
        rainfallTextEditingController.text =
            _averageRainfallList[index].toString();
      });
    }
  }

  @override
  void dispose() {
    disposeMainProvider!.setSampleCrop(crop: null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access mainProvider for state management
    MainProvider mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(title: AppStrings.cropRecommendation.tr()),

      // ───── SAFEAREA FOR PADDING AND LAYOUT ───── //
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ───── SOIL DETAILS HEADER ───── //
                  Text(
                    AppStrings.soilDetails.tr(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // ───── NITROGEN INPUT FIELD ───── //
                  TextField(
                    controller: nitrogenTextEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (nitrogenTextEditingController.text.isEmpty) {
                        nitrogenErrorText =
                            AppStrings.nitrogenEmptyMessage.tr();
                      } else if (double.tryParse(
                              nitrogenTextEditingController.text) ==
                          null) {
                        nitrogenErrorText =
                            AppStrings.enterValidNitrogenValue.tr();
                      } else {
                        nitrogenErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.nitrogen.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor)),
                      errorText: nitrogenErrorText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ───── PHOSPHOROUS INPUT FIELD ───── //
                  TextField(
                    controller: phosphorousTextEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (phosphorousTextEditingController.text.isEmpty) {
                        phosphorousErrorText =
                            AppStrings.phosphorusEmptyValueMessage.tr();
                      } else if (double.tryParse(
                              phosphorousTextEditingController.text) ==
                          null) {
                        phosphorousErrorText =
                            AppStrings.enterValidPhosphorusValue;
                      } else {
                        phosphorousErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.phosphorus.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor)),
                      errorText: phosphorousErrorText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ───── POTASSIUM INPUT FIELD ───── //
                  TextField(
                    controller: potassiumTextEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (potassiumTextEditingController.text.isEmpty) {
                        potassiumErrorText =
                            AppStrings.potassiumEmptyValueMessage.tr();
                      } else if (double.tryParse(
                              potassiumTextEditingController.text) ==
                          null) {
                        potassiumErrorText =
                            AppStrings.enterValidPotassiumValue.tr();
                      } else {
                        potassiumErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.potassium.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor)),
                      errorText: potassiumErrorText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ───── PH VALUE INPUT FIELD ───── //
                  TextField(
                    controller: phValueTextEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (phValueTextEditingController.text.isEmpty) {
                        phValueErrorText = AppStrings.phEmptyValueMessage.tr();
                      } else if (double.tryParse(
                              phValueTextEditingController.text) ==
                          null) {
                        phValueErrorText = AppStrings.enterValidPhValue.tr();
                      } else {
                        phValueErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.pH.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor)),
                      errorText: phValueErrorText,
                    ),
                  ),
                  const SizedBox(height: 72),

                  // ───── ENVIRONMENT DETAILS + DROPDOWN ───── //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.environmentDetails.tr(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      DurationDropDownButton(
                        onDurationChanged: (durationIndex) {
                          mainProvider.setSampleCrop(crop: null);
                          _validateAndSetEnvironmentValues(
                              mainProvider: mainProvider, index: durationIndex);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ───── TEMPERATURE FIELD (READONLY) ───── //
                  TextField(
                    controller: temperatureTextEditingController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (temperatureTextEditingController.text.isEmpty) {
                        temperatureErrorText =
                            AppStrings.temperatureEmptyValueMessage.tr();
                      } else if (double.tryParse(
                              temperatureTextEditingController.text) ==
                          null) {
                        temperatureErrorText =
                            AppStrings.enterValidTemperatureValue.tr();
                      } else {
                        temperatureErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.temperature.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor)),
                      errorText: temperatureErrorText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ───── HUMIDITY FIELD (READONLY) ───── //
                  TextField(
                    controller: humidityTextEditingController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (humidityTextEditingController.text.isEmpty) {
                        humidityErrorText =
                            AppStrings.humidityEmptyValueMessage;
                      } else if (double.tryParse(
                              humidityTextEditingController.text) ==
                          null) {
                        humidityErrorText = AppStrings.enterValidHumidityValue;
                      } else {
                        humidityErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.humidity.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor)),
                      errorText: humidityErrorText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ───── RAINFALL FIELD (READONLY) ───── //
                  TextField(
                    controller: rainfallTextEditingController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (rainfallTextEditingController.text.isEmpty) {
                        rainfallErrorText =
                            AppStrings.rainfallEmptyValueMessage;
                      } else if (double.tryParse(
                              rainfallTextEditingController.text) ==
                          null) {
                        rainfallErrorText = AppStrings.enterValidRainfallValue;
                      } else {
                        rainfallErrorText = null;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      label: Text(AppStrings.rainfall.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor)),
                      errorText: rainfallErrorText,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // ───── PREDICT CROP BUTTON ───── //
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        // ───── VALIDATE FORM FIELDS BEFORE PREDICTION ───── //
                        if (!validateInput()) {
                          List<double> inputFeatures = [];

                          // Add soil inputs
                          inputFeatures.add(
                              double.parse(nitrogenTextEditingController.text)
                                  .toInt()
                                  .toDouble());
                          inputFeatures.add(double.parse(
                                  phosphorousTextEditingController.text)
                              .toInt()
                              .toDouble());
                          inputFeatures.add(
                              double.parse(potassiumTextEditingController.text)
                                  .toInt()
                                  .toDouble());
                          inputFeatures.add(
                              double.parse(phValueTextEditingController.text)
                                  .toInt()
                                  .toDouble());

                          // Add 12-month environmental values
                          inputFeatures.addAll(mainProvider
                              .monthsTemperatureAverageList
                              .sublist(0, 12));
                          inputFeatures.addAll(mainProvider
                              .monthsRainfallAverageList
                              .sublist(0, 12));
                          inputFeatures.addAll(mainProvider
                              .monthsHumidityAverageList
                              .sublist(0, 12));

                          // Run ML Model Prediction
                          var output = await _model.predict(inputFeatures);

                          // Show recommended crop dialog
                          await showRecommendedCropDialog(
                            context: context,
                            recommendedCrop: output,
                            onCropUsed: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      },
                      child: Text(
                        AppStrings.recommendCrop.tr(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Validates all input fields and updates error messages accordingly
  validateInput() {
    // ───── Nitrogen validation ───── //
    if (nitrogenTextEditingController.text.isEmpty) {
      nitrogenErrorText = "Nitrogen value can't be empty!!";
    } else if (double.tryParse(nitrogenTextEditingController.text) == null) {
      nitrogenErrorText = "Enter a valid Nitrogen value!!";
    } else {
      nitrogenErrorText = null;
    }

    // ───── Phosphorous validation ───── //
    if (phosphorousTextEditingController.text.isEmpty) {
      phosphorousErrorText = "Phosphorous value can't be empty!!";
    } else if (double.tryParse(phosphorousTextEditingController.text) == null) {
      phosphorousErrorText = "Enter a valid Phosphorus value!!";
    } else {
      phosphorousErrorText = null;
    }

    // ───── Potassium validation ───── //
    if (potassiumTextEditingController.text.isEmpty) {
      potassiumErrorText = "Potassium value can't be empty!!";
    } else if (double.tryParse(potassiumTextEditingController.text) == null) {
      potassiumErrorText = "Enter a valid Potassium value!!";
    } else {
      potassiumErrorText = null;
    }

    // ───── pH validation ───── //
    if (phValueTextEditingController.text.isEmpty) {
      phValueErrorText = "pH value can't be empty!!";
    } else if (double.tryParse(phValueTextEditingController.text) == null) {
      phValueErrorText = "Enter a valid pH value!!";
    } else if (double.parse(phValueTextEditingController.text) < 0 ||
        double.parse(phValueTextEditingController.text) > 14) {
      phValueErrorText = "ph value should be in range from 0–14!!";
    } else {
      phValueErrorText = null;
    }

    // ───── Temperature validation ───── //
    if (temperatureTextEditingController.text.isEmpty) {
      temperatureErrorText = "Temperature can't be empty!!";
    } else if (double.tryParse(temperatureTextEditingController.text) == null) {
      temperatureErrorText = "Enter a valid temperature value!!";
    } else {
      temperatureErrorText = null;
    }

    // ───── Humidity validation ───── //
    if (humidityTextEditingController.text.isEmpty) {
      humidityErrorText = "Humidity can't be empty!!";
    } else if (double.tryParse(humidityTextEditingController.text) == null) {
      humidityErrorText = "Enter a valid humidity value!!";
    } else {
      humidityErrorText = null;
    }

    // ───── Rainfall validation ───── //
    if (rainfallTextEditingController.text.isEmpty) {
      rainfallErrorText = "Rainfall can't be empty!!";
    } else if (double.tryParse(rainfallTextEditingController.text) == null) {
      rainfallErrorText = "Enter a valid rainfall value!!";
    } else {
      rainfallErrorText = null;
    }

    // ───── Update UI with error messages ───── //
    setState(() {});

    // ───── Return true if any error exists ───── //
    return nitrogenErrorText != null ||
        phosphorousErrorText != null ||
        potassiumErrorText != null ||
        phValueErrorText != null ||
        temperatureErrorText != null ||
        humidityErrorText != null ||
        rainfallErrorText != null;
  }
}
