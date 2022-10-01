import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/study_revision_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/new_ui_ben/providers/welcome_screen_provider.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/views/learn/learn_revision.dart';
import 'package:ecoach/views/study/study_quiz_cover.dart';
import 'package:ecoach/widgets/layouts/learn_peripheral_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearnImageScreens extends StatelessWidget {
  LearnImageScreens(
      {Key? key, required this.studyController, this.pageIndex = 0})
      : super(key: key);
  final StudyController studyController;
  final CarouselController controller = CarouselController();
  int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CarouselSlider(
        items: [
          LearnPeripheralWidget(
            heroText: 'Great Job',
            subText: '${studyController.name}\ncompleted',
            heroImageURL: 'assets/images/learn_module/module_completed.png',
            mainActionLabel: 'Next topic',
            mainActionColor: Color(0xFFFB7B76),
            mainActionOnPressed: () async {
              final WelcomeScreenProvider welcomeProvider =
                  Provider.of(context, listen: false);

              StudyType studyType = welcomeProvider.currentStudyType!;

              if (studyType == StudyType.REVISION) {
                RevisionStudyProgress revisionStudyProgress =
                    welcomeProvider.currentRevisionStudyProgress!;
                Topic? topic = await TopicDB().getLevelTopic(
                    revisionStudyProgress.courseId!,
                    revisionStudyProgress.level!);

                if (topic != null) {
                  List<Question> questions =
                      await QuestionDB().getTopicQuestions([topic.id!], 10);

                  int nextLevel = studyController.nextLevel;

                  StudyProgress progress = StudyProgress(
                      id: topic.id,
                      studyId: studyController.progress.studyId!,
                      level: nextLevel,
                      topicId: topic.id,
                      name: topic.name,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now());
                  await StudyDB().insertProgress(progress);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return StudyQuizCover(
                          topicName: topic.name,
                          controller: RevisionController(
                              studyController.user, studyController.course,
                              questions: questions,
                              name: progress.name!,
                              progress: progress));
                    }),
                    ModalRoute.withName(
                      LearnRevision.routeName,
                    ),
                  );
                }
              }

              // int nextLevel = studyController.nextLevel;

              // Topic? topic = await TopicDB()
              //     .getLevelTopic(studyController.course.id!, nextLevel);

              // if (topic != null) {
              //   print("${topic.name}");
              //   StudyProgress progress = StudyProgress(
              //       id: topic.id,
              //       studyId: studyController.progress.studyId!,
              //       level: nextLevel,
              //       topicId: topic.id,
              //       name: topic.name,
              //       createdAt: DateTime.now(),
              //       updatedAt: DateTime.now());
              //   await StudyDB().insertProgress(progress);
              //   List<Question> questions =
              //       await QuestionDB().getTopicQuestions([topic.id!], 10);

              //   Navigator.pushAndRemoveUntil(context,
              //       MaterialPageRoute(builder: (context) {
              //     return StudyQuizCover(
              //         topicName: topic.name,
              //         controller: RevisionController(
              //             studyController.user, studyController.course,
              //             questions: questions,
              //             name: progress.name!,
              //             progress: progress));
              //   }), ModalRoute.withName(LearnRevision.routeName));
              // } else {
              //   ScaffoldMessenger.of(context)
              //       .showSnackBar(SnackBar(content: Text("No more topics")));
              // }
            },
            topActionLabel: 'exit',
            topActionColor: Color(0xFFFB7B76),
            topActionOnPressed: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(LearnMode.routeName));
            },
            largeSubs: true,
          ),
          LearnPeripheralWidget(
            heroText: 'Yeah!!!',
            subText: 'Mission\ncompleted',
            heroImageURL:
                'assets/images/revision_module/mission_accomplished.png',
            mainActionLabel: 'Next mission',
            mainActionColor: Color(0xFFFB7B76),
            mainActionBackground: Color(0xFFF0F0F2),
            mainActionOnPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LearnMode(studyController.user, studyController.course);
              }), ModalRoute.withName(LearnMode.routeName));
            },
            topActionLabel: 'return',
            topActionOnPressed: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(LearnMode.routeName));
            },
            largeSubs: true,
          ),
        ],
        carouselController: controller,
        options: CarouselOptions(
            aspectRatio: 1 / 2,
            viewportFraction: 1,
            scrollPhysics: NeverScrollableScrollPhysics(),
            enableInfiniteScroll: false,
            initialPage: pageIndex,
            onPageChanged: (index, reason) {
              // setState(() {
              //   currentSliderIndex = index;
              // });
            }),
      ),
    );
  }
}
