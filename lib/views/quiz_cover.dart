import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizCover extends StatelessWidget {
  QuizCover(this.user, this.questions,
      {Key? key, this.level, this.course, this.diagnostic = false})
      : super(key: key);
  User user;
  Level? level;
  Course? course;
  List<Question> questions;
  bool diagnostic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                      child: Text(":Diagnostic",
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
                      child: Text(":40 mins",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
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
                                course: course,
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
                            side: MaterialStateProperty.all(BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
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
