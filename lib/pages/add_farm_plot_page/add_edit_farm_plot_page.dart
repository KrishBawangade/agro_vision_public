import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/pages/crop_recommendation_page/crop_recommendation_page.dart';
import 'package:agro_vision/pages/select_location_page.dart';
import 'package:agro_vision/providers/crop_calendar_provider.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:agro_vision/providers/location_provider.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/utils/enums.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:agro_vision/widgets/calculating_environment_values_dialog.dart';
import 'package:agro_vision/widgets/custom_app_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditFarmPlotPage extends StatefulWidget {
  final FarmPlotModel? farmPlot;

  const AddEditFarmPlotPage({super.key, this.farmPlot});

  @override
  State<AddEditFarmPlotPage> createState() => _AddEditFarmPlotPageState();
}

class _AddEditFarmPlotPageState extends State<AddEditFarmPlotPage> {
  DateFormat dateFormat = DateFormat("dd MMM yyyy");

  // Error text fields for form validation
  String? nameErrorText;
  String? areaErrorText;
  String? cropNameErrorText;
  String? locationErrorText;

  // Controllers for form input fields
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController areaTextEditingController = TextEditingController();
  TextEditingController cropNameTextEditingController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  var selectedAreaUnit = FarmPlotAreaUnits.acre;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();

    // If editing existing plot, prefill all values
    if (widget.farmPlot != null) {
      setFarmPlotDetails(context);
    }

    validateInput(); // Initial form validation
  }

  /// Prefills form fields using the data from existing farm plot
  void setFarmPlotDetails(BuildContext context) {
    var farmPlot = widget.farmPlot!;
    FarmPlotProvider farmPlotProvider = Provider.of(context, listen: false);

    farmPlotProvider.setSelectedPlantationDate(
        selectedPlantationDate:
            DateTime.fromMillisecondsSinceEpoch(farmPlot.plantationDateMillis));

    nameTextEditingController.text = farmPlot.name;
    cropNameTextEditingController.text = farmPlot.crop;
    areaTextEditingController.text = farmPlot.areaValue.toString();
    locationController.text = farmPlot.address;
    selectedAreaUnit = farmPlot.areaUnit;
  }
  @override
  Widget build(BuildContext context) {
    // Get required providers
    FarmPlotProvider farmPlotProvider = Provider.of<FarmPlotProvider>(context);
    CropCalendarProvider cropCalendarProvider = Provider.of<CropCalendarProvider>(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    MainProvider mainProvider = Provider.of<MainProvider>(context);

    // Get selected plantation date
    DateTime selectedDate = farmPlotProvider.selectedPlantationDate;

    // Determine if 24hr limit has passed since last crop calendar generation
    bool is24HrPassed = AppFunctions.is24HoursPassedSince(
      mainProvider.currentUserData?.lastTimeRequestsUpdated ?? DateTime(2000),
    );

    // Determine if crop calendar should be generated
    bool shouldGenerateCropCalendar =
        ((mainProvider.currentUserData?.cropCalendarRequestsLeft ?? 0) > 0) || is24HrPassed;

    // Set date text field controller value
    TextEditingController dateTextEditingController =
        TextEditingController(text: dateFormat.format(selectedDate));

    // If editing existing plot and no location selected yet, set from plot
    if (widget.farmPlot != null && locationProvider.selectedLocation == null) {
      dateTextEditingController.text = dateFormat.format(
          DateTime.fromMillisecondsSinceEpoch(widget.farmPlot!.plantationDateMillis));
      locationProvider.setLocationAndAddress(
        location: LatLng(widget.farmPlot!.latitude, widget.farmPlot!.longitude),
        address: widget.farmPlot!.address,
      );
    }

    // If AI-based recommendation is available, auto-fill the crop name
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (farmPlotProvider.recommendedCrop.isNotEmpty) {
        cropNameTextEditingController.text = farmPlotProvider.recommendedCrop;
        validateInput();
        farmPlotProvider.setRecommendedCrop(cropName: ""); // Clear it after setting
      }
    });

    // Set button opacity based on form validation
    var animatedOpacityAddBtn = (nameErrorText != null ||
            areaErrorText != null ||
            cropNameErrorText != null)
        ? 0.3
        : 1.0;

    // Update location field and error text based on current state
    locationController.text = locationProvider.selectedLocationAddress ?? "";
    locationErrorText = locationController.text.isEmpty
        ? AppStrings.locationEmptyMessage.tr()
        : null;
    setState(() {});
    return PopScope(
      onPopInvokedWithResult: (isPopped, result) {
        // Reset location and plantation date when leaving the page
        locationProvider.clearLocationData();
        farmPlotProvider.setSelectedPlantationDate(
            selectedPlantationDate: DateTime.now());
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.farmPlot == null
              ? AppStrings.addPlot.tr()
              : AppStrings.editPlot.tr(),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  // AI Recommendation Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (locationProvider.selectedLocation != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  CropRecommendationPage(isChanged: isChanged),
                            ));
                          } else {
                            AppFunctions.showSnackBar(
                              context: context,
                              msg: AppStrings.selectLocationMessage.tr(),
                            );
                          }
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              AppStrings.useAiMlToRecommendCrop.tr(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Main Form
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Farm Plot Name
                            TextField(
                              controller: nameTextEditingController,
                              onChanged: (value) => setState(() => validateInput()),
                              decoration: InputDecoration(
                                label: Text(AppStrings.farmPlotName.tr(),
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor)),
                                errorText: nameErrorText,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Area Field + Unit Dropdown
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: areaTextEditingController,
                                    onChanged: (value) => setState(() => validateInput()),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      label: Text(AppStrings.area.tr(),
                                          style: TextStyle(
                                              color: Theme.of(context).hintColor)),
                                      errorText: areaErrorText,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 32),
                                SizedBox(
                                  width: 100,
                                  child: DropdownButton<FarmPlotAreaUnits>(
                                    value: selectedAreaUnit,
                                    items: FarmPlotAreaUnits.values.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedAreaUnit = value!;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Crop Name Dropdown with Search
                            DropdownSearch<String>(
                              enabled: widget.farmPlot == null,
                              selectedItem: cropNameTextEditingController.text.isNotEmpty
                                  ? cropNameTextEditingController.text
                                  : null,
                              items: (String filter, LoadProps? props) async {
                                final allCrops = farmPlotProvider.cropList;
                                return allCrops
                                    .where((crop) => crop
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()))
                                    .toList();
                              },
                              onChanged: (String? selectedCrop) {
                                cropNameTextEditingController.text = selectedCrop ?? '';
                                setState(() {
                                  validateInput();
                                });
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                searchDelay: const Duration(seconds: 0),
                                loadingBuilder: (context, searchEntry) =>
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                fit: FlexFit.loose,
                              ),
                              decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  labelText: AppStrings.cropName.tr(),
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  errorText: cropNameErrorText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Location Field (readonly) + Buttons
                            TextField(
                              controller: locationController,
                              readOnly: true,
                              decoration: InputDecoration(
                                label: Text(AppStrings.farmPlotLocation.tr(),
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor)),
                                errorText: locationErrorText,
                                suffixIcon: locationProvider.isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Use current location
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    locationProvider.setCurrentLocation();
                                  },
                                  child: Row(
                                    children: [
                                      Text(AppStrings.currentLocation.tr()),
                                    ],
                                  ),
                                ),
                                // Open map to pick location
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => const SelectLocationPage()));
                                  },
                                  child: Row(
                                    children: [
                                      Text(AppStrings.map.tr()),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.place),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Plantation Date (readonly)
                            TextField(
                              controller: dateTextEditingController,
                              readOnly: true,
                              onTap: widget.farmPlot != null
                                  ? null
                                  : () async {
                                      var pickedDate = await AppFunctions.selectDate(
                                          context: context, initialDate: selectedDate);
                                      if (pickedDate != null &&
                                          pickedDate != selectedDate) {
                                        farmPlotProvider.setSelectedPlantationDate(
                                            selectedPlantationDate: pickedDate);
                                        isChanged = true;
                                      }
                                    },
                              decoration: InputDecoration(
                                label: Text(AppStrings.plantationDate.tr(),
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Submit Button (Add or Update)
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedOpacity(
                      opacity: animatedOpacityAddBtn,
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: animatedOpacityAddBtn == 0.3
                            ? null
                            : () async {
                                // Create FarmPlotModel from form values
                                var farmPlot = FarmPlotModel(
                                  id: const Uuid().v4(),
                                  userId: FirebaseAuth.instance.currentUser?.uid ?? "",
                                  name: nameTextEditingController.text.trim(),
                                  crop: cropNameTextEditingController.text.trim().toLowerCase(),
                                  areaValue: double.parse(areaTextEditingController.text),
                                  areaUnit: selectedAreaUnit,
                                  latitude: locationProvider.selectedLocation!.latitude,
                                  longitude: locationProvider.selectedLocation!.longitude,
                                  address: locationProvider.selectedLocationAddress!,
                                  plantationDateMillis: selectedDate.millisecondsSinceEpoch,
                                  languageCode: AppFunctions.getCurrentLanguageCode(context),
                                );

                                // Add Mode
                                if (widget.farmPlot == null) {
                                  bool isNameExists = farmPlotProvider.farmPlotList.any(
                                    (plot) => plot.name == nameTextEditingController.text.trim(),
                                  );

                                  bool isCropValid = farmPlotProvider.isCropValid(
                                    crop: cropNameTextEditingController.text,
                                  );

                                  if (isNameExists) {
                                    nameErrorText = AppStrings.nameExistsMessage.tr();
                                    setState(() {});
                                  }

                                  if (!isCropValid) {
                                    cropNameErrorText = AppStrings.noCropFoundMessage.tr();
                                    setState(() {});
                                  }

                                  if (!isNameExists && isCropValid) {
                                    // Show loading dialog
                                    CalculatingEnvironmentValuesDialog.show(
                                      context,
                                      message: !shouldGenerateCropCalendar
                                          ? AppStrings.addingFarmPlotMessage.tr()
                                          : AppStrings.generatingCropCalendarMessage.tr(),
                                    );

                                    // Submit to Firestore
                                    await farmPlotProvider.addFarmPlot(
                                      farmPlot: farmPlot,
                                      context: context,
                                      currentLanguageName: AppFunctions.getLanguageName(
                                        AppFunctions.getCurrentLanguageCode(context),
                                      ),
                                      shouldGenerateCropCalendar: shouldGenerateCropCalendar,
                                      onFarmPlotAdded: () {
                                        CalculatingEnvironmentValuesDialog.hide(context);
                                        Navigator.of(context).pop();
                                      },
                                      onError: () {
                                        CalculatingEnvironmentValuesDialog.hide(context);
                                      },
                                    );
                                  }
                                } else {
                                  // Edit Mode
                                  CalculatingEnvironmentValuesDialog.show(
                                    context,
                                    message: AppStrings.updatingFarmPlotMessage.tr(),
                                  );

                                  // If plot has changed, update
                                  if (widget.farmPlot != farmPlot) {
                                    var cropCalendar = cropCalendarProvider.cropCalendarResponseList.firstWhere(
                                      (item) => item.farmPlotId == widget.farmPlot!.id,
                                    );

                                    // Preserve existing ID
                                    farmPlot.id = widget.farmPlot!.id;

                                    await farmPlotProvider.updateFarmPlot(
                                      oldFarmPlot: widget.farmPlot!,
                                      newFarmPlot: farmPlot,
                                      cropCalendar: cropCalendar,
                                      currentLanguageName: AppFunctions.getLanguageName(
                                        AppFunctions.getCurrentLanguageCode(context),
                                      ),
                                      context: context,
                                      onFarmPlotUpdated: () {
                                        CalculatingEnvironmentValuesDialog.hide(context);
                                        Navigator.of(context).pop();
                                      },
                                      onError: () {
                                        CalculatingEnvironmentValuesDialog.hide(context);
                                      },
                                    );
                                  } else {
                                    AppFunctions.showSnackBar(
                                      context: context,
                                      msg: AppStrings.farmPlotUpdatedSuccessMessage.tr(),
                                    );
                                    CalculatingEnvironmentValuesDialog.hide(context);
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                        child: Text(
                          widget.farmPlot == null
                              ? AppStrings.addPlot.tr()
                              : AppStrings.updatePlot.tr(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Validates all form inputs and updates corresponding error messages
  void validateInput() {
    if (nameTextEditingController.text.isEmpty) {
      nameErrorText = AppStrings.farmPlotNameEmptyErrorMessage.tr();
    } else {
      nameErrorText = null;
    }

    if (areaTextEditingController.text.isEmpty) {
      areaErrorText = AppStrings.areaEmptyErrorMessage.tr();
    } else if (double.tryParse(areaTextEditingController.text) == null) {
      areaErrorText = AppStrings.enterValidAreaValue.tr();
    } else {
      areaErrorText = null;
    }

    if (cropNameTextEditingController.text.isEmpty) {
      cropNameErrorText = AppStrings.cropNameEmptyErrorMessage.tr();
    } else {
      cropNameErrorText = null;
    }

    if (locationController.text.isEmpty) {
      locationErrorText = AppStrings.locationEmptyMessage.tr();
    } else {
      locationErrorText = null;
    }

    setState(() {}); // Rebuild UI to show validation updates
  }
}
