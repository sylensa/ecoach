import 'package:ecoach/controllers/store_controller.dart';
import 'package:ecoach/revamp/components/store/available_bundles.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  StoreController storeController = StoreController();
  var _filters = [];

  @override
  Widget build(BuildContext context) {
    List _tags = [];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24),
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                color: kAdeoDark,
                child: Container(
                  margin: EdgeInsets.only(top:56, bottom: 24),
                  constraints: BoxConstraints(
                    maxWidth: 1200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        constraints: BoxConstraints(
                          maxWidth: 1200,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Find the best\ncourses for you!",
                                    style: kTwentyFourPointText.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        fontFamily: "Poppins"),
                                    textAlign: TextAlign.center,
                                  ),
                                  // SizedBox(
                                  //   height: 24,
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 36,
                            ),
                            AvailableBundlesStoreComponent(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
