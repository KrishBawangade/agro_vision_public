import 'package:agro_vision/providers/current_market_price_filter_provider.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Model to define each filter category and its options
class FilterBottomSheetModel {
  final String filterName;
  final List<String> filterItemList;

  FilterBottomSheetModel({
    required this.filterName,
    required this.filterItemList,
  });
}

// Widget class to show a bottom sheet for filtering
class FilterBottomSheetWidget {
  static showFilterBottomSheet({
    required BuildContext context,
    required CurrentMarketPriceFilterProvider filterProvider,
    required List<FilterBottomSheetModel> filterList,
    required Function() onFiltersApplied,
  }) {
    // Copying existing applied filters to a local map
    Map<String, List<String>> selectedFiltersMap = {};
    selectedFiltersMap = filterProvider.appliedFilters.map((key, value) {
      return MapEntry(key, List.from(value));
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        int selectedIndex = 0;

        return SafeArea(
          child: StatefulBuilder(builder: (context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.75,
              child: Column(
                children: [
                  // Header with title and Clear button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.filters.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            selectedFiltersMap = {};
                            setState(() {});
                          },
                          child: Text(
                            AppStrings.clearFilters.tr(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Body containing filter categories and filter items
                  Expanded(
                    child: Row(
                      children: [
                        // Filter category list (left side)
                        Container(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          width: 100,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filterList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        if (selectedIndex != index) {
                                          selectedIndex = index;
                                          setState(() {});
                                        }
                                      },
                                      selected: selectedIndex == index,
                                      selectedColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      title: Text(
                                        filterList[index].filterName.tr(),
                                        style: TextStyle(
                                          fontWeight: selectedIndex == index
                                              ? FontWeight.bold
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Filter items list (right side)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filterList[selectedIndex]
                                        .filterItemList
                                        .length,
                                    itemBuilder: (context, index) {
                                      String filterName =
                                          filterList[selectedIndex].filterName;
                                      String filterValue =
                                          filterList[selectedIndex]
                                              .filterItemList[index];

                                      return CheckboxListTile(
                                        title: Text(filterValue),
                                        value: selectedFiltersMap[filterName]
                                                ?.contains(filterValue) ??
                                            false,
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (newValue ?? false) {
                                              selectedFiltersMap[filterName] ??=
                                                  [];
                                              selectedFiltersMap[filterName]!
                                                  .add(filterValue);
                                            } else {
                                              selectedFiltersMap[filterName]
                                                  ?.remove(filterValue);
                                              if (selectedFiltersMap[filterName]
                                                      ?.isEmpty ??
                                                  false) {
                                                selectedFiltersMap
                                                    .remove(filterName);
                                              }
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons: Cancel and Apply
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            // Apply selected filters
                            filterProvider.setAppliedFilters(
                                Map.from(selectedFiltersMap));
                            onFiltersApplied();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Apply"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
