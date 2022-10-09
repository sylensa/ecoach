import 'package:ecoach/controllers/revision_progress_controller.dart';
import 'package:ecoach/new_ui_ben/screens/revision/revision_review.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../database/study_db.dart';
import '../../../models/revision_study_progress.dart';
import '../../providers/welcome_screen_provider.dart';
import '../../widgets/learn_card.dart';

class ChoseRevisionMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RevisionProgressController controller = RevisionProgressController();

    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Revision',
          style: TextStyle(
            fontFamily: 'Cocon',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Consumer<WelcomeScreenProvider>(
          builder: (_, welcome, __) => SingleChildScrollView(
            child: FutureBuilder<List<RevisionStudyProgress?>>(
                future: StudyDB()
                    .getRevisionProgressByCourse(welcome.currentCourse!),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  print("revision ${snapshot.data}");

                  return Column(
                    children: [
                      const Text(
                        "A quick way to prep for your exam",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                      ),
                      const SizedBox(
                        height: 67,
                      ),
                      Visibility(
                        visible: snapshot.data!.isNotEmpty,
                        child: LearnCard(
                          title: 'Ongoing',
                          desc: 'Do a quick revision for an upcoming exam',
                          value: welcome.currentRevisionStudyProgress == null
                              ? 0
                              : (((welcome.currentRevisionStudyProgress!
                                              .level! -
                                          1)) /
                                      welcome.totalTopics) *
                                  100,
                          icon: 'assets/images/learn_mode2/hourglass.png',
                          onTap: () async {
                            controller.getRevisionQuestion();
                            // controller.recordAttempts();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      LearnCard(
                        title: 'New',
                        desc: 'Discard old revision and start a new one',
                        value: 0,
                        icon: 'assets/images/learn_mode2/stopwatch.png',
                        onTap: () {
                          print("new revision");
                          controller.restartRevenue();
                          // controller.recordAttempts();
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      FutureBuilder<List<RevisionStudyProgress?>>(
                          future: StudyDB().getRevisionProgressByCourse(
                              Provider.of<WelcomeScreenProvider>(context,
                                      listen: false)
                                  .currentCourse!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                            return LearnCard(
                              subTitle: 'view',
                              secondarySubTitle: snapshot.data == null
                                  ? "0x"
                                  : "${snapshot.data!.length}x",
                              title: 'Completed',
                              desc: 'View stats on completed revision rounds',
                              value: 100,
                              icon: 'assets/images/learn_mode2/completed.png',
                              onTap: () {
                                Get.to(() => RevisionReview());
                              },
                            );
                          }),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
