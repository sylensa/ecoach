import 'dart:developer';

import 'package:ecoach/controllers/subscribe_controller.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Subscriptions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
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
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 7,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (orientation == Orientation.portrait)
                                            ? 2
                                            : 4),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new GridTile(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubscribePage(widget.user)));
                                    },
                                    child: Card(
                                      shape: Border.all(
                                          color: Colors.black, width: 1),
                                      color: Colors.yellow,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                              height: 120,
                                              child: Icon(Icons.home_outlined)),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Bundle name"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
