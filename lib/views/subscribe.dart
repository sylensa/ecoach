import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ecoach/models/store_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/appbar.dart';
import 'package:ecoach/widgets/select_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

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
  TextEditingController linkTextController = new TextEditingController();

  double upperHeight = 0;
  double lowerHeight = 0;
  List<StoreItem> items = [
    StoreItem('Science', 20, selected: true),
    StoreItem('Maths', 20, selected: true),
    StoreItem('English', 20, selected: true),
    StoreItem('Social Studies', 20, selected: true),
    StoreItem('French', 20, selected: true),
    StoreItem('Technical Skills', 20, selected: true),
    StoreItem('Twi', 20, selected: true),
  ];

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    calculateTotal();
    super.initState();
  }

  calculateTotal() {
    totalAmount = 0;
    items.forEach((item) {
      if (item.selected) {
        totalAmount += item.price;
      } else {
        totalAmount -= item.price;
      }
    });
  }

  Future<String?> getUrlFrmInitialization(
      {String? email, required double amount, List<String>? metadata}) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Initializing payment...."),
    ));
    String? url;
    String? email = widget.user.email;
    if (email == null || email.isEmpty) {
      email = "${widget.user.phone}@shammah.com";
    }
    try {
      final Map<String, dynamic> paymentData = {
        'email': email,
        'phone': widget.user.phone,
        'amount': amount,
        'metadata':
            json.encode("{purpose: buying book, description: I want to learn}"),
      };
      print("making call..........");
      print(amount);
      http.Response response = await http.post(
        Uri.parse("https://dev.shammahapp.com/api/paystack/initialize"),
        body: json.encode(paymentData),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      print("url = $responseData['data']");
      if (responseData['status'] == true) {
        url = responseData['data']['authorization_url'];
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      }
    } catch (e, m) {
      print("${e.toString()}");
      print("$m");
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            "There was a problem initializing payment. Please try again later"),
      ));
    }

    return url;
  }

  authorisePayment(BuildContext context) async {
    String? authorizationUrl = await getUrlFrmInitialization(
        email: widget.user.email, amount: totalAmount);
    if (authorizationUrl == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: authorizationUrl,
          navigationDelegate: (navigation) {
            //Listen for callback URL
            if (navigation.url.contains('https://standard.paystack.co/close')) {
              Navigator.of(context).pop(); //close webview
            }
            if (navigation.url
                .contains("https://dev.shammahapp.com/api/paystack/callback")) {
              Navigator.of(context).pop(); //close webview

              setState(() {
                // clearTextInput();
                // clearInput();
              });

              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => PaymentHistory()),(Route<dynamic> route) => false
              // );

            }
            return NavigationDecision.navigate;
          },
        );
      },
    );
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
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 4),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new GridTile(
                          child: SelectTile(
                            selected: items[index].selected,
                            color: Colors.transparent,
                            selectColor: Colors.green,
                            callback: (selected) {
                              setState(() {
                                print("subscribe $selected");
                                items[index].selected = selected;
                                calculateTotal();
                              });
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  SizedBox(child: Icon(Icons.home_outlined)),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      items[index].name,
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
                                            onPressed: () {
                                              authorisePayment(context);
                                            },
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
                                          onPressed: () async {
                                            String? link =
                                                await getUrlFrmInitialization(
                                                    amount: totalAmount);
                                            linkTextController.text = link!;
                                          },
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
                                                controller: linkTextController,
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
                                                  onPressed: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text:
                                                                linkTextController
                                                                    .text));
                                                  },
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
