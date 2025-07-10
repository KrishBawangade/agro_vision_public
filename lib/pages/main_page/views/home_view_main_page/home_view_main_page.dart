// Imports for models, widgets, providers, and utilities
import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/pages/add_farm_plot_page/add_edit_farm_plot_page.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/crop_calendar_drop_down_button.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/crop_calendar_widget.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/farm_plot_item.dart';
import 'package:agro_vision/pages/main_page/views/home_view_main_page/widgets/weather_updates_card.dart';
import 'package:agro_vision/pages/recommendations_for_crop_page/recommendations_for_crop_page.dart';
import 'package:agro_vision/providers/crop_calendar_provider.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:agro_vision/providers/translation_provider.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:agro_vision/widgets/calculating_environment_values_dialog.dart';
import 'package:agro_vision/widgets/select_language_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main Home View used in the app
class HomeViewMainPage extends StatefulWidget {
  const HomeViewMainPage({super.key});

  @override
  State<HomeViewMainPage> createState() => _HomeViewMainPageState();
}

class _HomeViewMainPageState extends State<HomeViewMainPage> {
  bool _isLoading = false; // Controls translation loading state

  @override
  Widget build(BuildContext context) {
    // Accessing providers
    FarmPlotProvider farmPlotProvider = Provider.of<FarmPlotProvider>(context);
    CropCalendarProvider cropCalendarProvider =
        Provider.of<CropCalendarProvider>(context);
    TranslationProvider translationProvider = Provider.of(context);

    // If translated farm plots are available, use them. Else fallback to original.
    Map<String, dynamic>? translatedFarmPlotListMap =
        translationProvider.selectedLocaleFarmPlot;
    List<FarmPlotModel> farmPlotList =
        translatedFarmPlotListMap?["farmPlotList"] ??
            farmPlotProvider.farmPlotList;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Show calendar dropdown only if farm plots exist
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                farmPlotList.isNotEmpty
                    ? const CropCalendarDropDownButton()
                    : const SizedBox.shrink(),
              ],
            ),

            const SizedBox(height: 32),

            // AI Crop Recommendation Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
              ),
              onPressed: () {
                // Get crop name from selected farm plot
                FarmPlotModel? selectedFarmPlot;
                farmPlotProvider.farmPlotList.any((farmPlot) {
                  bool isFarmPlot =
                      farmPlot.id == cropCalendarProvider.selectedFarmPlotId;
                  if (isFarmPlot) selectedFarmPlot = farmPlot;
                  return isFarmPlot;
                });

                var cropName = selectedFarmPlot?.crop ?? "";
                if (cropName.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          RecommendationsForCropPage(cropName: cropName)));
                } else {
                  AppFunctions.showSnackBar(
                      context: context,
                      msg: AppStrings
                          .addFarmPlotToGenerateRecommendationsMessage
                          .tr());
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.getSuggestionsFromAI.tr()),
                    const SizedBox(width: 8),
                    Icon(Icons.psychology,
                        color: Theme.of(context).colorScheme.onTertiary)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Crop Calendar Timeline Widget
            const CropCalendarWidget(),

            const SizedBox(height: 16),

            // Weather Section
            Text(
              AppStrings.weatherUpdates.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            const WeatherUpdatesCard(),

            const SizedBox(height: 16),

            // Farm Plots Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppStrings.farmPlots.tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(width: 32),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const AddEditFarmPlotPage()));
                  },
                )
              ],
            ),

            const SizedBox(height: 8),

            // Farm Plot List View
            Column(
              children: [
                !farmPlotProvider.isLoading && !_isLoading
                    ? farmPlotList.isNotEmpty
                        ? SizedBox(
                            height: 250,
                            child: ListView.builder(
                              itemCount: farmPlotList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return FarmPlotItem(
                                  farmPlotItem: farmPlotList[index],
                                  onEdit: (farmPlotItem) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => AddEditFarmPlotPage(
                                                farmPlot:
                                                    farmPlotList[index])));
                                  },
                                  onDelete: (farmPlotItem) async {
                                    // Show loader dialog
                                    CalculatingEnvironmentValuesDialog.show(
                                        context,
                                        message:
                                            AppStrings.pleaseWaitMessage.tr());

                                    var selectedFarmPlotId =
                                        cropCalendarProvider.selectedFarmPlotId;

                                    try {
                                      await farmPlotProvider.deleteFarmPlot(
                                          farmPlot: farmPlotItem,
                                          cropCalendarResponseList:
                                              cropCalendarProvider
                                                  .cropCalendarResponseList,
                                          onFarmPlotDeleted: () {
                                            if (selectedFarmPlotId ==
                                                farmPlotItem.id) {
                                              // Set fallback selected plot
                                              cropCalendarProvider
                                                  .setSelectedFarmPlotIdAndName(
                                                      farmPlotId:
                                                          farmPlotList[0].id,
                                                      farmPlotName:
                                                          farmPlotList[0].name);
                                            }
                                          });
                                    } on Exception catch (e) {
                                      if (kDebugMode) {
                                        debugPrint("Error occurred : $e");
                                      }
                                    }

                                    if (context.mounted) {
                                      CalculatingEnvironmentValuesDialog.hide(
                                          context);
                                    }
                                  },
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              AppStrings.noFarmPlotAddedAddFarmPlotMessage.tr(),
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            ),
                          )
                    : const Center(child: CircularProgressIndicator()),

                const SizedBox(height: 16),

                // Translate Button if farm plots exist
                if (farmPlotProvider.farmPlotList.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isLoading ||
                                farmPlotProvider.localizedCropResponse.isEmpty
                            ? null
                            : () async {
                                // Open bottom sheet to select language
                                Locale? selectedLanguage =
                                    await SelectLanguageBottomSheet.show(
                                  context,
                                  Locale(translatedFarmPlotListMap?[
                                          "selectedLocale"] ??
                                      "en"),
                                );

                                if (selectedLanguage != null &&
                                    farmPlotProvider.farmPlotList.isNotEmpty) {
                                  setState(() => _isLoading = true);
                                  await translationProvider
                                      .translateFarmPlotList(
                                          selectedLocale:
                                              selectedLanguage.languageCode,
                                          farmPlotList:
                                              farmPlotProvider.farmPlotList,
                                          farmPlotProvider: farmPlotProvider);
                                  _isLoading = false;
                                  setState(() {});
                                }
                              },
                        icon: Icon(Icons.translate,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurface),
                        label: Text(
                          AppStrings.translate.tr(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
