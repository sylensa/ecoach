import 'package:ecoach/controllers/store_controller.dart';
import 'package:ecoach/models/plan2.dart';
import 'package:ecoach/revamp/features/store/all_bundles.dart';
import 'package:ecoach/revamp/features/store/store_item_details.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/section_heading.dart';
import 'package:ecoach/revamp/components/store/store_card.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AvailableBundlesStoreComponent extends StatefulWidget {
  const AvailableBundlesStoreComponent({
    Key? key,
  }) : super(key: key);

  @override
  State<AvailableBundlesStoreComponent> createState() =>
      _AvailableBundlesStoreComponentState();
}

class _AvailableBundlesStoreComponentState
    extends State<AvailableBundlesStoreComponent> {
  StoreController storeController = StoreController();
  int selectedPlanId = -1;
  handleSelectChange(index) {
    setState(() {
      selectedPlanId = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    late List<Plan> plans = [];
    late bool hasReturnedPlansCall = false;

    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SectionHeading(
                  "Available Bundles",
                  textStyle: TextStyle(
                      fontSize: 18, color: Colors.white, fontFamily: "Poppins"),
                ),
                SectionHeaderTextButton(
                  label: 'See all',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AvailableBundlesPage();
                    }));
                  },
                  foregroundColor: kAdeoDark_Gray2,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 28,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: FutureBuilder<List<Plan>>(
              future: storeController.getPlans(context),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return SizedBox(
                      width: 12,
                      height: 12,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: kAdeoGreen4,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else if (snapshot.data != null) {
                      plans = snapshot.data!;
                      hasReturnedPlansCall = true;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: plans.map((plan) {
                          if (plans.indexOf(plan) < 6) {
                            if (plans.length - 1 != plans.indexOf(plan)) {
                              return Padding(
                                padding: EdgeInsets.only(right: 14),
                                child: StoreCard(
                                  maxWidth: 300,
                                  label: plan.name.toString(),
                                  isBundle: true,
                                  description: plan.description,
                                  bundlePrice: money(
                                    plan.price!,
                                  ),
                                  cardImage:
                                      "assets/images/store/store-img-4.png",
                                  onClick: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return StoreItemDetailsPage(
                                            itemProps: {
                                              "bundleId": plan.id,
                                              "itemType": StoreDetails.BUNDLE,
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            return StoreCard(
                              label: plan.name.toString(),
                              isBundle: true,
                              maxWidth: 300,
                              description: plan.description,
                              bundlePrice: money(
                                plan.price!,
                              ),
                              cardImage: "assets/images/store/store-img-4.png",
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return StoreItemDetailsPage(
                                        itemProps: {
                                          "bundleId": plan.id,
                                          "itemType": StoreDetails.BUNDLE,
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
