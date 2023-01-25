import 'package:ecoach/controllers/filter_controller.dart';
import 'package:ecoach/controllers/store_controller.dart';
import 'package:ecoach/models/plan2.dart';
import 'package:ecoach/revamp/components/store/bundles/bundles_components.dart';
import 'package:ecoach/revamp/core/widget/adeo_search_bar.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class AvailableBundlesPage extends StatefulWidget {
  const AvailableBundlesPage({Key? key}) : super(key: key);

  @override
  State<AvailableBundlesPage> createState() => _FeaturedTestsPageState();
}

class _FeaturedTestsPageState extends State<AvailableBundlesPage> {
  StoreController storeController = StoreController();

  final FilterController filterController = FilterController();
  List<Plan> _plans = [];
  List<String> _selectedFilters = [];
  List<String> _tags = [];
  bool isLoadingFilters = true;
  bool isLoadingBundles = true;
  String searchQuery = "";
  String searchBarText = "";

  @override
  void initState() {
    super.initState();
    getAvailbaleBundles();
  }

  getAvailbaleBundles() async {
    _tags = await filterController.getBundleFilters();
    isLoadingFilters = false;
    filterBundles();
  }

  filterBundles({List<String>? query}) async {
    isLoadingBundles = true;
    _plans = await storeController.filterPlans(
      context,
      query: query ?? [],
    );
    isLoadingBundles = false;
    setState(() {});
  }

  searchAllBundles(query) async {
    isLoadingBundles = true;
    _plans = await storeController.searchPlans(context, query: query);
    isLoadingBundles = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05,
              ),
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              color: kAdeoDark,
              child: Container(
                margin: EdgeInsets.only(top: 36, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Available Bundles",
                            style: kTwentyFourPointText.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: "Poppins",
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          isLoadingFilters
                              ? Container(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: kAdeoGreen,
                                    backgroundColor: Colors.transparent,
                                    strokeWidth: 3.5,
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                      ),
                                      child: Wrap(
                                        children: _tags.map((tag) {
                                          if (!tag.isEmpty) {
                                            return FilterChip(
                                              onSelected: (isSelected) async {
                                                if (!_selectedFilters
                                                    .contains(tag)) {
                                                  _selectedFilters.add(tag);
                                                } else {
                                                  _selectedFilters.removeWhere(
                                                      (filterItem) {
                                                    return tag == filterItem;
                                                  });
                                                }

                                                String _queryFilter =
                                                    _selectedFilters.join(' ');

                                                filterBundles(
                                                  query: _selectedFilters,
                                                );

                                                setState(() {});
                                              },
                                              label: Text(
                                                "${tag}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    strokeAlign:
                                                        StrokeAlign.outside),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              showCheckmark: false,
                                              elevation: 1,
                                              pressElevation: 0,
                                              backgroundColor: kAdeoDark_Gray,
                                              shadowColor: Colors.transparent,
                                              selectedColor: kAdeoDark_Green,
                                              selectedShadowColor:
                                                  Colors.greenAccent[400],
                                              clipBehavior: Clip.antiAlias,
                                              padding: EdgeInsets.all(12),
                                              selected: _selectedFilters
                                                  .contains(tag),
                                            );
                                          }
                                          return Container();
                                        }).toList(),
                                        spacing: 8,
                                        runSpacing: 8,
                                        alignment: WrapAlignment.center,
                                      )),
                                ),
                          SizedBox(
                            height: 18,
                          ),
                          isLoadingBundles
                              ? Container(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: kAdeoGreen,
                                    backgroundColor: Colors.transparent,
                                    strokeWidth: 3.5,
                                  ),
                                )
                              : _plans.isEmpty
                                  ? Column(
                                      children: [
                                        Text(
                                          "No bundles found",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        SizedBox(
                                          height: 18,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            filterBundles();
                                            setState(() {});
                                          },
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white24,
                                            ),
                                          ),
                                          child: Text(
                                            "Reload bundles",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : StoreBundlesComponent(
                                      plans: _plans,
                                    ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                // top: MediaQuery.of(context).size.height * 0.05,
                top: 12,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                color: kAdeoDark,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdeoSearchBox(
                    onChanged: (String val) {
                      searchBarText = val;
                    },
                    onFieldSubmitted: (String query) {
                      searchAllBundles(query);
                      setState(() {});
                    },
                    onSubmit: () {
                      searchAllBundles(searchBarText);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
