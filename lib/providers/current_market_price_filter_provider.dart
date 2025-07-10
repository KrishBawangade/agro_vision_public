import 'package:agro_vision/services/current_market_price_api/models/current_market_price_record_model.dart';
import 'package:flutter/material.dart';

class CurrentMarketPriceFilterProvider extends ChangeNotifier {
  // Stores the filtered list of market price records after applying filters
  List<CurrentMarketPriceRecordModel> _filteredRecordList = [];

  // Stores the filters currently applied, categorized by filter type (e.g., market, grade)
  Map<String, List<String>> _appliedFilters = {};

  // Getter for applied filters
  Map<String, List<String>> get appliedFilters => _appliedFilters;

  // Getter for the filtered market price records
  List<CurrentMarketPriceRecordModel> get filteredRecordList => _filteredRecordList;

  // Updates the applied filters and notifies listeners to rebuild UI
  void setAppliedFilters(Map<String, List<String>> filters) {
    _appliedFilters = Map.from(filters); // Create a copy to avoid reference issues
    notifyListeners(); // Notify listeners that the filters have changed
  }

  // Updates the filtered list of records and notifies listeners to rebuild UI
  void setFilteredRecordList(List<CurrentMarketPriceRecordModel> filteredRecordList) {
    _filteredRecordList = List.from(filteredRecordList); // Create a copy of the list
    notifyListeners(); // Notify listeners that the filtered records have changed
  }
}
