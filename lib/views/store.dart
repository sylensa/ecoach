import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/subscribe_controller.dart';
import 'package:ecoach/api/api_response.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'subscribe.dart';

class StorePage extends StatefulWidget {
  static const String routeName = '/store';
  final User user;
  StorePage(this.user);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  SubscribeController subscribeController = Get.put(SubscribeController());

  List<Plan> monthlyPlan = [];
  List<Plan> annuallyPlan = [];

  Future? futureItem;

  @override
  void initState() {
    super.initState();

    futureItem = ApiCall<Plan>(
      AppUrl.plans,
      user: widget.user,
      create: (dataItem) {
        return Plan.fromJson(dataItem);
      },
    ).get(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: kPageBackgroundGray,
          body: Column(
            children: [
              PageHeader(pageHeading: 'Select Your Bundle'),
              Expanded(
                child: FutureBuilder(
                  future: futureItem,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Container();
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );

                      case ConnectionState.done:
                        if (snapshot.data != null) {
                          annuallyPlan.clear();
                          List<Plan> plans = snapshot.data as List<Plan>;
                          plans.forEach((plan) {
                            if (plan.invoiceInterval == "year") {
                              annuallyPlan.add(plan);
                            }
                          });
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: annuallyPlan.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    0,
                                    24,
                                    0,
                                  ),
                                  child: MultiPurposeCourseCard(
                                    title: annuallyPlan[index].name!,
                                    subTitle: annuallyPlan[index].description!,
                                    subscription:
                                        money(annuallyPlan[index].price!),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SubscribePage(widget.user, annuallyPlan[index]);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "A problem ocurred",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              "There are no items in the store",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showCodePopup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              color: Colors.grey.shade400,
              height: 300,
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 18, 8, 20),
                      child: Text(
                        "Enter your voucher code below",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: "Enter code",
                              border: OutlineInputBorder())),
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("Subscribe")),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
