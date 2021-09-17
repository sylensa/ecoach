import 'package:ecoach/controllers/questions_controller.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DiagnoticResultView extends StatefulWidget {
  DiagnoticResultView(this.user, {Key? key, required this.test})
      : super(key: key);
  final User user;
  TestTaken test;

  @override
  _DiagnoticResultViewState createState() => _DiagnoticResultViewState();
}

class _DiagnoticResultViewState extends State<DiagnoticResultView> {
  var futureList;
  List<Widget> analysisWidgets = [];

  @override
  void initState() {
    super.initState();

    print("test id = ${widget.test.id}");
    TestController().topicsAnalysis(widget.test.id).then((mapList) {
      mapList.keys.forEach((key) {
        List<TestAnswer> answers = mapList[key]!;
        analysisWidgets.add(topicRow(TopicAnalysis(key, answers)));
      });

      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                    getRankWidget(142, 305),
                    getTimeWidget(Duration(seconds: widget.test.testTime!))
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xFF636363),
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
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Text(
                                "Topic",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 120,
                              child:
                                  Text("Time", style: TextStyle(fontSize: 15))),
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
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
                      child: Text("Buy Subscription",
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                    ),
                  )
                ],
              ),
            )
          ],
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
                  left: 10,
                  child: Text(
                    "$position",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black26,
                        fontWeight: FontWeight.bold),
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
          "${min}m:${sec}s",
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
