import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/new_learn_mode/providers/learn_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../database/study_db.dart';
import '../../../models/topic.dart';
import '../../utils/revision_utils.dart';
import '../../widgets/bullet_rules_container.dart';
import 'chose_revision_mode.dart';

class Revision extends StatelessWidget {
  final List<Topic>? topics;
  final Function onTap;
  final StudyProgress? progress;
  const Revision({this.progress, required this.onTap, this.topics, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LearnModeProvider>(
      builder: (_, revision, __) => Scaffold(
        backgroundColor: const Color(0xFF0367B4),
        appBar: AppBar(
          title: const Text(
            'Revision',
            style: TextStyle(
                fontFamily: 'Cocon', fontWeight: FontWeight.w700, fontSize: 28),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Get.to(() => ChoseRevisionMode());
            // onTap();
          },
          child: Container(
            color: const Color(0xFF00C9B9),
            height: 60,
            alignment: Alignment.center,
            child: FutureBuilder<RevisionStudyProgress?>(
                future: StudyDB().getCurrentRevisionProgressByCourse(
                    revision.currentCourse!.id!),
                builder: (context, revisionProgressSnapshot) {
                  if (revisionProgressSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return Text(
                    revisionProgressSnapshot.data == null
                        ? 'Start Revision'
                        : "Continue Revision",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  );
                }),
          ),
        ),
        body: Consumer<LearnModeProvider>(
          builder: (_, welcome, __) => FutureBuilder<List<Topic>>(
            future: TopicDB().allCourseTopics(welcome.currentCourse!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              print("total course from database ${snapshot.data!.length}");
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "A quick way to prep for your exam",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          FutureBuilder<RevisionStudyProgress?>(
                              future: StudyDB()
                                  .getCurrentRevisionProgressByCourse(
                                      welcome.currentCourse!.id!),
                              builder: (context, progressSnapshot) {
                                if (progressSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                return Text(
                                  progressSnapshot.data == null
                                      ? "${snapshot.data!.length}"
                                      : "${snapshot.data!.length - (progressSnapshot.data!.level! - 1)}",
                                  style: TextStyle(
                                    fontFamily: 'Cocon',
                                    fontSize: 95,
                                    color: Color(0xFF00C9B9),
                                  ),
                                );
                              }),
                          Image.asset('assets/images/learn_mode2/shadow.png')
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "topics to be revised",
                        style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Rules',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BulletRulesContainer(
                        rules: revisionRulesList,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
