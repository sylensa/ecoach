import 'dart:convert';

import 'package:ecoach/api/api_response.dart';
import 'package:ecoach/utils/general_utils.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/providers/test_taken_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/welcome_adeo.dart';
import 'package:ecoach/widgets/cards/home_card.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
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
  }

  void _runFilter(String enteredKeyword) {
    var results;
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = TestTakenDB().testsTaken(limit: 20);
    } else {
      results = TestTakenDB().testsTaken(search: enteredKeyword, limit: 20);
    }

    // Refresh the UI
    setState(() {
      futureSubs = results;
    });
  }

  List<Color> getColorGradient(TestType type) {
    switch (type) {
      case TestType.SPEED:
        return [Color(0xFFFD6363), Color(0xFFFD6363)];
      case TestType.KNOWLEDGE:
        return [Color(0xFF3AAFFF), Color(0xFF3AAFFF)];
      case TestType.UNTIMED:
        return [Color(0xFF00C664), Color(0xFF00C664)];
      case TestType.CUSTOMIZED:
        return [Color(0xFFFFB84F), Color(0xFFFFB84F)];
      case TestType.DIAGNOSTIC:
        return [Color(0xFF393FC8), Color(0xFF282D9A)];
      case TestType.NONE:
        return [Color(0xFF595959), Color(0xFF595959)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: Container(
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30, 24, 0),
            child: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello,",
                            style:
                                TextStyle(color: Colors.black26, fontSize: 12),
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
                    height: 20,
                  ),
                  Container(
                    height: 48.0,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      style: TextStyle(
                        color: kDefaultBlack,
                        fontSize: 16.0,
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Image.asset(
                          'assets/icons/search_thin.png',
                          width: 32.0,
                          height: 32.0,
                          color: Colors.black,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xFFBAC4D9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: (searchString) {
                        _runFilter(searchString);
                      },
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: futureSubs,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return NoSubWidget(widget.user, widget.callback);
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else if (snapshot.data != null) {
                                List<TestTaken> items =
                                    snapshot.data as List<TestTaken>;

                                return Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 44),
                                        for (int i = 0; i < items.length; i++)
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 24),
                                            child: HomeCard(
                                              timeAgo: timeago
                                                  .format(items[i].datetime!),
                                              activityTypeIconURL:
                                                  'assets/icons/edit.png',
                                              vendoLogoURL:
                                                  'assets/icons/edeo_logo.png',
                                              footerCenterText:
                                                  '${items[i].jsonResponses.length} Questions',
                                              footerRightText:
                                                  items[i].usedTimeText,
                                              centralWidget: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 210,
                                                    child: Text(
                                                      items[i].testname!,
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${items[i].courseName!}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: Color(0x88FFFFFF),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              centerRightWidget:
                                                  CircularProgressIndicatorWrapper(
                                                progress: items[i].correct! /
                                                    items[i].totalQuestions *
                                                    100,
                                              ),
                                              colors: getColorGradient(
                                                  enumFromString(
                                                          TestType.values,
                                                          items[i].testType) ??
                                                      TestType.NONE),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShadowedText extends StatelessWidget {
  const ShadowedText({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48.0,
          alignment: Alignment.center,
          child: Text(
            text,
            softWrap: true,
            style: TextStyle(
              color: darken(color),
              fontSize: 60.0,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
        Container(
          height: 1.0,
          width: 72.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              double.infinity,
            ),
            boxShadow: [
              BoxShadow(
                color: darken(color, 80),
                blurRadius: 2.0,
              ),
            ],
          ),
        )
      ],
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
      color: Color(0xFFFFFFFF),
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
