import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/providers/crop_calendar_provider.dart';
import 'package:agro_vision/providers/farm_plot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dropdown widget to select a farm plot for the crop calendar
class CropCalendarDropDownButton extends StatefulWidget {
  const CropCalendarDropDownButton({super.key});

  @override
  State<CropCalendarDropDownButton> createState() =>
      _CropCalendarDropDownButtonState();
}

class _CropCalendarDropDownButtonState
    extends State<CropCalendarDropDownButton> {
  String? selectedFarmPlotName;

  @override
  Widget build(BuildContext context) {
    // Accessing providers
    FarmPlotProvider farmPlotProvider = Provider.of<FarmPlotProvider>(context);
    CropCalendarProvider cropCalendarProvider =
        Provider.of<CropCalendarProvider>(context);

    // Check if the currently selected farmPlotId exists in the farmPlotList
    var hasFarmPlot = farmPlotProvider.farmPlotList.any((farmPlot) {
      return farmPlot.id == cropCalendarProvider.selectedFarmPlotId;
    });

    // Handle default or invalid selection cases
    if (cropCalendarProvider.selectedFarmPlotId.isEmpty) {
      // If no selection yet, default to first farm plot
      selectedFarmPlotName = farmPlotProvider.farmPlotList[0].name;
      cropCalendarProvider.setSelectedFarmPlotIdAndNameListenFalse(
          farmPlotId: farmPlotProvider.farmPlotList[0].id,
          farmPlotName: selectedFarmPlotName);
    } else if (!hasFarmPlot) {
      // If the selected ID doesn't exist anymore, reset to first
      selectedFarmPlotName = farmPlotProvider.farmPlotList[0].name;
      cropCalendarProvider.setSelectedFarmPlotIdAndNameListenFalse(
          farmPlotId: farmPlotProvider.farmPlotList[0].id,
          farmPlotName: selectedFarmPlotName);
    } else {
      // Otherwise, set the name from the selected ID
      for (int i = 0; i < farmPlotProvider.farmPlotList.length; i++) {
        var farmPlot = farmPlotProvider.farmPlotList[i];
        if (farmPlot.id == cropCalendarProvider.selectedFarmPlotId) {
          selectedFarmPlotName = farmPlot.name;
          break;
        }
      }
    }

    // Build the dropdown
    return DropdownButton(
        value: selectedFarmPlotName,
        items: farmPlotProvider.farmPlotList.map((farmPlot) {
          return DropdownMenuItem(
              value: farmPlot.name, child: Text(farmPlot.name));
        }).toList(),
        onChanged: (value) {
          // Update selection when user changes it
          selectedFarmPlotName = value;
          FarmPlotModel? selectedFarmPlot;

          // Find the selected farm plot object by name
          for (int i = 0; i < farmPlotProvider.farmPlotList.length; i++) {
            var farmPlot = farmPlotProvider.farmPlotList[i];
            if (farmPlot.name == selectedFarmPlotName) {
              selectedFarmPlot = farmPlot;
              break;
            }
          }

          // Update crop calendar provider with new selection
          cropCalendarProvider.setSelectedFarmPlotIdAndName(
              farmPlotId: selectedFarmPlot?.id ?? "",
              farmPlotName: selectedFarmPlotName);

          // Refresh the widget to reflect changes
          setState(() {});
        });
  }
}
