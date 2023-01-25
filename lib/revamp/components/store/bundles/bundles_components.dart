import 'package:ecoach/controllers/store_controller.dart';
import 'package:ecoach/models/plan2.dart';
import 'package:ecoach/revamp/components/store/store_card.dart';
import 'package:ecoach/revamp/features/store/store_item_details.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class StoreBundlesComponent extends StatefulWidget {
  const StoreBundlesComponent({
    Key? key,
    this.plans,
  }) : super(key: key);
  final List<Plan>? plans;

  @override
  State<StoreBundlesComponent> createState() => _StoreBundlesState();
}

class _StoreBundlesState extends State<StoreBundlesComponent> {
  StoreController storeController = StoreController();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 12 / 16,
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
        ),
        width: double.maxFinite,
        child: ListView.builder(
            padding: EdgeInsets.only(
              bottom: 24,
            ),
            itemCount: widget.plans!.length,
            itemBuilder: ((context, index) {
              Plan plan = widget.plans![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: StoreCard(
                  label: plan.name.toString(),
                  isBundle: true,
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
                              "bundleId": plan.id.toString(),
                              "itemType": StoreDetails.BUNDLE,
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            })

            // Wrap(
            //   alignment: WrapAlignment.center,
            //   spacing: 14,
            //   runSpacing: 24,
            //   children: widget.plans!.map((plan) {
            //     return StoreCard(
            //       label: plan.name.toString(),
            //       isBundle: true,
            //       description: plan.description,
            //       bundlePrice: money(
            //         plan.price!,
            //       ),
            //       cardImage: "assets/images/store/store-img-4.png",
            //       onClick: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) {
            //               return StoreItemDetailsPage(
            //                 itemProps: {
            //                   "bundleId": plan.id.toString(),
            //                   "itemType": StoreDetails.BUNDLE,
            //                 },
            //               );
            //             },
            //           ),
            //         );
            //       },
            //     );
            // }).toList(),
            ),
      ),
    );
  }
}
