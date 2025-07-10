// ignore_for_file: use_build_context_synchronously

// Importing necessary packages and files
import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/crop_calendar_stage_card_widget.dart';
import 'package:agro_vision/providers/crop_calendar_provider.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:agro_vision/providers/main_provider.dart';
import 'package:agro_vision/providers/translation_provider.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_item_model.dart';
import 'package:agro_vision/services/gemini_service/models/crop_calendar_response_model.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:agro_vision/widgets/calculating_environment_values_dialog.dart';
import 'package:agro_vision/widgets/select_language_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CropCalendarWidget extends StatefulWidget {
  const CropCalendarWidget({super.key});

  @override
  State<CropCalendarWidget> createState() => _CropCalendarWidgetState();
}

class _CropCalendarWidgetState extends State<CropCalendarWidget> {
  // Stores the crop calendar data to be displayed
  CropCalendarResponseModel? cropCalendarResponse;

  // Controller for PageView scrolling
  PageController? pageController;

  // Initial page index for PageView
  var initialIndex = 0;

  // Map to hold translated crop calendar stage names
  Map<String, String>? translatedCropCalendarMap;

  // Flags to track translation and loading states
  bool _isTranslated = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // Helper function to calculate total duration between start and end of crop calendar
  int calculateDuration(CropCalendarResponseModel? cropCalendarResponse) {
    if (cropCalendarResponse != null &&
        cropCalendarResponse.crop_calendar.isNotEmpty) {
      var startDateString = cropCalendarResponse.crop_calendar[0].start_date;
      var endDateString = cropCalendarResponse
          .crop_calendar[cropCalendarResponse.crop_calendar.length - 1]
          .end_date;

      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      var startDateUtc = dateFormat.parseUTC(startDateString);
      var endDateUtc = dateFormat.parseUTC(endDateString);

      // Calculate total duration in days
      int durationDays = endDateUtc.difference(startDateUtc).inDays;

      return durationDays;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    // Accessing providers
    CropCalendarProvider cropCalendarProvider =
        Provider.of<CropCalendarProvider>(context);
    FarmPlotProvider farmPlotProvider = Provider.of<FarmPlotProvider>(context);
    MainProvider mainProvider = Provider.of(context);
    TranslationProvider translationProvider =
        Provider.of<TranslationProvider>(context);

    // Find translated map for the current crop calendar (if any)
    bool hasTranslateCropCalendarMap =
        translationProvider.isTranslatedCropCalendarList.any((isTranslatedMap) {
      bool matched = isTranslatedMap["id"] ==
          (cropCalendarProvider.selectedCropCalendar?.id ?? "");
      if (matched) {
        translatedCropCalendarMap = isTranslatedMap;
      }
      return matched;
    });

    // If no translated map found, reset it
    if (!hasTranslateCropCalendarMap) {
      translatedCropCalendarMap = null;
    }

    // Determine if the selected crop calendar has been translated
    _isTranslated = !(translatedCropCalendarMap == null ||
        translatedCropCalendarMap?["selectedLocale"] ==
            (cropCalendarProvider.selectedCropCalendar?.languageCode ?? "en"));

    // Set translated crop calendar response if translation is available
    if (_isTranslated && !_isLoading) {
      translationProvider.selectedLocaleCropCalendarResponse =
          translationProvider.translatedCropCalendarResponseList.firstWhere(
              (cropCalendar) =>
                  cropCalendar.id == translatedCropCalendarMap?["id"] &&
                  cropCalendar.languageCode ==
                      translatedCropCalendarMap?["selectedLocale"]);
    }

    // Set the crop calendar to display (translated or original)
    cropCalendarResponse = _isTranslated
        ? translationProvider.selectedLocaleCropCalendarResponse
        : cropCalendarProvider.selectedCropCalendar;

    // Determine the initial page index for PageView
    findInitialIndex(cropCalendarResponse);

    // Create a PageController with the calculated index
    pageController = PageController(
        initialPage: initialIndex,
        viewportFraction: 0.9,
        onAttach: (scrollPosition) {
          animateToPage();
        });

    // Calculate the duration of the crop calendar in a human-readable format
    int durationDays = calculateDuration(cropCalendarResponse);
    int years = durationDays ~/ 365;
    int remainingDaysAfterYears = durationDays % 365;
    int months = remainingDaysAfterYears ~/ 30;
    int days = remainingDaysAfterYears % 30;

    String durationString = '';
    if (years > 0) {
      durationString += years > 1 ? "$years Yrs" : "$years Yr";
      months = (remainingDaysAfterYears / 30).round();
    }
    if (months > 0) {
      if (durationString.isNotEmpty) {
        durationString += ' ${AppStrings.and.tr()} ';
      }
      durationString += months > 1
          ? "$months ${AppStrings.months.tr()}"
          : "$months ${AppStrings.month.tr()}";
    }
    if (days > 0 && years <= 0) {
      if (durationString.isNotEmpty) {
        durationString += ' ${AppStrings.and.tr()} ';
      }
      durationString += days > 1
          ? "$days ${AppStrings.days.tr()}"
          : "$days ${AppStrings.day.tr()}";
    }

    // If no duration calculated
    if (durationString.isEmpty) durationString = AppStrings.lessThanADay.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Crop Calendar + Duration
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.cropCalendar.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            cropCalendarProvider.cropCalendarResponseList.isNotEmpty &&
                    cropCalendarProvider.selectedCropCalendar != null
                ? Flexible(
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: AppStrings.duration.tr(),
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 12)),
                      TextSpan(
                          text: durationString,
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface)),
                    ])),
                  )
                : const SizedBox.shrink()
          ],
        ),

        const SizedBox(height: 16),

        // Crop Calendar content section
        (!cropCalendarProvider.isLoading && !_isLoading)
            ? cropCalendarProvider.cropCalendarResponseList.isNotEmpty &&
                    cropCalendarProvider.selectedCropCalendar != null
                ? SizedBox(
                    height: 225,
                    child: cropCalendarResponse != null
                        ? PageView.builder(
                            controller: pageController,
                            physics: const PageScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                cropCalendarResponse!.crop_calendar.length,
                            itemBuilder: (context, index) {
                              CropCalendarItemModel cropCalendarItem =
                                  cropCalendarResponse!.crop_calendar[index];
                              return CropCalendarStageCardWidget(
                                cropCalendar: cropCalendarItem,
                                index: index,
                              );
                            })
                        : const SizedBox.shrink(),
                  )
                : farmPlotProvider.farmPlotList.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.noCropCalendarFoundMessage.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      )
                    : Center(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          "${AppStrings.noCropCalendarFoundForFarmPlotMessage.tr()} ${cropCalendarProvider.selectedFarmPlotName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(height: 8),

                        // Generate crop calendar button if none found
                        ElevatedButton(
                            onPressed: () async {
                              bool is24HrPassed =
                                  AppFunctions.is24HoursPassedSince(
                                mainProvider.currentUserData
                                        ?.lastTimeRequestsUpdated ??
                                    DateTime(2000),
                              );
                              if (((mainProvider.currentUserData
                                              ?.cropCalendarRequestsLeft ??
                                          0) >
                                      0) ||
                                  is24HrPassed) {
                                FarmPlotModel? selectedFarmPlot;
                                farmPlotProvider.farmPlotList.any((farmPlot) {
                                  bool isFarmPlot = farmPlot.id ==
                                      cropCalendarProvider.selectedFarmPlotId;
                                  if (isFarmPlot) {
                                    selectedFarmPlot = farmPlot;
                                  }
                                  return isFarmPlot;
                                });
                                if (selectedFarmPlot != null) {
                                  CalculatingEnvironmentValuesDialog.show(
                                      context,
                                      message: AppStrings
                                          .generatingCropCalendarMessage
                                          .tr());
                                  await cropCalendarProvider
                                      .generateAndAddCropCalendarResponse(
                                          farmPlot: selectedFarmPlot!,
                                          currentLanguageName:
                                              AppFunctions.getLanguageName(
                                                  AppFunctions
                                                      .getCurrentLanguageCode(
                                                          context)),
                                          hasGeneratedAlone: true,
                                          onCropCalendarAdded: () {
                                            AppFunctions.showSnackBar(
                                                context: context,
                                                msg: AppStrings
                                                    .cropCalendarGeneratedSuccessMessage
                                                    .tr());
                                            CalculatingEnvironmentValuesDialog
                                                .hide(context);
                                          },
                                          onError: (e) {
                                            AppFunctions.showSnackBar(
                                                context: context, msg: e);
                                            CalculatingEnvironmentValuesDialog
                                                .hide(context);
                                          });
                                }
                              } else {
                                AppFunctions.showSnackBar(
                                    context: context,
                                    msg: AppStrings
                                        .cropCalendarRequestsLimitReachedMessage
                                        .tr(),
                                    duration: const Duration(seconds: 4));
                              }
                            },
                            child: Text(AppStrings.generateCropCalendar.tr()))
                      ]))
            : const Center(child: CircularProgressIndicator()),

        const SizedBox(height: 16),

        // Translate button
        if (cropCalendarProvider.cropCalendarResponseList.isNotEmpty ||
            cropCalendarProvider.selectedCropCalendar == null)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        // Show language selection bottom sheet
                        Locale? selectedLanguage =
                            await SelectLanguageBottomSheet.show(
                                context,
                                Locale(cropCalendarResponse?.languageCode ??
                                    "en"));

                        if (selectedLanguage != null &&
                            cropCalendarProvider.selectedCropCalendar != null &&
                            (cropCalendarProvider
                                        .selectedCropCalendar!.languageCode ??
                                    "en") !=
                                selectedLanguage.languageCode) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Perform translation
                          await translationProvider.translateCropCalendar(
                              selectedLocale: selectedLanguage.languageCode,
                              cropCalendarResponse:
                                  cropCalendarProvider.selectedCropCalendar!);

                          _isLoading = false;
                          setState(() {});
                        } else {
                          // Reset translation if language matches current
                          if (translatedCropCalendarMap != null) {
                            translatedCropCalendarMap!["selectedLocale"] =
                                (cropCalendarProvider
                                        .selectedCropCalendar!.languageCode ??
                                    "en");
                            setState(() {});
                          }
                        }
                      },
                icon: Icon(Icons.translate,
                    size: 20, color: Theme.of(context).colorScheme.onSurface),
                label: Text(
                  AppStrings.translate.tr(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          )
      ],
    );
  }

  // Animates to the current crop calendar stage in PageView
  void animateToPage() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await pageController?.animateToPage(
        initialIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // Determines the initial index to scroll to based on current date
  findInitialIndex(CropCalendarResponseModel? cropCalendarResponse) {
    if (cropCalendarResponse?.crop_calendar != null &&
        cropCalendarResponse!.crop_calendar.isNotEmpty) {
      for (int i = 0; i < cropCalendarResponse.crop_calendar.length; i++) {
        var cropCalendar = cropCalendarResponse.crop_calendar[i];
        var cropCalendarDateFormat = DateFormat("dd-MM-yyyy");
        var startDate =
            cropCalendarDateFormat.parseUtc(cropCalendar.start_date);
        var endDate = cropCalendarDateFormat.parseUtc(cropCalendar.end_date);
        var currentDateTime = DateTime.now();
        var currentDate = DateTime.utc(
            currentDateTime.year, currentDateTime.month, currentDateTime.day);
        if (currentDate.isBefore(startDate)) {
          initialIndex =
              cropCalendarResponse.crop_calendar.indexOf(cropCalendar);
          setState(() {});
          break;
        } else if (currentDate.isAfter(endDate)) {
          continue;
        } else {
          initialIndex =
              cropCalendarResponse.crop_calendar.indexOf(cropCalendar);
          setState(() {});
          break;
        }
      }
      return;
    }
  }
}
