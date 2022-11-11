import 'dart:async';
import 'dart:convert';

import 'package:ecoach/models/plan2.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/components/subscription/payment_options_tab_pages.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SubscribeToPlan extends StatefulWidget {
  static const String routeName = '/subscriptions';
  final User user;
  final Plan plan;
  SubscribeToPlan(this.user, this.plan, {Key? key}) : super(key: key);

  @override
  _SubscribeToPlanState createState() => _SubscribeToPlanState();
}

class _SubscribeToPlanState extends State<SubscribeToPlan>
    with SingleTickerProviderStateMixin {
  double totalAmount = 0.0;
  late String generatedLink = '';

  @override
  void initState() {
    totalAmount = widget.plan.price!;
    super.initState();
  }

  Future<String?> getUrlFrmInitialization(
      {String? email, required double amount, List<String>? metadata}) async {
   
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

  // Future<String?> getUrlFrmInitialization({
  //   String? email,
  //   required double amount,
  //   List<String>? metadata,
  // }) async {
  //   // showSnackbar(
  //   //   context,
  //   //   Snackbar(
  //   //     content: Text('Initializing payment information ...'),
  //   //     extended: true,
  //   //   ),
  //   //   alignment: Alignment.topCenter,
  //   // );
  //   String? url;
  //   String? email = widget.user.email;
  //   if (email == null || email.isEmpty) {
  //     email = "${widget.user.phone}@ecoach.com";
  //   }
  //   try {
  //     final Map<String, dynamic> paymentData = {
  //       'email': email,
  //       'phone': widget.user.phone,
  //       'amount': amount,
  //       "plan_id": widget.plan.id,
  //       'metadata': json.encode(
  //         "{purpose: buying book, description: I want to learn}",
  //       ),
  //     };

  //     http.Response response = await http.post(
  //       Uri.parse(AppUrl.payment_initialize),
  //       body: json.encode(paymentData),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'api-token': widget.user.token!
  //       },
  //     );

  //     final Map<String, dynamic> responseData = json.decode(response.body);

  //     if (responseData['status'] == true) {
  //       url = responseData['data']['authorization_url'];
  //     } else {
  //       // showSnackbar(
  //       //   context,
  //       //   Snackbar(
  //       //     content: Text(responseData['message']),
  //       //     extended: true,
  //       //   ),
  //       //   alignment: Alignment.topCenter,
  //       // );
  //     }
  //   } catch (e, m) {
  //     // showSnackbar(
  //     //   context,
  //     //   Snackbar(
  //     //     content: Text(
  //     //       'There was a problem initializing payment. Please try again later',
  //     //     ),
  //     //     extended: true,
  //     //   ),
  //     //   alignment: Alignment.topCenter,
  //     // );
  //   }

  //   return url;
  // }

  authorisePayment(BuildContext context) async {
    print("Autorizing Payyment");
    String? authorizationUrl = await getUrlFrmInitialization(
      email: widget.user.email,
      amount: totalAmount,
    );
    print("Autorization Url: ${totalAmount}");
    if (authorizationUrl == null) {
      return;
    }
    launchBrower(authorizationUrl);
  }

  launchBrower(String url) async {
    bool done = await launch(url, webOnlyWindowName: '_blank');
    print("browser $done");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainHomePage(widget.user),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 86),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'GHS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              Text(
                totalAmount.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Helvetica Rounded',
                  fontSize: 48.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.0),
        Text(
          "Payment Options",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 32.0),
        Container(
          width: double.maxFinite,
          height: 400,
          child: AdeoTabControl(
            variant: 'underline',
            tabs: ['Visa/MoMo', 'wallet', 'link'],
            tabPages: [
              ThirdPartyPay(
                onPressed: () {
                  //  print("Autorizing Payyment");
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
        ),
      ],
    );
  }
}
