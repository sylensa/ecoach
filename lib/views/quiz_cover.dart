import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizCover extends StatelessWidget {
  QuizCover(this.user, this.questions,
      {Key? key,
      this.level,
      required this.name,
      this.type = TestType.NONE,
      this.category = "Test",
      this.course,
      this.time = 300,
      this.diagnostic = false})
      : super(key: key);
  User user;
  Level? level;
  Course? course;
  List<Question> questions;
  bool diagnostic;
  String name;
  String? category;
  final TestType type;
  int time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: questions.length == 0
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
                color: Color(0xFF00C664),
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
                        image: AssetImage('assets/images/deep_pool_green.png'),
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
                              SizedBox(
                                width: 130,
                                child: Text("Test Type",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 140,
                                child: Text(":${category}",
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
                                child: Text("Questions",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 140,
                                child: Text(":${questions.length}",
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
                                width: 140,
                                child: type != TestType.UNTIMED
                                    ? Text(
                                        ":${NumberFormat('00').format(Duration(seconds: time).inMinutes)}:${NumberFormat('00').format(Duration(seconds: time).inSeconds % 60)}",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))
                                    : Text("Untimed",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Text("answer all questions",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          SizedBox(
                            height: 220,
                          ),
                          Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return QuizView(
                                          user,
                                          questions,
                                          level: level,
                                          name: name,
                                          course: course,
                                          timeInSec: time,
                                          type: type.toString().split(".")[1],
                                          speedTest: type == TestType.SPEED
                                              ? true
                                              : false,
                                          disableTime: type == TestType.UNTIMED
                                              ? true
                                              : false,
                                          diagnostic: diagnostic,
                                        );
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
                                          EdgeInsets.fromLTRB(35, 10, 35, 10)),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                              style: BorderStyle.solid)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0))),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ));
  }
}
