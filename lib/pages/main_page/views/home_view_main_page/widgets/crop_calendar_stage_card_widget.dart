// ignore_for_file: use_build_context_synchronously

import 'package:agro_vision/services/gemini_service/models/crop_calendar_item_model.dart';
import 'package:agro_vision/utils/enums.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Widget to display a single crop calendar stage as a card
class CropCalendarStageCardWidget extends StatefulWidget {
  final CropCalendarItemModel cropCalendar; // Data model for one crop stage
  final int index; // Position in the crop calendar list

  const CropCalendarStageCardWidget({
    super.key,
    required this.cropCalendar,
    required this.index,
  });

  @override
  State<CropCalendarStageCardWidget> createState() =>
      _CropCalendarStageCardWidgetState();
}

class _CropCalendarStageCardWidgetState
    extends State<CropCalendarStageCardWidget> {
  CropCalendarStageStatus? cropCalendarStageStatus;
  String? cropCalendarStatusString;

  @override
  Widget build(BuildContext context) {
    // Parsing input dates
    var cropCalendarDateFormat = DateFormat("dd-MM-yyyy");
    var startDate =
        cropCalendarDateFormat.parseUtc(widget.cropCalendar.start_date);
    var endDate = cropCalendarDateFormat.parseUtc(widget.cropCalendar.end_date);

    // Getting current date in UTC without time
    var currentDateTime = DateTime.now();
    var currentDate = DateTime.utc(
        currentDateTime.year, currentDateTime.month, currentDateTime.day);

    // Determining the current stage status based on date comparison
    if (currentDate.isBefore(startDate)) {
      cropCalendarStageStatus = CropCalendarStageStatus.upcoming;
      cropCalendarStatusString = AppStrings.upcoming.tr();
    } else if (currentDate.isAfter(endDate)) {
      cropCalendarStageStatus = CropCalendarStageStatus.completed;
      cropCalendarStatusString = AppStrings.completed.tr();
    } else {
      cropCalendarStageStatus = CropCalendarStageStatus.ongoing;
      cropCalendarStatusString = AppStrings.ongoing.tr();
    }

    // Formatting start and end dates for UI display
    var dateFormat = DateFormat("dd MMM yyyy");
    var formattedStartDate = dateFormat.format(startDate);
    var formattedEndDate = dateFormat.format(endDate);

    // Extracting color for the current stage
    Color cropCalendarColor =
        AppFunctions.hexStringToColor(widget.cropCalendar.colorHexString ?? "");

    // Building the crop calendar stage card
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the current status (Ongoing / Upcoming / Completed)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                cropCalendarStatusString ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      cropCalendarStageStatus == CropCalendarStageStatus.ongoing
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).hintColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Card containing stage information
            Card(
              elevation: 5,
              child: Column(
                children: [
                  // Colored bar at the top of the card
                  Container(height: 8, color: cropCalendarColor),

                  // Stage details section
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 16, top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stage title with index
                        ListTile(
                          title: Text(
                            " ${widget.index + 1}. ${widget.cropCalendar.stage}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Stage description
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Text(
                              widget.cropCalendar.stage_description,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Displaying the date range
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "$formattedStartDate - $formattedEndDate",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
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
