import 'package:ecoach/controllers/study_speed_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/new_ui_ben/screens/level_start_screen.dart';
import 'package:ecoach/new_ui_ben/screens/speed_improvement/utils/speed_enhancement_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/questions_db.dart';
import '../../models/question.dart';
import '../../new_ui_ben/providers/welcome_screen_provider.dart';
import '../study/study_quiz_view.dart';

class LearnSpeedEnhancementCompletion extends StatelessWidget {
  const LearnSpeedEnhancementCompletion({
    // required this.controller,
    required this.progress,
    required this.level,
    this.moveUp = true,
  });

  // final SpeedController controller;
  final Map<String, dynamic> level;
  final bool moveUp;
  final StudyProgress progress;
  final List<String> images = const [
    'tortoise',
    'fowl',
    'antelope',
    'cheetah',
    'falcon',
    'eagle'
  ];

  final List<int> seconds = const [120, 90, 60, 30, 15, 10];

  @override
  Widget build(BuildContext context) {
    // SpeedEnhancementLevel currentLevel = speedEnhancementLevels[level['level']];

    return Scaffold(
      body: Consumer<WelcomeScreenProvider>(
        builder: (_, welcome, __) {
          SpeedEnhancementLevel currentLevel = speedEnhancementLevels[
              welcome.currentSpeedStudyProgress!.level! - 1];

          return LevelStartScreen(
              onSwipe: () async {
                // get current course speed level

                // SpeedStudyProgress? speed = await StudyDB()
                //     .getCurrentSpeedProgressLevelByCourse(
                //         welcome.currentCourse!.id!);

                // int nextLevel = moveUp
                //     ? speed!.level! + 1
                //     : speed!.level! - 1;
                // if (nextLevel < 1) {
                //   nextLevel = 1;
                // }

                // update level of current course speed
                // speed.level = nextLevel;
                // speed.updatedAt = DateTime.now();
                // await StudyDB().updateSpeedProgressLevel(speed);

                // // update the provider
                // welcome.setCurrentSpeedProgress(speed);

                Topic? topic = await TopicDB()
                    .getLevelTopic(welcome.currentCourse!.id!, 1);
                if (topic != null) {
                  print("${topic.name}");
                  StudyProgress newProgress = StudyProgress(
                      id: topic.id,
                      studyId: progress.studyId!,
                      level: null,
                      topicId: topic.id,
                      section: 1,
                      name: progress.name,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now());
                  await StudyDB().insertProgress(progress);

                  // Navigator.pushAndRemoveUntil(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return LearnSpeed(
                  //     controller.user,
                  //     controller.course,
                  //     progress,
                  //     page: 1,
                  //   );
                  // }), ModalRoute.withName(LearnSpeed.routeName));

                  List<Question> questions = await QuestionDB()
                      .getRandomQuestions(welcome.currentCourse!.id!, 10);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return StudyQuizView(
                          controller: SpeedController(
                            welcome.currentUser!,
                            welcome.currentCourse!,
                            questions: questions,
                            name: progress.name!,
                            progress: progress,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("No topics")));
                }
              },
              bgImage: currentLevel.backgroundImage,
              levelImage: currentLevel.levelImage,
              label: currentLevel.label,
              level: currentLevel.level,
              timer: currentLevel.timer);
        },
      ),
    );

    // Scaffold(
    //   body: SingleChildScrollView(
    //     child: Container(
    //       color: Colors.white,
    //       width: double.infinity,
    //       height: MediaQuery.of(context).size.height,
    //       child: Column(
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(12.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 AdeoGrayOutlinedButton(
    //                   label: 'return',
    //                   onPressed: () {
    //                     Navigator.popUntil(
    //                         context, ModalRoute.withName(LearnMode.routeName));
    //                   },
    //                   size: Sizes.small,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Expanded(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.max,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   moveUp ? 'Congratulations' : 'Aww',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     color: kAdeoCoral,
    //                     fontWeight: FontWeight.w600,
    //                     fontSize: 28.0,
    //                   ),
    //                 ),
    //                 SizedBox(height: 32.0),
    //                 Text(
    //                   moveUp
    //                       ? 'You moved up to level ${level['level'].toString()}, the ${images[level['level'] - 1]} zone'
    //                       : 'You moved down to level ${level['level'].toString()}, the ${images[level['level'] - 1]} zone',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     color: Color(0xFFACACAC),
    //                     fontSize: 12.0,
    //                     fontWeight: FontWeight.w500,
    //                     fontStyle: FontStyle.italic,
    //                   ),
    //                 ),
    //                 SizedBox(height: 40.0),
    //                 Text(
    //                   '${seconds[level['level'] - 1].toString()} sec : ${level['questions'].toString()} question(s)',
    //                   style: TextStyle(
    //                     fontSize: 14.0,
    //                     color: kAdeoBlue,
    //                     fontWeight: FontWeight.w600,
    //                   ),
    //                 ),
    //                 SizedBox(height: 48.0),
    //                 Container(
    //                   width: 240.0,
    //                   child: Image.asset(
    //                     'assets/images/learn_module/${images[level['level'] - 1]}.png',
    //                     fit: BoxFit.contain,
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //           AdeoOutlinedButton(
    //             label: 'OK',
    //             onPressed: () async {
    //               int nextLevel = moveUp
    //                   ? controller.nextLevel
    //                   : controller.progress.level! - 1;
    //               if (nextLevel < 1) {
    //                 nextLevel = 1;
    //               }
    //
    //               Topic? topic =
    //                   await TopicDB().getLevelTopic(controller.course.id!, 1);
    //               if (topic != null) {
    //                 print("${topic.name}");
    //                 StudyProgress progress = StudyProgress(
    //                     id: topic.id,
    //                     studyId: controller.progress.studyId!,
    //                     level: nextLevel,
    //                     topicId: topic.id,
    //                     section: 1,
    //                     name: controller.progress.name,
    //                     createdAt: DateTime.now(),
    //                     updatedAt: DateTime.now());
    //                 await StudyDB().insertProgress(progress);
    //
    //                 Navigator.pushAndRemoveUntil(context,
    //                     MaterialPageRoute(builder: (context) {
    //                   return LearnSpeed(
    //                       controller.user, controller.course, progress);
    //                 }), ModalRoute.withName(LearnSpeed.routeName));
    //               } else {
    //                 ScaffoldMessenger.of(context)
    //                     .showSnackBar(SnackBar(content: Text("No topics")));
    //               }
    //             },
    //             color: kAdeoBlue,
    //             borderRadius: 0,
    //           ),
    //           SizedBox(height: 48.0),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
