import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/new_learn_mode/controllers/revision_progress_controller.dart';
import 'package:ecoach/new_learn_mode/providers/learn_mode_provider.dart';
import 'package:ecoach/new_learn_mode/screens/revision/chose_revision_mode.dart';
import 'package:ecoach/new_learn_mode/utils/revision_utils.dart';
import 'package:ecoach/new_learn_mode/widgets/bullet_rule.dart';
import 'package:ecoach/new_learn_mode/widgets/bullet_rules_container.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/learn/learn_revision.dart';
import 'package:ecoach/widgets/cards/hero_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RevisionBottomSheetContent extends StatefulWidget {
  const RevisionBottomSheetContent({
    Key? key,
    this.user,
    this.course,
    this.progress,
    // this.showNewRevisionInstructions = false,
  }) : super(key: key);

  final User? user;
  final Course? course;
  final StudyProgress? progress;

  @override
  State<RevisionBottomSheetContent> createState() =>
      _RevisionBottomSheetContentState();
}

class _RevisionBottomSheetContentState
    extends State<RevisionBottomSheetContent> {
  late bool _showIntro;
  late double _sheetHeight = appHeight(context) * 0.50;
  late List<BulletRule> _rules = revisionRulesList;

  @override
  void initState() {
    super.initState();
    _showIntro = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: _sheetHeight,
        onEnd: (() {
          setState(() {
            _showIntro = true;
          });
        }),
        decoration: BoxDecoration(
          color: kAdeoGray4,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        duration: Duration(microseconds: 600),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey,
              ),
              height: 3,
              width: 84,
            ),
            SizedBox(
              height: 42,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText(
                "Revision",
                color: Colors.black,
                weight: FontWeight.w400,
                align: TextAlign.center,
                size: 24,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (!_showIntro)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: sText(
                  "Select your category",
                  color: kAdeoGray3,
                  weight: FontWeight.w400,
                  align: TextAlign.center,
                  size: 15,
                ),
              ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: _showIntro
                    ? SingleChildScrollView(
                        child: Column(
                        children: [
                          Consumer<LearnModeProvider>(
                            builder: (_, welcome, __) =>
                                FutureBuilder<List<Topic>>(
                              future: TopicDB()
                                  .allCourseTopics(welcome.currentCourse!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }
                                return SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          FutureBuilder<RevisionStudyProgress?>(
                                            future: StudyDB()
                                                .getCurrentRevisionProgressByCourse(
                                                    welcome.currentCourse!.id!),
                                            builder:
                                                (context, progressSnapshot) {
                                              if (progressSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              return sText(
                                                progressSnapshot.data == null
                                                    ? "${snapshot.data!.length}"
                                                    : "${snapshot.data!.length - (progressSnapshot.data!.level! - 1)}",
                                                size: 72,
                                                color: kAdeoGreen4,
                                              );
                                            },
                                          ),
                                          Image.asset(
                                            'assets/images/learn_mode2/shadow.png',
                                            width: 90,
                                            opacity:
                                                AlwaysStoppedAnimation<double>(
                                              0.05,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      sText(
                                        "topics to be revised",
                                        size: 12,
                                        style: FontStyle.italic,
                                        color: kAdeoGray3,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 26,
                          ),
                          HeroCard(
                            child: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ..._rules,
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) {
                                                return ChoseRevisionMode();
                                              }),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 28,
                                            vertical: 14,
                                          ),
                                          child: sText(
                                            "Start",
                                            color: Colors.white,
                                          ),
                                          decoration: BoxDecoration(
                                            color: kAdeoGreen4,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))
                    : Center(
                        child: sText(
                          "You  have no revision history",
                          size: 20,
                          color: kAdeoGray2.withOpacity(0.6),
                          weight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!_showIntro) {
                  setState(() {
                    _sheetHeight = appHeight(context) * 0.96;
                  });
                }
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     settings: RouteSettings(name: CoursesDetailsPage.routeName),
                //     builder: (context) {
                //       return LearnRevision(
                //         widget.user!,
                //         widget.course!,
                //         widget.progress!,
                //       );
                //     },
                //   ),
                // );
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: 14,
                  left: 10,
                  right: 10,
                  bottom: 20,
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                    color: kAdeoWhiteAlpha81,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: kAdeoGreen4,
                    )),
                // height: 100,
                child: Container(
                    child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New",
                                softWrap: true,
                                style: TextStyle(
                                  color: Colors.black87.withOpacity(0.6),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Do a quick revision for an upcoming exam",
                                style: TextStyle(
                                  color: kAdeoGray3,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          child: Image.asset(
                            'assets/icons/courses/clock.png',
                            fit: BoxFit.fill,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            backgroundColor: kAdeoGray4,
                            color: kAdeoGreen4,
                            minHeight: 7,
                            value: 0,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "try it",
                          style: TextStyle(
                            color: kAdeoGray3,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ),
            ),
          ],
        ));
  }
}
