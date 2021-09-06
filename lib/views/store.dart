import 'package:ecoach/controllers/subscribe_controller.dart';
import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
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
  List<bool> _isSelected = [false, false, false, true];
  var futurePlans;

  @override
  void initState() {
    super.initState();

    futurePlans = getPlans();
  }

  getPlans() async {
    http.Response response = await http.get(
      Uri.parse(AppUrl.plans),
      headers: {
        "api-token": widget.user.token!,
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    print("response returned");
    print("${response.statusCode}");
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        print("messages returned");
        print(response.body);
        return ApiResponse<Plan>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          return Plan.fromJson(dataItem);
        });
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade200,
        body: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Store",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        Icon(
                          Icons.shopping_cart,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue.shade600)),
                      onPressed: () {
                        showCodePopup(context);
                      },
                      child: Text("Voucher Code"),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select time period"),
            ),
            ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Month"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Quarter"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Half"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Year"),
                )
              ],
              isSelected: _isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                });
              },
              color: Colors.black,
              selectedColor: Colors.orange.shade100,
              fillColor: Colors.blue.shade600,
              borderColor: Colors.blue.shade700,
              selectedBorderColor: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            Expanded(
                child: FutureBuilder(
              future: futurePlans,
              builder: (context, snapshot) {
                print(snapshot.data);
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data != null) {
                      ApiResponse response = snapshot.data! as ApiResponse;

                      List<Plan>? plans = response.data as List<Plan>;
                      print(plans);
                      return SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    child: plans.length > 0
                                        ? Container(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: plans.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        20, 12, 20, 12),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return SubscribePage(
                                                              widget.user,
                                                              plans[index]);
                                                        }));
                                                      },
                                                      highlightColor:
                                                          Colors.blue.shade600,
                                                      child: Container(
                                                        // height: 80,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(14.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  plans[index]
                                                                      .name!,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              Spacer(),
                                                              Text(
                                                                  money(plans[
                                                                          index]
                                                                      .price!),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Container(
                                            child: SizedBox(
                                              height: 400,
                                              child: Center(
                                                child: Text(
                                                    "There are no items in the store"),
                                              ),
                                            ),
                                          ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.data == null)
                      return Container(
                          child: Center(
                        child: Text("There are no items in the store"),
                      ));
                    else
                      return Container();
                }
              },
            )),
          ],
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
