import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ResultView extends StatefulWidget {
  ResultView(this.user, this.course,
      {Key? key, required this.test, this.diagnostic = false})
      : super(key: key);
  final User user;
  final Course course;
  TestTaken test;
  bool diagnostic;

  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  var futureList;
  List<Widget> analysisWidgets = [];

  @override
  void initState() {
    super.initState();

    print("test id = ${widget.test.id}");
    TestController().topicsAnalysis(widget.test).then((mapList) {
      mapList.keys.forEach((key) {
        List<TestAnswer> answers = mapList[key]!;
        analysisWidgets.add(topicRow(TopicAnalysis(key, answers)));
      });

      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF28BFDF),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getScoreWidget(widget.test.score! / 100),
                      getRankWidget(
                          widget.test.userRank!, widget.test.totalRank!),
                      getTimeWidget(
                          Duration(seconds: widget.test.usedTime ?? 0))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Color(0xFF636363),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 140,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                  child: Text(
                                    "Topic",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: 120,
                                  child: Text("Correct",
                                      style: TextStyle(fontSize: 15))),
                              Expanded(
                                  child: Text("Performance",
                                      style: TextStyle(fontSize: 15))),
                            ],
                          ),
                        ),
                        for (int i = 0; i < analysisWidgets.length; i++)
                          analysisWidgets[i],
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Review",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25)),
                          ),
                        ),
                      ),
                       if(widget.diagnostic && context.read<DownloadUpdate>().plans.isEmpty)
                        VerticalDivider(
                          width: 2,
                          color: Colors.white,
                        ),
                      if (widget.diagnostic && context.read<DownloadUpdate>().plans.isEmpty)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        StorePage(widget.user),
                                  ),
                                );
                              },
                              child: Text("Purchase",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                            ),
                          ),
                        ),
                      if (context.read<DownloadUpdate>().plans.isNotEmpty )
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        CourseDetailsPage.routeName));
                              },
                              child: Text("New",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                            ),
                          ),
                        ),
                      if (context.read<DownloadUpdate>().plans.isNotEmpty)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          MainHomePage(
                                        widget.user,
                                        index: 2,
                                      ),
                                    ), (route) {
                                  return false;
                                });
                              },
                              child: Text("Close",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getScoreWidget(
    double percent,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Score",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Stack(
          children: [
            CircularPercentIndicator(
              radius: 55,
              percent: percent,
              backgroundColor: Colors.black38,
              progressColor: Colors.red,
              animation: true,
            ),
            Positioned(
                top: 25,
                left: 15,
                child: Text(
                  "${percent * 100}%",
                  style: TextStyle(fontSize: 17),
                )),
          ],
        ),
      ],
    );
  }

  Widget getRankWidget(int position, int overall) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Rank",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: 90,
          height: 50,
          child: Stack(
            children: [
              Positioned(
                  top: 15,
                  left: -10,
                  child: SizedBox(
                    width: 70,
                    child: Text(
                      "$position",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black26,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Positioned(
                  top: 0,
                  left: 60,
                  child: Text("/$overall",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ],
    );
  }

  Widget getTimeWidget(Duration duration) {
    int min = (duration.inSeconds / 60).floor();
    int sec = duration.inSeconds % 60;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Time taken",
            style: TextStyle(fontSize: 15),
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          "${NumberFormat('00').format(min)} min:${NumberFormat('00').format(sec)} sec",
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
