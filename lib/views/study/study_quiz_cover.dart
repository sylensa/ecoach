import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/views/study/study_quiz_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudyQuizCover extends StatelessWidget {
  StudyQuizCover({
    Key? key,
    this.topicName,
    required this.controller,
  }) : super(key: key);

  final StudyController controller;
  String? topicName;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    backgroundColor = Colors.grey;

    return SafeArea(
      child: Scaffold(
          body: controller.questions.length == 0
              ? Container(
                  child: Center(
                    child: Text(
                      "There are no questions\n for your selection",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Container(
                  color: backgroundColor,
                  child: Stack(children: [
                    Positioned(
                      top: 20,
                      left: -100,
                      right: -140,
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.grey, BlendMode.color),
                          image: AssetImage('assets/images/deep_pool_blue.png'),
                        )),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 120,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTypeString(controller.type),
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: Text("Questions",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: Text(":${controller.questions.length}",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 130,
                                  child: Text("Time",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: getTimeWidget(controller.type),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (topicName != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: Text("Topic",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: Text(topicName!,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 70,
                            ),
                            Text("answer all questions",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic)),
                            SizedBox(
                              height: 180,
                            ),
                            Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return StudyQuizView(
                                              controller: controller);
                                        }));
                                      },
                                      child: Text(
                                        "Let's go",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.fromLTRB(
                                                35, 10, 35, 10)),
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                                style: BorderStyle.solid)),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                )),
    );
  }

  Widget getTimeWidget(StudyType type) {
    switch (type) {
      case StudyType.REVISION:
      case StudyType.MASTERY_IMPROVEMENT:
        return Text("Untimed",
            style: TextStyle(
                fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold));

      case StudyType.SPEED_ENHANCEMENT:
      case StudyType.COURSE_COMPLETION:
        return Text(
            ":${NumberFormat('00').format(controller.duration!.inMinutes)}:${NumberFormat('00').format(controller.duration!.inSeconds % 60)}",
            style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold));
      case StudyType.NONE:
        return Text("");
    }
  }

  String getTypeString(StudyType type) {
    switch (type) {
      case StudyType.REVISION:
        return "Revision";
      case StudyType.COURSE_COMPLETION:
        return "Course Completion";
      case StudyType.SPEED_ENHANCEMENT:
        return "Speed Enhancement";
      case StudyType.MASTERY_IMPROVEMENT:
        return "Mastery Improvement";
      case StudyType.NONE:
        return "None";
    }
  }
}
