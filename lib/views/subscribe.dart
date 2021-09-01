import 'dart:developer';

import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/appbar.dart';
import 'package:ecoach/widgets/select_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscribePage extends StatefulWidget {
  static const String routeName = '/subscriptions';
  final User user;
  SubscribePage(this.user);

  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage>
    with SingleTickerProviderStateMixin {
  double totalAmount = 0.0;
  late TabController tabController;
  double upperHeight = 0;
  double lowerHeight = 0;

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height;
    upperHeight = height / 2;
    lowerHeight = height / 2;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: SizedBox(
                  height: upperHeight,
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 7,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 4),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new GridTile(
                          child: SelectTile(
                            child: Card(
                              color: Colors.blue,
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 120,
                                      child: Icon(Icons.home_outlined)),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Subject",
                                      style: TextStyle(color: Colors.black),
                                    ),
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
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "$totalAmount",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: "GHC",
                          style: TextStyle(fontSize: 15, color: Colors.black38),
                        ),
                      ])),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Text(
                      "Payment Options",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          tabs: [
                            Tab(
                              text: "Visa/Momo",
                            ),
                            Tab(
                              text: "Wallet",
                            ),
                            Tab(
                              text: "Link",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: lowerHeight,
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 18, 8, 20),
                                      child: Text(
                                        "Pay via visa or mobile money",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity / 2,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text("Click to Pay"),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 18, 8, 20),
                                      child: Text(
                                        "The amount of money in your wallet is ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 10, 8, 12),
                                      child: Text(
                                        "Ghc 300.00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 30),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity / 2,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text("Click to Pay"),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 250,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text("Generate Link"),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            SizedBox(
                                              width: 300,
                                              child: TextField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                    hintText: "generated link",
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("Copy")),
                                            ),
                                            Spacer()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
