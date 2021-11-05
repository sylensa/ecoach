import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn_course_completion.dart';
import 'package:ecoach/views/learn_mastery_improvement.dart';
import 'package:ecoach/views/learn_revision.dart';
import 'package:ecoach/views/learn_speed_enhancement.dart';
import 'package:ecoach/widgets/layouts/learn_peripheral_layout.dart';
import 'package:flutter/material.dart';

enum StudyType {
  REVISION,
  COURSE_COMPLETION,
  SPEED_ENHANCEMENT,
  MASTERY_IMPROVEMENT,
  NONE
}

class LearnMode extends StatefulWidget {
  LearnMode(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnModeState createState() => _LearnModeState();
}

class _LearnModeState extends State<LearnMode> {
  StudyType studyType = StudyType.NONE;
  bool introView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: introView
          ? LearnPeripheralWidget(
              heroText: 'welcome',
              subText:
                  'We saved your previous session so you can continue where you left off',
              heroImageURL: 'assets/images/learn_module/welcome.png',
              mainActionLabel: 'continue',
              mainActionBackground: Color(0xFFF0F0F2),
              mainActionOnPressed: () {
                setState(() {
                  introView = false;
                });
              },
              topActionLabel: 'switch mode',
              topActionOnPressed: () {},
            )
          : Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              color: Color(0xFFFFFFFF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'exit',
                            style: TextStyle(
                                color: Color(0xFFFB7B76), fontSize: 11),
                          )),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome to the Learn Mode",
                            style: TextStyle(
                                color: Color(0xFFACACAC), fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "What is your current goal?",
                            style: TextStyle(
                                color: Color(0xFFD3D3D3),
                                fontSize: 14,
                                fontStyle: FontStyle.italic),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          IntrinsicHeight(
                            child: Column(
                              children: [
                                getSelectButton(StudyType.REVISION, "Revision",
                                    Color(0xFF00C664)),
                                getSelectButton(StudyType.COURSE_COMPLETION,
                                    "Course Completion", Color(0xFF00ABE0)),
                                getSelectButton(StudyType.SPEED_ENHANCEMENT,
                                    "Speed Enhancement", Color(0xFFFB7B76)),
                                getSelectButton(StudyType.MASTERY_IMPROVEMENT,
                                    "Mastery Improvement", Color(0xFFFFB444)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ]),
                  ),
                  if (studyType != StudyType.NONE)
                    SizedBox(
                      width: 150,
                      height: 44,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              getButtonColor(studyType)),
                          side: MaterialStateProperty.all(BorderSide(
                              color: getButtonColor(studyType),
                              width: 1,
                              style: BorderStyle.solid)),
                        ),
                        onPressed: () {
                          Widget? view = null;
                          switch (studyType) {
                            case StudyType.REVISION:
                              view = LearnRevision(widget.user, widget.course);
                              break;
                            case StudyType.COURSE_COMPLETION:
                              view = LearnCourseCompletion(
                                  widget.user, widget.course);
                              break;
                            case StudyType.SPEED_ENHANCEMENT:
                              view = LearnSpeed(widget.user, widget.course);
                              break;
                            case StudyType.MASTERY_IMPROVEMENT:
                              view = LearnMastery(widget.user, widget.course);
                              break;
                            case StudyType.NONE:
                              break;
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return view!;
                          }));
                        },
                        child: Text(
                          "Let's go",
                        ),
                      ),
                    ),
                  SizedBox(height: 24.0),
                ],
              ),
            ),
    );
  }

  Color getButtonColor(StudyType selected) {
    Color? color;
    switch (selected) {
      case StudyType.REVISION:
        color = Color(0xFF00C664);
        break;
      case StudyType.COURSE_COMPLETION:
        color = Color(0xFF00ABE0);
        break;
      case StudyType.SPEED_ENHANCEMENT:
        color = Color(0xFFFB7B76);
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        color = Color(0xFFFFB444);
        break;
      case StudyType.NONE:
        break;
    }

    return color!;
  }

  Widget getSelectButton(
    StudyType selected,
    String selectionText,
    Color selectedColor,
  ) {
    return Expanded(
        child: TextButton(
            style: ButtonStyle(
                fixedSize: studyType == selected
                    ? MaterialStateProperty.all(Size(310, 102))
                    : MaterialStateProperty.all(Size(267, 88)),
                backgroundColor: MaterialStateProperty.all(
                    studyType == selected ? selectedColor : Color(0xFFFAFAFA)),
                foregroundColor: MaterialStateProperty.all(
                    studyType == selected ? Colors.white : Color(0xFFBEC7DB))),
            onPressed: () {
              setState(() {
                studyType = selected;
              });
            },
            child: Text(
              selectionText,
              style: TextStyle(fontSize: studyType == selected ? 25 : 20),
            )));
  }
}
