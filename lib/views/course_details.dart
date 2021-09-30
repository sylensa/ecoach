import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/test_taken_db.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        courseProgress = (value * 100).floor();
      });
    });
    UserPreferences().getUserLastNote().then((value) {
      setState(() {
        lastNote = value!;
      });
    });
    TestTakenDB().courseLastTest(widget.courseInfo.course.id).then((value) {
      setState(() {
        lastTest = value != null ? value.testname! : "No Test Yet";
        rank = value != null ? "${value.userRank ?? '----'}" : "----";
      });
    });

    UserPreferences().getUserLastStudy().then((value) {
      setState(() {
        lastStudy = value!;
      });
    });
    UserPreferences().getUserLastStudyTopic().then((value) {
      setState(() {
        lastStudyTopic = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    List<CourseDetail> courseDetails = [
      CourseDetail(
        title: lastStudy,
        background: kCourseColors[4]['background'],
        icon: 'learn.png',
        progress: 75,
        progressColor: kCourseColors[4]['progress'],
        iconLabel: 'Learn',
        subtitle1: lastStudyTopic,
        subtitle2: '',
        subGraphicsIsIcon: true,
        subGraphics: Icons.play_arrow_sharp,
      ),
      CourseDetail(
        title: lastNote,
        background: kCourseColors[5]['background'],
        icon: 'notes.png',
        progress: 80,
        progressColor: kCourseColors[5]['progress'],
        iconLabel: 'Notes',
        subGraphicsIsIcon: true,
        subGraphics: Icons.pause,
      ),
      CourseDetail(
        title: 'BECE 2020',
        background: kCourseColors[6]['background'],
        icon: 'tests.png',
        progress: 50,
        progressColor: kCourseColors[6]['progress'],
        iconLabel: 'Tests',
        subtitle1: 'Rank: $rank',
        subGraphicsIsIcon: false,
        subGraphics: 'reload.png',
      ),
      CourseDetail(
        title: 'Challenge',
        background: kCourseColors[7]['background'],
        icon: 'games.png',
        progress: 50,
        progressColor: kCourseColors[7]['progress'],
        iconLabel: 'Games',
        subtitle1: 'Rank: 5th',
        subGraphicsIsIcon: false,
        subGraphics: 'challenge.png',
      ),
      CourseDetail(
        title: 'LeaderBoard',
        background: kCourseColors[8]['background'],
        icon: 'progress.png',
        progress: 75,
        progressColor: kCourseColors[8]['progress'],
        iconLabel: 'Progress',
        subtitle1: 'Rank: 2nd',
        subGraphicsIsIcon: false,
        subGraphics: 'leaderboard.png',
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          kCapitalizeString(widget.courseInfo.title),
          style: TextStyle(
            fontSize: 24.0,
            color: Color(0x99000000),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        // automaticallyImplyLeading: false,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: CourseDetailCard(courseDetail: courseDetails[0]),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: CourseDetailCard(courseDetail: courseDetails[1]),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: CourseDetailCard(
              courseDetail: CourseDetail(
                title: lastTest,
                background: kCourseColors[6]['background'],
                icon: 'tests.png',
                progress: courseProgress,
                progressColor: kCourseColors[6]['progress'],
                iconLabel: 'Tests',
                subtitle1: 'Rank: $rank',
                subGraphicsIsIcon: false,
                subGraphics: 'reload.png',
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TestTypeView(widget.user, widget.courseInfo.course);
                }));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: CourseDetailCard(courseDetail: courseDetails[3]),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: CourseDetailCard(courseDetail: courseDetails[4]),
          ),
        ],
      ),
    );
  }
}
