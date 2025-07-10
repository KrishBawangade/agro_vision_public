import 'package:agro_vision/pages/main_page/views/market_view_main_page/widgets/filter_bottom_sheet_widget.dart';
import 'package:agro_vision/pages/main_page/views/market_view_main_page/widgets/market_price_details_card.dart';
import 'package:agro_vision/providers/crop_market_provider.dart';
import 'package:agro_vision/providers/current_market_price_filter_provider.dart';
import 'package:agro_vision/services/current_market_price_api/models/current_market_price_record_model.dart';
import 'package:agro_vision/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main Market View Page displaying search, filters, and a list of market prices
class MarketViewMainPage extends StatefulWidget {
  const MarketViewMainPage({super.key});

  @override
  State<MarketViewMainPage> createState() => _MarketViewMainPageState();
}

class _MarketViewMainPageState extends State<MarketViewMainPage> {
  final TextEditingController _searchBarController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Providers for filters and market data
    CurrentMarketPriceFilterProvider filterProvider =
        Provider.of<CurrentMarketPriceFilterProvider>(context);
    CropMarketProvider marketProvider =
        Provider.of<CropMarketProvider>(context);

    // Get list of filtered/search result market price records
    List<CurrentMarketPriceRecordModel> currentMarketPriceRecordList =
        marketProvider.currentMarketPriceRecordList;

    // Sync controller with current search query
    _searchBarController.text = marketProvider.searchQuery;

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          // Search bar and filter icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Search bar with clear and back icon
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: SearchBar(
                  shape: WidgetStateProperty.resolveWith(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _searchBarController,
                  hintText: AppStrings.searchHintTextMarket.tr(),
                  trailing: [
                    _searchBarController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchBarController.text = "";
                              marketProvider.searchCommodities(query: "");
                              setState(() {});
                            },
                            icon: const Icon(Icons.cancel),
                          )
                        : const SizedBox.shrink()
                  ],
                  leading: marketProvider.isSearching
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _searchBarController.text = "";
                            marketProvider.setIsSearching(false);
                            marketProvider.searchCommodities(query: "");
                            setState(() {});
                          },
                        )
                      : const Icon(Icons.search),
                  onTap: () {
                    marketProvider.setIsSearching(true);
                  },
                  onChanged: (query) {
                    marketProvider.searchCommodities(query: query);
                  },
                ),
              ),

              // Filter icon with badge showing active filters
              IconButton(
                onPressed: () {
                  FilterBottomSheetWidget.showFilterBottomSheet(
                    context: context,
                    filterProvider: filterProvider,
                    filterList: [
                      FilterBottomSheetModel(
                        filterName: AppStrings.market,
                        filterItemList:
                            marketProvider.availableMarketList.cast<String>(),
                      )
                    ],
                    onFiltersApplied: () {
                      marketProvider.applyFilters();
                    },
                  );
                },
                icon: Badge(
                  label: Text(filterProvider.appliedFilters.length.toString()),
                  isLabelVisible: filterProvider.appliedFilters.isNotEmpty,
                  child: const Icon(Icons.filter_list),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // List of market price records or empty/loading state
          Expanded(
            child: !marketProvider.isLoading
                ? currentMarketPriceRecordList.isNotEmpty
                    ? Scrollbar(
                        interactive: true,
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: currentMarketPriceRecordList.length,
                          itemBuilder: (context, index) {
                            return MarketPriceDetailsCard(
                              currentMarketPriceRecord:
                                  currentMarketPriceRecordList[index],
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          AppStrings.noDataAvailableMessage.tr(),
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
