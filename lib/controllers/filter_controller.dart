import 'package:ecoach/api2/api_call_no_context.dart';
import 'package:ecoach/models/filter.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:flutter/material.dart';

class FilterController extends ChangeNotifier {
  List<String> bundleFilters = [];
  List<String> selectedFilters = [];

  void setBundleFilters(filters) {
    bundleFilters = filters!;
  }

  void toggleActiveFilterButton(bool isSelected, filter) {
    if (isSelected) {
      selectedFilters.add(filter);
    } else {
      selectedFilters.removeWhere((filterItem) {
        return filter == filterItem;
      });
    }
  }

  getBundleFilters() async {
    try {
      var response = await getAPI(
        AppUrl.planFilters,
        isList: false,
      );

      BundleFilter bundleFilter = BundleFilter.fromJson(response["data"]);

      return bundleFilter.filters;
    } catch (e) {
      print(e);
    }
  }
}
