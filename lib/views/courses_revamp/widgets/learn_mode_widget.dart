import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/database/mastery_course_db.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/learn/learn_course_completion.dart';
import 'package:ecoach/views/learn/learn_mastery_improvement.dart';
import 'package:ecoach/views/learn/learn_mastery_topic.dart';
import 'package:ecoach/views/learn/learn_revision.dart';
import 'package:ecoach/views/learn/learn_speed_enhancement.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_learn_mode/providers/learn_mode_provider.dart';
import '../../../new_learn_mode/screens/speed_improvement/speed_completion_rules.dart';

class LearnModeWidget extends StatefulWidget {
  static const String routeName = '/learning/mode';
  LearnModeWidget(
      {Key? key,
      required this.course,
      required this.user,
      required this.subscription,
      required this.controller})
      : super(key: key);
  Course course;
  User user;
  Plan subscription;
  final MainController controller;

  @override
  State<LearnModeWidget> createState() => _LearnModeWidgetState();
}

class _LearnModeWidgetState extends State<LearnModeWidget> {
  StudyType studyType = StudyType.NONE;
  bool introView = true;
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
            updatedAt: DateTime.now());
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

  letGo() async {
    Widget? view = null;
    switch (studyType) {
      case StudyType.REVISION:
        StudyProgress? progress = await getStudyProgress(StudyType.REVISION);
        print(progress);
        if (progress == null) {
          return;
        }
        view = LearnRevision(widget.user, widget.course, progress);
        break;

      case StudyType.COURSE_COMPLETION:
        StudyProgress? progress =
            await getStudyProgress(StudyType.COURSE_COMPLETION);
        print(progress);
        if (progress == null) {
          return;
        }
        view = LearnCourseCompletion(widget.user, widget.course, progress);
        break;
      case StudyType.SPEED_ENHANCEMENT:
        StudyProgress? progress =
            await getStudyProgress(StudyType.SPEED_ENHANCEMENT);
        print(progress);
        if (progress == null) {
          return;
        }
        // view = LearnSpeed(widget.user, widget.course, progress);
        view = SpeedCompletionRules();
        break;

      case StudyType.MASTERY_IMPROVEMENT:
        StudyProgress? progress =
            await getStudyProgress(StudyType.MASTERY_IMPROVEMENT);
        print(progress);
        if (progress == null) {
          return;
        }
        List<MasteryCourseUpgrade> mcs =
            await MasteryCourseDB().getMasteryTopicsUpgrade(progress.studyId!);
        if (progress.level == 1 || mcs.length == 0) {
          view = LearnMastery(widget.user, widget.course, progress);
        } else {
          view = LearnMasteryTopic(
            widget.user,
            widget.course,
            progress,
            topics: mcs,
          );
        }

        break;
      case StudyType.NONE:
        break;
    }
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) {
    //       return view!;
    //     }));
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: CoursesDetailsPage.routeName),
        builder: (context) {
          return view!;
        },
      ),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     settings: RouteSettings(name: CoursesDetailsPage.routeName),
    //     builder: (context) {
    //       return view!;
    //     },
    //   ),
    // );
  }

  List<CourseDetail> learnModeDetails = [
    CourseDetail(
      title: 'Revision',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Course Completion',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Speed Enhancement',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
    CourseDetail(
      title: 'Matery Improvement',
      subTitle: 'Do a quick revision for an upcoming exam',
      iconURL: 'assets/icons/courses/learn.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: CourseDetailCard(
                      courseDetail: learnModeDetails[0],
                      onTap: () async {
                        setState(() {
                          studyType = StudyType.REVISION;
                        });
                        await letGo();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: CourseDetailCard(
                      courseDetail: learnModeDetails[1],
                      onTap: () async {
                        setState(() {
                          studyType = StudyType.COURSE_COMPLETION;
                        });
                        await letGo();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: CourseDetailCard(
                      courseDetail: learnModeDetails[2],
                      onTap: () async {
                        setState(() {
                          studyType = StudyType.SPEED_ENHANCEMENT;
                        });
                        await letGo();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: CourseDetailCard(
                      courseDetail: learnModeDetails[3],
                      onTap: () async {
                        setState(() {
                          studyType = StudyType.MASTERY_IMPROVEMENT;
                        });
                        await letGo();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if (studyType != StudyType.NONE)
          //   SizedBox(
          //     width: 150,
          //     height: 44,
          //     child: OutlinedButton(
          //       style: ButtonStyle(
          //         foregroundColor: MaterialStateProperty.all(getButtonColor(studyType)),
          //         side: MaterialStateProperty.all(BorderSide(
          //             color: getButtonColor(studyType),
          //             width: 1,
          //             style: BorderStyle.solid)),
          //       ),
          //       onPressed: () async {
          //
          //       },
          //       child: Text(
          //         "Let's go",
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
