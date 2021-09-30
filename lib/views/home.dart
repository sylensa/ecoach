import 'dart:convert';
import 'dart:developer';

import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/providers/test_taken_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/welcome_adeo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  final User user;
  Function? callback;
  HomePage(this.user, {this.callback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var futureSubs;

  @override
  void initState() {
    super.initState();
    checkSubscription();
  }

  checkSubscription() {
    List<Subscription> subscriptions = widget.user.subscriptions;

    if (subscriptions.length > 0) {
      setState(() {
        futureSubs = TestTakenDB().testsTaken();
      });
    } else {
      setState(() {
        futureSubs = null;
      });
    }

    getSubscriptions().then((api) {
      List<Subscription> subscriptions = api!.data as List<Subscription>;
      SubscriptionDB().insertAll(subscriptions);

      // setState(() {
      //   futureSubs = SubscriptionDB().subscriptions();
      // });
    });
  }

  Future<ApiResponse<Subscription>?> getSubscriptions() async {
    Map<String, dynamic> queryParams = {};
    print(queryParams);
    print(AppUrl.questions + '?' + Uri(queryParameters: queryParams).query);
    http.Response response = await http.get(
      Uri.parse(
          AppUrl.subscriptions + '?' + Uri(queryParameters: queryParams).query),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': widget.user.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        print("messages returned");
        print(response.body);

        return ApiResponse<Subscription>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          print(dataItem);
          return Subscription.fromJson(dataItem);
        });
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.statusCode);
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30, 24, 34),
            child: Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello,",
                              style: TextStyle(
                                  color: Colors.black26, fontSize: 12),
                            ),
                            Text(
                              widget.user.name,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Spacer(),
                        Stack(
                          children: [Icon(Icons.notifications)],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: FutureBuilder(
                          future: futureSubs,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return NoSubWidget(
                                    widget.user, widget.callback);
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                                else if (snapshot.data != null) {
                                  List<TestTaken> items =
                                      snapshot.data as List<TestTaken>;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return ListTile(
                                        title: Text(item.testname ?? "no name",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        subtitle: Text("${item.totalQuestions}",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      );
                                    },
                                  );
                                } else if (snapshot.data == null)
                                  return NoSubWidget(
                                      widget.user, widget.callback);
                                else
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      Center(
                                          child: Text(widget.user.email ??
                                              "Something isn't right")),
                                      SizedBox(height: 100),
                                    ],
                                  );
                            }
                          }),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

enum Selection { SUBSCRIPTION, DIAGNOSTIC, NONE }

class NoSubWidget extends StatefulWidget {
  NoSubWidget(this.user, this.callback);
  final Function? callback;
  User user;

  @override
  State<NoSubWidget> createState() => _NoSubWidgetState();
}

class _NoSubWidgetState extends State<NoSubWidget> {
  Selection selection = Selection.NONE;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "You have ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black26,
                )),
            TextSpan(
                text: "No",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: " Subscriptions",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black26,
                )),
          ])),
          SizedBox(
            width: 152,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 28.0, 0, 30),
              child: Text(
                'Perform an Activity.\nBring your feed to life',
                style: TextStyle(color: Color(0xFFD3D3D3)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 176,
            width: 267,
            child: Column(
              children: [
                Expanded(
                    child: TextButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(267, 88)),
                            backgroundColor: MaterialStateProperty.all(
                                selection == Selection.SUBSCRIPTION
                                    ? Color(0xFF00C664)
                                    : Color(0xFFFAFAFA)),
                            foregroundColor: MaterialStateProperty.all(
                                selection == Selection.SUBSCRIPTION
                                    ? Colors.white
                                    : Color(0xFFBAC4D9))),
                        onPressed: () {
                          setState(() {
                            selection = Selection.SUBSCRIPTION;
                          });
                        },
                        child: Text('Subscription'))),
                Expanded(
                    child: TextButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(267, 88)),
                            backgroundColor: MaterialStateProperty.all(
                                selection == Selection.DIAGNOSTIC
                                    ? Color(0xFF00ABE0)
                                    : Color(0xFFFAFAFA)),
                            foregroundColor: MaterialStateProperty.all(
                                selection == Selection.DIAGNOSTIC
                                    ? Colors.white
                                    : Color(0xFFBAC4D9))),
                        onPressed: () {
                          setState(() {
                            selection = Selection.DIAGNOSTIC;
                          });
                        },
                        child: Text('Diagnostic'))),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          if (selection == Selection.SUBSCRIPTION)
            SizedBox(
                width: 150,
                height: 44,
                child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xFF00C664)),
                      side: MaterialStateProperty.all(BorderSide(
                          color: Color(0xFF00C664),
                          width: 1,
                          style: BorderStyle.solid)),
                    ),
                    onPressed: () {
                      widget.callback!();
                    },
                    child: Text('Buy'))),
          if (selection == Selection.DIAGNOSTIC)
            SizedBox(
                width: 150,
                height: 44,
                child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xFF00ABE0)),
                      side: MaterialStateProperty.all(BorderSide(
                          color: Color(0xFF00ABE0),
                          width: 1,
                          style: BorderStyle.solid)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SelectLevel(widget.user);
                      }));
                    },
                    child: Text('Take'))),
        ],
      ),
    );
  }
}
