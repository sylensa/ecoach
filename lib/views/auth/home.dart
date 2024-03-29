import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/general_utils.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/store.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/src/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/onboard/welcome_adeo.dart';
import 'package:ecoach/widgets/cards/home_card.dart';
import 'package:ecoach/widgets/courses/circular_progress_indicator_wrapper.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:ecoach/views/download_page.dart';
// import 'package:ecoach/views/test_type.dart';
// import 'package:ecoach/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  final User user;
  Function? callback;

  HomePage(
    this.user, {
    this.callback,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var futureSubs;
  uploadOfflineFlagQuestions()async{
    List<FlagData> results = await QuizDB().getAllFlagQuestions();
    if(results.isNotEmpty){
      for(int i =0; i < results.length; i++){
        FlagData flagData = await FlagData(reason: results[i].reason,type:results[i].type,questionId: results[i].questionId );
        await  QuizDB().saveOfflineFlagQuestion(flagData,flagData.questionId!);
      }
      List<FlagData> res = await QuizDB().getAllFlagQuestions();
      print("res len:${res.length}");
    }else{
      print("res len:${results.length}");

    }
  }
  @override
  void initState() {
    super.initState();
    uploadOfflineFlagQuestions();
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
      default:
        return [Color(0xFF595959), Color(0xFF595959)];

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: Container(
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Expanded(
                     child: ListView(

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
                                      TextStyle(color: Colors.black54, fontSize: 14),
                                ),
                                Text(
                                  widget.user.name!,
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
                        if (!context.watch<DownloadUpdate>().isDownloading &&
                            !context.watch<DownloadUpdate>().notificationUp)
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
                        SizedBox(height: 12),
                        if (context.watch<DownloadUpdate>().isDownloading ||
                            context.watch<DownloadUpdate>().notificationUp)
                          SubscriptionNotificationWidget(
                            callback: widget.callback!,
                          ),
                        Container(
                          child: FutureBuilder(
                              future: futureSubs,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return NoSubWidget(
                                      widget.user,
                                      widget.callback,
                                    );
                                  case ConnectionState.waiting:
                                    return Center(child: CircularProgressIndicator());
                                  default:
                                    if (snapshot.hasError)
                                      return Text('Error: ${snapshot.error}');
                                    else if (snapshot.data != null) {
                                      List<TestTaken> items =
                                          snapshot.data as List<TestTaken>;

                                      return Column(
                                        children: [
                                          SizedBox(height: 32),
                                          for (int i = 0; i < items.length; i++)
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 16),
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
                                                centralWidget: Expanded(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 210,
                                                        child: Text(
                                                          items[i].testname!,
                                                          softWrap: true,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                                          color:
                                                              Color(0x88FFFFFF),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                      );
                                    } else if (snapshot.data == null)
                                      return NoSubWidget(
                                        widget.user,
                                        widget.callback,
                                      );
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionNotificationWidget extends StatefulWidget {
  const SubscriptionNotificationWidget({Key? key, required this.callback})
      : super(key: key);

  final Function callback;

  @override
  _SubscriptionNotificationWidgetState createState() =>
      _SubscriptionNotificationWidgetState();
}

class _SubscriptionNotificationWidgetState
    extends State<SubscriptionNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return context.read<DownloadUpdate>().isDownloading
        ? getDownloading()
        : getNotificationMessage();
  }

  Widget getNotificationMessage() {
    return Container(
      decoration: BoxDecoration(color: Colors.orangeAccent),
      margin: EdgeInsets.fromLTRB(2, 5, 2, 20),
      padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 7),
                child: Text(
                  context.read<DownloadUpdate>().notificationMessage!,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
          ),
          if (context.read<DownloadUpdate>().newSubscriptions >= 0)
            ElevatedButton(
              child: Text("Download"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                widget.callback(4);
              },
            )
        ],
      ),
    );
  }

  Widget getDownloading() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey),
      margin: EdgeInsets.fromLTRB(2, 5, 2, 20),
      padding: EdgeInsets.fromLTRB(5, 10, 10, 15),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                context.read<DownloadUpdate>().message!,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              )),
          context.read<DownloadUpdate>().percentage > 0 &&
                  context.read<DownloadUpdate>().percentage < 100
              ? LinearPercentIndicator(
                  percent: context.read<DownloadUpdate>().percentage / 100,
                )
              : LinearProgressIndicator(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
                "Items downloaded : ${context.read<DownloadUpdate>().doneDownloads.length}"),
          )
        ],
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
                        child: Text('Sample Test'))),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MainHomePage(
                          widget.user,
                          index: 1,
                        );
                      }));
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
