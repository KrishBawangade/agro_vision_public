// Required imports
import 'package:agro_vision/models/farm_plot_model.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// A reusable card widget to display a single Farm Plot's details with edit/delete options
class FarmPlotItem extends StatelessWidget {
  // Farm plot data to display
  final FarmPlotModel farmPlotItem;

  // Callback for edit button
  final Function(FarmPlotModel) onEdit;

  // Callback for delete button
  final Function(FarmPlotModel) onDelete;

  const FarmPlotItem({
    super.key,
    required this.farmPlotItem,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Format the plantation date from milliseconds to readable format
    DateFormat dateFormat = DateFormat("dd MMM yyyy");
    DateTime dateTimePlantation =
        DateTime.fromMillisecondsSinceEpoch(farmPlotItem.plantationDateMillis);
    var formattedPlantationDate = dateFormat.format(dateTimePlantation);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
            child: Column(
              children: [
                // Main ListTile containing title and subtitle sections
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row containing edit and delete buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              onEdit(farmPlotItem);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              onDelete(farmPlotItem);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Farm plot name
                      Text(
                        farmPlotItem.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Divider for visual separation
                      const Divider()
                    ],
                  ),

                  // Additional farm plot details shown below the title
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Crop type
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppStrings.crop.tr(),
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                              ),
                              TextSpan(
                                text: farmPlotItem.crop,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Area value with unit
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${AppStrings.area.tr()}: ",
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                              ),
                              TextSpan(
                                text:
                                    "${farmPlotItem.areaValue} ${farmPlotItem.areaUnit.name}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Plantation date row with calendar icon
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 24),
                            const SizedBox(width: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppStrings.planted.tr(),
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor),
                                  ),
                                  TextSpan(
                                    text: formattedPlantationDate,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
