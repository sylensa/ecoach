import 'package:ecoach/database/mastery_course_db.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/new_learn_mode/providers/learn_mode_provider.dart';
import 'package:ecoach/new_learn_mode/screens/welcome_to_learn_mode.dart';
import 'package:ecoach/views/learn/learn_course_completion.dart';
import 'package:ecoach/views/learn/learn_mastery_improvement.dart';
import 'package:ecoach/views/learn/learn_mastery_topic.dart';
import 'package:ecoach/views/learn/learn_revision.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new_learn_mode/screens/speed_improvement/speed_completion_rules.dart';

class LearnMode extends StatefulWidget {
  static const String routeName = '/learning/mode';
  LearnMode(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnModeState createState() => _LearnModeState();
}

class _LearnModeState extends State<LearnMode> {
  StudyType studyType = StudyType.NONE;
  bool introView = true;

  Future<StudyProgress?> getStudyProgress(StudyType type) async {
    Study? study = await StudyDB().getStudyByType(widget.course.id!, type);
    Topic? topic;
    StudyProgress? progress;
    if (study == null) {
      topic = await TopicDB().getLevelTopic(widget.course.id!, 1);
      if (topic != null) {
        study = Study(
            id: topic.id,
            courseId: widget.course.id!,
            name: type == StudyType.SPEED_ENHANCEMENT ||
                    type == StudyType.MASTERY_IMPROVEMENT
                ? widget.course.name
                : topic.name,
            type: type.toString(),
            currentTopicId: type == StudyType.SPEED_ENHANCEMENT ||
                    type == StudyType.MASTERY_IMPROVEMENT
                ? null
                : topic.id,
            userId: widget.user.id!,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now());
        await StudyDB().insert(study);

        progress = StudyProgress(
          id: topic.id,
          studyId: study.id,
          level: 1,
          section: 1,
          name: type == StudyType.SPEED_ENHANCEMENT ||
                  type == StudyType.MASTERY_IMPROVEMENT
              ? widget.course.name
              : topic.name,
          topicId: type == StudyType.SPEED_ENHANCEMENT ||
                  type == StudyType.MASTERY_IMPROVEMENT
              ? null
              : topic.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await StudyDB().insertProgress(progress);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please download course first")));
        return null;
      }
    } else {
      print("p=${study.id}");
      progress = await StudyDB().getCurrentProgress(study.id!);
    }

    Provider.of<LearnModeProvider>(context, listen: false)
        .setCurrentProgress(progress!);

    return progress;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body:
              //  introView
              // ? LearnPeripheralWidget(
              //     heroText: 'welcome',
              //     subText:
              //         'We saved your previous session so you can continue where you left off',
              //     heroImageURL: 'assets/images/learn_module/welcome.png',
              //     mainActionLabel: 'continue',
              //     mainActionBackground: Color(0xFFF0F0F2),
              //     mainActionOnPressed: () {
              //       setState(() {
              //         introView = false;
              //       });
              //     },
              //     topActionLabel: 'switch mode',
              //     topActionOnPressed: () {},
              //   )
              // :

              Consumer<LearnModeProvider>(
        builder: (_, welcome, __) {
          return WelcomeToLearnMode(
            course: widget.course,
            startLearning: (StudyType study) async {
              Widget? view = null;
              Provider.of<LearnModeProvider>(context, listen: false)
                  .setCurrentStudyType(study);
              switch (study) {
                case StudyType.REVISION:
                  StudyProgress? progress =
                      await getStudyProgress(StudyType.REVISION);

                  // create a revision progress object and add it to the revision progress database
                  // if the current course is starting for the first time
                  // RevisionStudyProgress revisionStudyProgress =
                  //     RevisionStudyProgress(
                  //   courseId: widget.course.id,
                  //   topicId: progress!.topicId,
                  //   studyId: progress.studyId,
                  //   level: 1,
                  //   createdAt: DateTime.now(),
                  //   updatedAt: DateTime.now(),
                  // );
                  //
                  // RevisionProgressController()
                  //     .createInitialCourseRevision(revisionStudyProgress);

                  if (progress == null) {
                    return;
                  }
                  view = LearnRevision(widget.user, widget.course, progress);
                  break;

                case StudyType.COURSE_COMPLETION:
                  StudyProgress? progress =
                      await getStudyProgress(StudyType.COURSE_COMPLETION);

                  // create a revision progress object and add it to the revision progress database
                  // if the current course is starting for the first time
                  // CourseCompletionStudyProgress courseCompletionStudyProgress =
                  //     CourseCompletionStudyProgress(
                  //   courseId: widget.course.id,
                  //   topicId: progress!.topicId,
                  //   studyId: progress.studyId,
                  //   level: 1,
                  //   createdAt: DateTime.now(),
                  //   updatedAt: DateTime.now(),
                  // );
                  //
                  // CourseCompletionStudyController()
                  //     .createInitialCourseCompletionCompletion(
                  //         courseCompletionStudyProgress);

                  if (progress == null) {
                    return;
                  }
                  view = LearnCourseCompletion(
                      widget.user, widget.course, progress);
                  break;
                case StudyType.SPEED_ENHANCEMENT:
                  StudyProgress? progress =
                      await getStudyProgress(StudyType.SPEED_ENHANCEMENT);

                  // SpeedStudyProgress revisionStudyProgress = SpeedStudyProgress(
                  //   courseId: widget.course.id,
                  //   topicId: progress!.topicId,
                  //   studyId: progress.studyId,
                  //   level: 1,
                  //   fails: 1,
                  //   createdAt: DateTime.now(),
                  //   updatedAt: DateTime.now(),
                  // );
                  //
                  // SpeedStudyProgressController()
                  //     .createInitialCourseSpeed(revisionStudyProgress);

                  print(progress);
                  if (progress == null) {
                    return;
                  }
                  view = SpeedCompletionRules();
                  break;
                case StudyType.MASTERY_IMPROVEMENT:
                  StudyProgress? progress =
                      await getStudyProgress(StudyType.MASTERY_IMPROVEMENT);
                  print(progress);
                  if (progress == null) {
                    return;
                  }
                  List<MasteryCourseUpgrade> mcs = await MasteryCourseDB()
                      .getMasteryTopicsUpgrade(welcome.currentCourse!.id!);

                  print("list course to master: ${mcs.length}");

                  if (mcs.isEmpty) {
                    view = LearnMastery(widget.user, widget.course, progress);
                  } else {
                    view = LearnMasteryTopic(
                        widget.user, widget.course, progress,
                        topics: mcs);
                  }

                  break;
                case StudyType.NONE:
                  break;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return view!;
              }));
            },
          );
        },
      )

          // Container(
          //     padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          //     color: Color(0xFFFFFFFF),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.end,
          //           children: [
          //             TextButton(
          //                 onPressed: () {
          //                   Navigator.popUntil(context,
          //                       ModalRoute.withName(CoursesPage.routeName));
          //                 },
          //                 child: Text(
          //                   'exit',
          //                   style: TextStyle(
          //                       color: Color(0xFFFB7B76), fontSize: 11),
          //                 )),
          //             SizedBox(
          //               width: 30,
          //             )
          //           ],
          //         ),
          //         Expanded(
          //           child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   "Welcome to the Learn Mode",
          //                   style: TextStyle(
          //                       color: Color(0xFFACACAC), fontSize: 18),
          //                 ),
          //                 SizedBox(
          //                   height: 20,
          //                 ),
          //                 Text(
          //                   "What is your current goal?",
          //                   style: TextStyle(
          //                       color: Color(0xFFD3D3D3),
          //                       fontSize: 14,
          //                       fontStyle: FontStyle.italic),
          //                 ),
          //                 SizedBox(
          //                   height: 22,
          //                 ),
          //                 IntrinsicHeight(
          //                   child: Column(
          //                     children: [
          //                       getSelectButton(StudyType.REVISION,
          //                           "Revision", Color(0xFF00C664)),
          //                       getSelectButton(StudyType.COURSE_COMPLETION,
          //                           "Course Completion", Color(0xFF00ABE0)),
          //                       getSelectButton(StudyType.SPEED_ENHANCEMENT,
          //                           "Speed Enhancement", Color(0xFFFB7B76)),
          //                       getSelectButton(StudyType.MASTERY_IMPROVEMENT,
          //                           "Mastery Improvement", Color(0xFFFFB444)),
          //                     ],
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 50,
          //                 ),
          //               ]),
          //         ),
          //         if (studyType != StudyType.NONE)
          //           SizedBox(
          //             width: 150,
          //             height: 44,
          //             child: OutlinedButton(
          //               style: ButtonStyle(
          //                 foregroundColor: MaterialStateProperty.all(
          //                     getButtonColor(studyType)),
          //                 side: MaterialStateProperty.all(BorderSide(
          //                     color: getButtonColor(studyType),
          //                     width: 1,
          //                     style: BorderStyle.solid)),
          // ),
          // onPressed: () async {
          //   Widget? view = null;
          //   switch (studyType) {
          //     case StudyType.REVISION:
          //       StudyProgress? progress =
          //           await getStudyProgress(StudyType.REVISION);
          //       print("this is the progress of revision $progress");
          //       if (progress == null) {
          //         return;
          //       }
          //       view = LearnRevision(
          //           widget.user, widget.course, progress);
          //       break;

          //     case StudyType.COURSE_COMPLETION:
          //       StudyProgress? progress =
          //           await getStudyProgress(
          //               StudyType.COURSE_COMPLETION);
          //       print(progress);
          //       if (progress == null) {
          //         return;
          //       }
          //       view = LearnCourseCompletion(
          //           widget.user, widget.course, progress);
          //       break;
          //     case StudyType.SPEED_ENHANCEMENT:
          //       StudyProgress? progress =
          //           await getStudyProgress(
          //               StudyType.SPEED_ENHANCEMENT);
          //       print(progress);
          //       if (progress == null) {
          //         return;
          //       }
          //       view = LearnSpeed(
          //           widget.user, widget.course, progress);
          //       break;
          //     case StudyType.MASTERY_IMPROVEMENT:
          //       StudyProgress? progress =
          //           await getStudyProgress(
          //               StudyType.MASTERY_IMPROVEMENT);
          //       print(progress);
          //       if (progress == null) {
          //         return;
          //       }
          //       List<MasteryCourse> mcs =
          //           await MasteryCourseDB()
          //               .getMasteryTopics(progress.studyId!);
          //       if (progress.level == 1 || mcs.length == 0) {
          //         view = LearnMastery(
          //             widget.user, widget.course, progress);
          //       } else {
          //         view = LearnMasteryTopic(
          //             widget.user, widget.course, progress,
          //             topics: mcs);
          //       }

          //       break;
          //     case StudyType.NONE:
          //       break;
          //   }
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) {
          //     return view!;
          //   }));

          // },
          //               child: Text(
          //                 "Let's go",
          //               ),
          //             ),
          //           ),
          //         SizedBox(height: 24.0),
          //       ],
          //     ),
          //   ),

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
            minimumSize: studyType == selected
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
        ),
      ),
    );
  }
}
