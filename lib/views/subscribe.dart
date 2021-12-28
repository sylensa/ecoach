import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/store_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/user_setup.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:ecoach/widgets/appbar.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/select_tile.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class SubscribePage extends StatefulWidget {
  static const String routeName = '/subscriptions';
  final User user;
  final Plan plan;
  SubscribePage(this.user, this.plan);

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
  late String generatedLink = '';

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
    totalAmount = widget.plan.price!;
    super.initState();
  }

  Future<String?> getUrlFrmInitialization(
      {String? email, required double amount, List<String>? metadata}) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Initializing payment information ..."),
    ));
    String? url;
    String? email = widget.user.email;
    if (email == null || email.isEmpty) {
      email = "${widget.user.phone}@ecoach.com";
    }
    try {
      final Map<String, dynamic> paymentData = {
        'email': email,
        'phone': widget.user.phone,
        'amount': amount,
        "plan_id": widget.plan.id,
        'metadata':
            json.encode("{purpose: buying book, description: I want to learn}"),
      };
      print("making call..........");
      print(amount);
      http.Response response = await http.post(
        Uri.parse(AppUrl.payment_initialize),
        body: json.encode(paymentData),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'api-token': widget.user.token!
        },
      );

      print(response.body);

      final Map<String, dynamic> responseData = json.decode(response.body);

      print("url = $responseData['data']");
      if (responseData['status'] == true) {
        url = responseData['data']['authorization_url'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['message']),
        ));
      }
    } catch (e, m) {
      print(e);
      print(m);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: authorizationUrl,
          navigationDelegate: (navigation) async {
            //Listen for callback URL
            if (navigation.url.contains('https://standard.paystack.co/close')) {
              Navigator.of(context).pop(); //close webview
            }
            if (navigation.url.contains(AppUrl.payment_callback)) {
              Navigator.of(context).pop(); //close webview

              setState(() {});

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserSetup(widget.user)),
                  (Route<dynamic> route) => false);
            }
            return NavigationDecision.navigate;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    upperHeight = height / 2;
    lowerHeight = height / 2;

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: kAdeoGray,
        //   shadowColor: Colors.transparent,
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back_sharp),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   title: Center(
        //     child: Text("${widget.plan.name}"),
        //   ),
        //   // actions: [
        //   //   Icon(Icons.more_vert),
        //   // ],
        // ),
        backgroundColor: kPageBackgroundGray,
        body: Column(
          children: [
            Container(
              height: 56.0,
              child: Center(
                child: Text(
                  "${widget.plan.name}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 3.0,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(height: 24.0),
                      Text(
                        'GHS',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Helvetica Rounded',
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    totalAmount
                        .toString()
                        .substring(0, totalAmount.toString().indexOf('.')),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Helvetica Rounded',
                      fontSize: 80.0,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '.00',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Helvetica Rounded',
                          fontSize: 24.0,
                        ),
                      ),
                      Container(height: 48.0),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 3.0,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "Payment Options",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.0),
            AdeoTabControl(
              variant: 'black',
              tabs: ['Visa/MoMo', 'wallet', 'link'],
              tabPages: [
                ThirdPartyPay(
                  onPressed: () {
                    authorisePayment(context);
                  },
                ),
                WalletPay(
                  amount: widget.user.wallet.amount,
                  onPressed: () {},
                ),
                LinkPay(
                  link: generatedLink,
                  onPressed: () async {
                    String? link = await getUrlFrmInitialization(
                      amount: totalAmount,
                    );
                    setState(() {
                      generatedLink = link!;
                    });
                  },
                ),
              ],
            ),
            // Container(
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            //         child: RichText(
            //             text: TextSpan(children: [
            //           TextSpan(
            //             text: "$totalAmount",
            //             style: TextStyle(
            //                 fontSize: 80,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.black),
            //           ),
            //           TextSpan(
            //             text: "GHC",
            //             style: TextStyle(fontSize: 25, color: Colors.black),
            //           ),
            //         ])),
            //       ),
            //       Text(
            //         "Payment Options",
            //         style: TextStyle(
            //             fontSize: 20,
            //             color: Colors.black,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       SizedBox(
            //         height: 10,
            //       ),
            //       Column(
            //         children: [
            //           TabBar(
            //             controller: tabController,
            //             tabs: [
            //               Tab(
            //                 text: "Visa/Momo",
            //               ),
            //               Tab(
            //                 text: "Wallet",
            //               ),
            //               Tab(
            //                 text: "Link",
            //               ),
            //             ],
            //           ),
            //           SizedBox(
            //             height: lowerHeight,
            //             child: TabBarView(
            //               controller: tabController,
            //               children: [
            //                 Container(
            //                   child: Column(
            //                     children: [
            //                       Padding(
            //                         padding: const EdgeInsets.fromLTRB(
            //                             8, 40, 8, 40),
            //                         child: Text(
            //                           "Pay via visa or mobile money",
            //                           style: TextStyle(
            //                               fontWeight: FontWeight.normal,
            //                               fontSize: 18),
            //                         ),
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Padding(
            //                           padding: const EdgeInsets.all(8.0),
            //                           child: SizedBox(
            //                             width: double.infinity / 2,
            //                             child: ElevatedButton(
            //                               onPressed: () {
            //                                 authorisePayment(context);
            //                               },
            //                               child: Text("Click to Pay"),
            //                               style: ButtonStyle(
            //                                 backgroundColor:
            //                                     MaterialStateProperty.all(
            //                                         Colors.green),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //                 Container(
            //                   child: Column(
            //                     children: [
            //                       Padding(
            //                         padding: const EdgeInsets.fromLTRB(
            //                             8, 18, 8, 20),
            //                         child: Text(
            //                           "The amount of money in your wallet is ",
            //                           style: TextStyle(
            //                               fontWeight: FontWeight.normal,
            //                               fontSize: 18),
            //                         ),
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.fromLTRB(
            //                             8, 10, 8, 12),
            //                         child: Text(
            //                           money(widget.user.wallet.amount),
            //                           style: TextStyle(
            //                               fontWeight: FontWeight.normal,
            //                               fontSize: 30),
            //                         ),
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Padding(
            //                           padding: const EdgeInsets.all(8.0),
            //                           child: SizedBox(
            //                             width: double.infinity / 2,
            //                             child: ElevatedButton(
            //                               onPressed: () {},
            //                               child: Text("Click to Pay"),
            //                               style: ButtonStyle(
            //                                 backgroundColor:
            //                                     MaterialStateProperty.all(
            //                                         Colors.green),
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //                 Container(
            //                   child: Column(
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: [
            //                       Padding(
            //                         padding: const EdgeInsets.all(42.0),
            //                         child: SizedBox(
            //                           width: 250,
            //                           child: ElevatedButton(
            //                             onPressed: () async {
            //                               String? link =
            //                                   await getUrlFrmInitialization(
            //                                       amount: totalAmount);
            //                               linkTextController.text = link!;
            //                             },
            //                             child: Text("Generate Link"),
            //                             style: ButtonStyle(
            //                               backgroundColor:
            //                                   MaterialStateProperty.all(
            //                                       Colors.green),
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                       Padding(
            //                         padding: EdgeInsets.all(18),
            //                         child: SizedBox(
            //                           width: double.infinity,
            //                           height: 70,
            //                           child: Row(
            //                             children: [
            //                               Spacer(),
            //                               SizedBox(
            //                                 width: 300,
            //                                 child: TextField(
            //                                   controller: linkTextController,
            //                                   enabled: false,
            //                                   decoration: InputDecoration(
            //                                       hintText: "generated link",
            //                                       border:
            //                                           OutlineInputBorder()),
            //                                 ),
            //                               ),
            //                               SizedBox(
            //                                 height: 50,
            //                                 child: ElevatedButton(
            //                                     onPressed: () {
            //                                       Clipboard.setData(
            //                                           ClipboardData(
            //                                               text:
            //                                                   linkTextController
            //                                                       .text));
            //                                     },
            //                                     child: Text("Copy")),
            //                               ),
            //                               // Spacer()
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ThirdPartyPay extends StatelessWidget {
  const ThirdPartyPay({required this.onPressed, Key? key}) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Pay via VISA or Mobile Money',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0x8C000000),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 48,
                      child: Image.asset(
                        'assets/icons/subscriptions/visa.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 72,
                      height: 48,
                      child: Image.asset(
                        'assets/icons/subscriptions/momo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 112,
                      height: 48,
                      child: Image.asset(
                        'assets/icons/subscriptions/airtel_tigo.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        BottomButton(
          label: 'Pay Now',
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class WalletPay extends StatelessWidget {
  const WalletPay({
    Key? key,
    required this.amount,
    required this.onPressed,
  }) : super(key: key);

  final double amount;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'The amount of money in your wallet is',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0x8C000000),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  money(amount),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Helvetica Rounded',
                    fontSize: 24.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (amount > 0)
          BottomButton(
            label: 'Pay Now',
            onPressed: onPressed,
          ),
      ],
    );
  }
}

class LinkPay extends StatelessWidget {
  const LinkPay({
    Key? key,
    required this.link,
    required this.onPressed,
  }) : super(key: key);

  final String link;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Text(
                  'Generate a payment link and use it to purchase a bundle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0x8C000000),
                  ),
                ),
                SizedBox(height: 24),
                if (link.length > 0)
                  Container(
                    padding: EdgeInsets.only(left: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: .5,
                        color: Color(0xFFCECECE),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    height: 48.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              link,
                              style: TextStyle(
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: link,
                              ),
                            );
                          },
                          child: Text(
                            'Copy',
                            style: TextStyle(
                              color: Color(0xFF2589CE),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        BottomButton(
          label: link.length > 0 ? 'Regenerate Link' : 'Generate Link',
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String label;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return AdeoTextButton(
      label: label,
      onPressed: onPressed,
      color: Colors.white,
      background: Color(0xFF2A9CEA),
      fontSize: 18.0,
    );
  }
}
