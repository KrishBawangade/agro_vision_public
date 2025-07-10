// Importing necessary packages and files
import 'package:agro_vision/services/gemini_service/models/crop_calendar_response_model.dart';
import 'package:agro_vision/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// A stateless widget to display crop stages on a calendar view
class CropStageCalendarView extends StatelessWidget {
  // Crop calendar data to be displayed
  final CropCalendarResponseModel? cropCalendarResponse;

  const CropStageCalendarView({super.key, required this.cropCalendarResponse});

  @override
  Widget build(BuildContext context) {
    // Current day at midnight (UTC) for consistent comparisons
    var currentDateTime = DateTime.now();
    var currentDayUtc = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day);

    // Return the calendar widget
    return TableCalendar(
      focusedDay: currentDayUtc,
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(DateTime.now().year + 6),
      startingDayOfWeek: StartingDayOfWeek.monday,
      weekendDays: const [],
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      headerStyle:
          const HeaderStyle(titleCentered: true, formatButtonVisible: false),
      calendarStyle: const CalendarStyle(outsideDaysVisible: false),

      // Custom builder to render specific day cells
      calendarBuilders: CalendarBuilders(
        // Builder for today’s date
        todayBuilder: (context, day, focusedDay) {
          var dayUtc = day.toUtc();
          Color? cropCalendarColor;
          String? toolTipMessage;

          // Check if crop calendar has data
          if (cropCalendarResponse != null) {
            // Look for a stage that includes the current day
            bool hasAnyEvent =
                cropCalendarResponse!.crop_calendar.any((cropCalendar) {
              DateFormat dateFormat = DateFormat("dd-MM-yyyy");
              DateTime startDate =
                  dateFormat.parseUtc(cropCalendar.start_date);
              DateTime endDate = dateFormat.parseUtc(cropCalendar.end_date);

              // Check if day is within stage range
              bool isInRange = dayUtc.isAfter(
                      startDate.subtract(const Duration(days: 1))) &&
                  dayUtc.isBefore(endDate.add(const Duration(days: 1)));

              if (isInRange) {
                // Get color and stage name
                String cropCalendarColorHexString =
                    cropCalendar.colorHexString ?? "";
                cropCalendarColor = AppFunctions.hexStringToColor(
                    cropCalendarColorHexString);
                toolTipMessage = cropCalendar.stage;
                return true;
              } else {
                return false;
              }
            });

            // If an event is found on the current day
            if (hasAnyEvent) {
              return Tooltip(
                message: toolTipMessage,
                triggerMode: TooltipTriggerMode.tap,
                child: Container(
                  decoration: BoxDecoration(
                    color: day.toUtc() == focusedDay.toUtc()
                        ? cropCalendarColor?.withAlpha(54)
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text("${day.day}"),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // No crop stage for today
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text("${day.day}"),
                  ),
                ),
              );
            }
          } else {
            // If cropCalendarResponse is null
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text("${day.day}",
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            );
          }
        },

        // Builder for all other days (not today)
        defaultBuilder: (context, day, focusedDay) {
          var dayUtc = day.toUtc();
          Color? cropCalendarColor;
          String? toolTipMessage;

          // Check if crop calendar is available
          if (cropCalendarResponse != null) {
            // Find if this day matches any crop calendar stage
            bool hasAnyEvent =
                cropCalendarResponse!.crop_calendar.any((cropCalendar) {
              DateFormat dateFormat = DateFormat("dd-MM-yyyy");
              DateTime startDate =
                  dateFormat.parseUtc(cropCalendar.start_date);
              DateTime endDate = dateFormat.parseUtc(cropCalendar.end_date);

              // Check if the date falls within a crop stage range
              bool isInRange = dayUtc.isAfter(
                      startDate.subtract(const Duration(days: 1))) &&
                  dayUtc.isBefore(endDate.add(const Duration(days: 1)));

              if (isInRange) {
                cropCalendarColor = AppFunctions.hexStringToColor(
                    cropCalendar.colorHexString ?? "");
                toolTipMessage = cropCalendar.stage;
                return true;
              } else {
                return false;
              }
            });

            // If a crop event exists for this day
            if (hasAnyEvent) {
              return Tooltip(
                message: toolTipMessage,
                triggerMode: TooltipTriggerMode.tap,
                child: Container(
                  decoration: BoxDecoration(
                    color: cropCalendarColor?.withAlpha(54),
                  ),
                  child: Center(
                    child: Text(
                      "${day.day}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            } else {
              // No crop event for this day
              return null;
            }
          } else {
            // No crop calendar data at all
            return null;
          }
        },
      ),
    );
  }
}
