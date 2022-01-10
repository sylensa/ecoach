import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database_nosql/course_doa.dart';
import 'package:ecoach/models/notes_read.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/notes_read_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/notes_topics.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/courses_page_header.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/utils/manip.dart';

class CourseDetailsPage extends StatefulWidget {
  CourseDetailsPage(this.user, {this.courseInfo});

  static const String routeName = '/courses/details';
  final courseInfo;
  final User user;

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  num courseProgress = 0;
  String lastTest = "";
  String rank = "";
  String lastNote = "";
  String lastStudy = "";
  String lastStudyTopic = "";

  @override
  void initState() {
    super.initState();
    print('checking test taken');
    TestController()
        .getCourseProgress(widget.courseInfo.course.id)
        .then((value) {
      setState(() {
        courseProgress = value is num ? (value * 100).floor() : 0;
      });
    });
    NotesReadDB().lastNotesRead(widget.courseInfo.course.id).then((value) {
      setState(() {
        lastNote = value != null ? value.name! : "No Notes Read Yet";
      });
    });
    TestTakenDB().courseLastTest(widget.courseInfo.course.id).then((value) {
      setState(() {
        lastTest = value != null ? value.testname! : "No Test Yet";
        rank = value != null ? "${value.userRank ?? '----'}" : "----";
      });
    });

    StudyDB().courseLastStudy(widget.courseInfo.course.id).then((value) {
      if (value == null) {
        lastStudy = "No Study Yet";
        return;
      }
      CourseDao().getCourseById(value.courseId!).then((value) {
        setState(() {
          if (value == null) lastStudy = "";
          lastStudy = value!.name!;
        });
      });
    });
    StudyDB().courseLastStudy(widget.courseInfo.course.id).then((value) {
      setState(() {
        if (value == null) {
          lastStudyTopic = "----";
        } else
          StudyDB().getCurrentProgress(value.id!).then((value) {
            if (value == null) {
              lastStudyTopic = "----";
            } else {
              lastStudyTopic = value.name!;
            }
          });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<CourseDetail> courseDetails = [
      CourseDetail(
        title: 'Learn',
        subTitle: 'Different modes to help you master a course',
        iconURL: 'assets/icons/courses/learn.png',
      ),
      CourseDetail(
        title: 'Notes',
        subTitle: 'Self-explanatory notes on various topics',
        iconURL: 'assets/icons/courses/notes.png',
      ),
      CourseDetail(
        title: 'Tests',
        subTitle: 'Different test modes to get you exam-ready',
        iconURL: 'assets/icons/courses/tests.png',
      ),
      CourseDetail(
        title: 'Live',
        subTitle: 'Live sessions',
        iconURL: 'assets/icons/courses/live.png',
      ),
      CourseDetail(
        title: 'Games',
        subTitle: 'Educational games based on the course',
        iconURL: 'assets/icons/courses/games.png',
      ),
      CourseDetail(
        title: 'Progress',
        subTitle: 'Track your progress',
        iconURL: 'assets/icons/courses/progress.png',
      ),
      // CourseDetail(
      //   title: lastStudy,
      //   background: kCourseColors[4]['background'],
      //   icon: 'learn.png',
      //   progress: 75,
      //   progressColor: kCourseColors[4]['progress'],
      //   iconLabel: 'Learn',
      //   subtitle1: lastStudyTopic,
      //   subtitle2: '',
      //   subGraphicsIsIcon: true,
      //   subGraphics: Icons.play_arrow_sharp,
      // ),
      // CourseDetail(
      //   title: lastNote,
      //   background: kCourseColors[5]['background'],
      //   icon: 'notes.png',
      //   progress: 80,
      //   progressColor: kCourseColors[5]['progress'],
      //   iconLabel: 'Notes',
      //   subGraphicsIsIcon: true,
      //   subGraphics: Icons.pause,
      // ),
      // CourseDetail(
      //   title: 'BECE 2020',
      //   background: kCourseColors[6]['background'],
      //   icon: 'tests.png',
      //   progress: 50,
      //   progressColor: kCourseColors[6]['progress'],
      //   iconLabel: 'Tests',
      //   subtitle1: 'Rank: $rank',
      //   subGraphicsIsIcon: false,
      //   subGraphics: 'reload.png',
      // ),
      // CourseDetail(
      //   title: 'Challenge',
      //   background: kCourseColors[7]['background'],
      //   icon: 'games.png',
      //   progress: 50,
      //   progressColor: kCourseColors[7]['progress'],
      //   iconLabel: 'Games',
      //   subtitle1: 'Rank: 5th',
      //   subGraphicsIsIcon: false,
      //   subGraphics: 'challenge.png',
      // ),
      // CourseDetail(
      //   title: 'LeaderBoard',
      //   background: kCourseColors[8]['background'],
      //   icon: 'progress.png',
      //   progress: 75,
      //   progressColor: kCourseColors[8]['progress'],
      //   iconLabel: 'Progress',
      //   subtitle1: 'Rank: 2nd',
      //   subGraphicsIsIcon: false,
      //   subGraphics: 'leaderboard.png',
      // )
    ];

    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            CoursesPageHeader(
              pageHeading: widget.courseInfo.title,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CourseDetailCard(
                        courseDetail: courseDetails[0],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings:
                                  RouteSettings(name: LearnMode.routeName),
                              builder: (context) {
                                return LearnMode(
                                    widget.user, widget.courseInfo.course);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CourseDetailCard(
                        courseDetail: courseDetails[1],
                        onTap: () async {
                          List<Topic> topics = await TestController()
                              .getTopicsAndNotes(widget.courseInfo.course);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  settings: RouteSettings(
                                      name: CourseDetailsPage.routeName),
                                  builder: (context) {
                                    return NotesTopics(widget.user, topics);
                                  })).then((value) {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CourseDetailCard(
                        courseDetail: courseDetails[2],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: RouteSettings(
                                  name: CourseDetailsPage.routeName),
                              builder: (context) {
                                return TestTypeView(
                                    widget.user, widget.courseInfo.course);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CourseDetailCard(
                        courseDetail: courseDetails[3],
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AdeoDialog(
                                title: 'Live',
                                content: 'Live sessions feature coming soon.',
                                actions: [
                                  AdeoDialogAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CourseDetailCard(
                        courseDetail: courseDetails[4],
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AdeoDialog(
                                title: 'Games',
                                content:
                                    'Play educational games based on a course. Feature coming soon.',
                                actions: [
                                  AdeoDialogAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CourseDetailCard(
                        courseDetail: courseDetails[5],
                        onTap: () {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AdeoDialog(
                                title: 'Progress',
                                content:
                                    'Track your progress feature coming soon.',
                                actions: [
                                  AdeoDialogAction(
                                    label: 'Dismiss',
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
