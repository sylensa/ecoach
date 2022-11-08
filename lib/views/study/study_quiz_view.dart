import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/controllers/study_speed_controller.dart';
import 'package:ecoach/database/mastery_course_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/new_learn_mode/controllers/course_completion_controller.dart';
import 'package:ecoach/new_learn_mode/controllers/revision_progress_controller.dart';
import 'package:ecoach/new_learn_mode/providers/learn_mode_provider.dart';
import 'package:ecoach/new_learn_mode/providers/revision_attempts_provider.dart';
import 'package:ecoach/new_learn_mode/screens/revision/successful_revision.dart';
import 'package:ecoach/views/learn/learn_mastery_feedback.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/views/study/study_cc_results.dart';
import 'package:ecoach/views/study/study_notes_view.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/quiz_controller.dart';
import '../../database/study_db.dart';
import '../../helper/helper.dart';
import '../../models/course.dart';
import '../../models/course_completion_study_progress.dart';
import '../../models/flag_model.dart';
import '../../models/revision_study_progress.dart';
import '../../models/speed_enhancement_progress_model.dart';
import '../../new_learn_mode/controllers/speed_study_controller.dart';
import '../../new_learn_mode/screens/course_completion/choose_cc_mode.dart';
import '../../new_learn_mode/screens/mastery/mastery_improvement_topics.dart';
import '../../new_learn_mode/screens/speed_improvement/speed_mode_selection.dart';
import '../../new_learn_mode/widgets/answers_widget.dart';
import '../../new_learn_mode/widgets/save_question_widget.dart';
import '../../revamp/core/utils/app_colors.dart';
import '../../revamp/features/questions/view/widgets/actual_question.dart';
import '../../utils/style_sheet.dart';
import '../learn/learn_speed_enhancement.dart';
import '../learn/learn_speed_enhancement_completion.dart';

class StudyQuizView extends StatefulWidget {
  const StudyQuizView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final StudyController controller;

  @override
  _StudyQuizViewState createState() => _StudyQuizViewState();
}

class _StudyQuizViewState extends State<StudyQuizView> {
  late StudyController controller;
  late final PageController pageController;

  TestTaken? testTaken;
  TestTaken? testTakenSaved;
  bool showSubmit = false;
  bool answeredWrong = false;
  bool wasWrong = false;
  bool showNext = false;
  bool showComplete = false;
  List<bool> isAnsweredQuestions = [];
  int correctAnswered = 0;
  int wrong = 0;
  int totalQuestionsAnswered = 0;
  double avgScore = 0.0;
  late DateTime revisionStartTime;

  List<ListNames> listReportsTypes = [
    ListNames(name: "Select Error Type", id: "0"),
    ListNames(name: "Typographical Mistake", id: "1"),
    ListNames(name: "Wrong Answer", id: "2"),
    ListNames(name: "Problem With The Question", id: "3")
  ];
  ListNames? reportTypes;
  TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionNode = FocusNode();

  successModalBottomSheet(context, {Question? question}) {
    double sheetHeight = 350.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // timerController.resume();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.green, width: 15),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 100,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: sText("Error report successfully submitted",
                            weight: FontWeight.bold,
                            size: 20,
                            align: TextAlign.center),
                      )
                    ],
                  ));
            },
          );
        });
  }

  failedModalBottomSheet(context, {Question? question}) {
    double sheetHeight = 330.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // timerController.resume();
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.red, width: 15),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 100,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: sText("Error report failed try again",
                            weight: FontWeight.bold,
                            size: 20,
                            align: TextAlign.center),
                      )
                    ],
                  ));
            },
          );
        });
  }

  calAvgScore() {
    double totalAverage = 0.0;
    // print("avg scoring current question= $unattempted");
    int totalQuestions = correctAnswered + wrong;

    int correctAnswers = correctAnswered;
    if (totalQuestions == 0) {
      avgScore = 0;
    }
    totalAverage = (correctAnswers / totalQuestions) * 100;
    avgScore = double.parse(totalAverage.toInt().toString());
  }

  setRevisionTime() {
    Provider.of<RevisionAttemptProvider>(context, listen: false)
        .setTime(DateTime.now());
  }

  setStudyController() {
    Provider.of<LearnModeProvider>(context, listen: false)
        .setCurrentStudyController(controller);
  }

  reportModalBottomSheet(context, {Question? question}) async {
    double sheetHeight = 440.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              if (controller.type ==
                                      StudyType.SPEED_ENHANCEMENT ||
                                  controller.type ==
                                      StudyType.COURSE_COMPLETION) {
                                controller.timerController!.resume();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        child: Icon(
                          Icons.warning,
                          color: Colors.orange,
                          size: 50,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[200]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: sText("Error Reporting",
                            weight: FontWeight.bold, size: 20),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(left: 12, right: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ListNames>(
                                    value: reportTypes == null
                                        ? listReportsTypes[0]
                                        : reportTypes,
                                    itemHeight: 48,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: kDefaultBlack,
                                    ),
                                    // onTap: (){
                                    //   stateSetter((){
                                    //     sheetHeight = 400;
                                    //   });
                                    // },

                                    onChanged: (ListNames? value) {
                                      stateSetter(() {
                                        reportTypes = value;
                                        sheetHeight = 700;
                                        FocusScope.of(context)
                                            .requestFocus(descriptionNode);
                                      });
                                    },
                                    items: listReportsTypes
                                        .map(
                                          (item) => DropdownMenuItem<ListNames>(
                                            value: item,
                                            child: Text(
                                              item.name,
                                              style: TextStyle(
                                                color: kDefaultBlack,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      // autofocus: true,
                                      controller: descriptionController,
                                      focusNode: descriptionNode,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please check that you\'ve entered your email correctly';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        stateSetter(() {
                                          sheetHeight = 440;
                                        });
                                      },
                                      onTap: () {
                                        stateSetter(() {
                                          sheetHeight = 700;
                                        });
                                      },
                                      decoration: textDecorNoBorder(
                                        hint: 'Description',
                                        radius: 10,
                                        labelText: "Description",
                                        hintColor: Colors.black,
                                        fill: Colors.white,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("${reportTypes}");
                          if (descriptionController.text.isNotEmpty) {
                            if (reportTypes != null) {
                              stateSetter(() {
                                isSubmit = false;
                              });
                              try {
                                FlagData flagData = FlagData(
                                    reason: descriptionController.text,
                                    type: reportTypes!.name,
                                    questionId: question!.id);
                                var res = await QuizController(
                                        controller.user, controller.course,
                                        name: "")
                                    .saveFlagQuestion(
                                        context, flagData, question.id!);
                                print("final res:$res");
                                if (res) {
                                  stateSetter(() {
                                    descriptionController.clear();
                                  });
                                  Navigator.pop(context);
                                  successModalBottomSheet(context);
                                } else {
                                  Navigator.pop(context);
                                  failedModalBottomSheet(context);
                                  print("object res: $res");
                                }
                              } catch (e) {
                                stateSetter(() {
                                  isSubmit = true;
                                });
                                print("error: $e");
                              }
                            } else {
                              toastMessage("Select error type");
                            }
                          } else {
                            toastMessage("Description is required");
                          }
                        },
                        child: Container(
                          padding: appPadding(20),
                          width: appWidth(context),
                          color: isSubmit ? Colors.blue : Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              sText("Submit",
                                  align: TextAlign.center,
                                  weight: FontWeight.bold,
                                  color: isSubmit ? Colors.white : Colors.black,
                                  size: 25),
                              SizedBox(
                                width: 10,
                              ),
                              isSubmit ? Container() : progress()
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            },
          );
        });
  }

  @override
  void initState() {
    controller = widget.controller;
    pageController = PageController(initialPage: controller.currentQuestion);
    revisionStartTime = DateTime.now();
    setRevisionTime();
    setStudyController();

    print("Controller details: ${controller.type}");
    setState(() {
      controller.startTest();
    });
    super.initState();
  }

  nextButton() {
    print("Controller details: ${controller.type}");
    if (controller.currentQuestion == controller.questions.length - 1) {
      return;
    }
    setState(() {
      // if (controller.type == StudyType.COURSE_COMPLETION ||
      //     controller.type == StudyType.MASTERY_IMPROVEMENT) {
      //   setState(() {
      //     if (answeredWrong) {
      //       wrong++;
      //       wasWrong = true;
      //     } else {
      //       correctAnswered++;
      //       wasWrong = false;
      //     }
      //
      //     calAvgScore();
      //   });
      // }

      controller.currentQuestion++;
      showNext = false;
      if (controller.type == StudyType.REVISION ||
          controller.type == StudyType.SPEED_ENHANCEMENT) {
        // controller.enabled = true;
      }

      pageController.nextPage(
          duration: Duration(milliseconds: 1), curve: Curves.ease);

      if (controller.type == StudyType.SPEED_ENHANCEMENT &&
          controller.enabled) {
        ((controller) as SpeedController).resetTimer();
      }
    });
  }

  notesButton() async {
    Course course =
        Provider.of<LearnModeProvider>(context, listen: false).currentCourse!;

    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(course.id!);

    Topic? topic =
        await TopicDB().getTopicById(revisionStudyProgress!.topicId!);

    controller.saveTest(context, (test, success) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StudyNoteView(topic!, controller: controller);
      }));
    });
  }

  endSpeedSession() async {
    if (controller.type == StudyType.SPEED_ENHANCEMENT) {
      SpeedStudyProgressController().manageSpeedEnhancementLevels();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return ChooseSpeedMode();
      }), ModalRoute.withName(LearnSpeed.routeName));
    } else if (controller.type == StudyType.COURSE_COMPLETION) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return ChoseCourseCompletionMode(
            continueOngoing: () {},
          );
        }),
        ModalRoute.withName(LearnSpeed.routeName),
      );
    }
  }

  completeQuiz() async {
    await scoreCurrentQuestion(controller.questions[controller.currentQuestion]);

    setState(() {
      controller.enabled = false;
    });
    showLoaderDialog(context, message: "Test Completed\nSaving results");

    await Future.delayed(Duration(seconds: 1));

    controller.saveTest(context, (test, success) async {
      Navigator.pop(context);
      // if (success) {
      setState(() {
        testTakenSaved = test;
        controller.savedTest = true;
        controller.enabled = false;
      });
      await controller.updateProgress(test!);

      progressCompleteView();
      // }
    });
  }

  progressCompleteView() async {
    Provider.of<RevisionAttemptProvider>(context, listen: false)
        .setQuestionCountAndAvgScore(
            questionsLength: correctAnswered + wrong, score: avgScore);

    if (StudyType.REVISION == controller.type) {
      RevisionStudyProgress? revision = await StudyDB()
          .getCurrentRevisionProgressByCourse(controller.course.id!);

      controller.currentQuestion = 0;
      controller.reviewMode = true;
      pageController.jumpToPage(controller.currentQuestion);

      RevisionProgressController().recordAttempts(correctAnswered.toDouble());

      if (revision != null) {
        int revisionLevel =
            avgScore >= 70 ? revision.level! + 1 : revision.level!;

        revision.level = revisionLevel;
        revision.updatedAt = DateTime.now();
        print("revision update => ${revision.toMap()}");
        await StudyDB().updateRevisionProgress(revision);
        Provider.of<LearnModeProvider>(Get.context!, listen: false)
            .setCurrentRevisionStudyProgress(revision);
      }

      Get.to(() => SuccessfulRevision())!.then((value) {
        controller.currentQuestion = 0;
        controller.reviewMode = true;
        pageController.jumpToPage(controller.currentQuestion);
      });

      return;
    }

    if (StudyType.SPEED_ENHANCEMENT == controller.type) {
      SpeedStudyProgress? speed = await StudyDB()
          .getCurrentSpeedProgressLevelByCourse(controller.course.id!);

      if (correctAnswered == 10) {
        speed!.fails = 0;
        if (speed.level! < 6) {
          speed.level = speed.level! + 1;
        } else {
          speed.level = 6;
        }

        print("correct answer" + "${speed.toMap()}");

        StudyDB().updateSpeedProgressLevel(speed);
        Provider.of<LearnModeProvider>(context, listen: false)
            .setCurrentSpeedProgress(speed);
      }

      Get.off(
        () => LearnSpeedEnhancementCompletion(
          progress: controller.progress,
          level: {
            'level': controller.nextLevel,
            'duration': controller.resetDuration!.inSeconds,
            'questions': 1
          },
        ),
      );

      return;
    }

    if (StudyType.MASTERY_IMPROVEMENT == controller.type) {
      int level = controller.progress.level!;
      controller.updateProgressSection(2);
      print("level $level");
      final masteryTopics = await MasteryCourseDB().getMasteryTopicsUpgrade(
          Provider.of<LearnModeProvider>(context, listen: false)
              .currentCourse!
              .id!);
      if (masteryTopics.isEmpty) {
        Get.to(() => MasteryImprovementTopics(
                  test: testTakenSaved!,
                  controller: controller as MasteryController,
                ))!
            .then((value) {
          controller.currentQuestion = 0;
          controller.reviewMode = true;
          pageController.jumpToPage(controller.currentQuestion);
        });
      } else {
        Get.to(() => LearnMasteryFeedback(
                passed: controller.progress.passed!,
                topic: controller.progress.name!,
                topicId: masteryTopics[0].topicId!,
                masteryCourseUpgrade: masteryTopics[0],
                controller: controller as MasteryController))!
            .then((value) {
          controller.currentQuestion = 0;
          controller.reviewMode = true;
          pageController.jumpToPage(controller.currentQuestion);
        });
      }

      return;
    }

    if (StudyType.COURSE_COMPLETION == controller.type) {
      CourseCompletionStudyController()
          .recordAttempts(correctAnswered.toDouble());

      Course? course =
          Provider.of<LearnModeProvider>(context, listen: false).currentCourse;

      CourseCompletionStudyProgress? completionStudyProgress = await StudyDB()
          .getCurrentCourseCompletionProgressByCourse(course!.id!);

      CourseCompletionStudyController()
          .updateInsertProgress(completionStudyProgress!);

      Get.to(() =>
              StudyCCResults(test: testTakenSaved!, controller: controller))!
          .then((value) {
        setState(() {
          controller.currentQuestion = 0;
          controller.reviewMode = true;
          pageController.jumpToPage(controller.currentQuestion);
        });
      });

      return;
    }

    // Navigator.push<void>(
    //   context,
    //   MaterialPageRoute<void>(builder: (BuildContext context) {
    //     if () {
    //
    //
    //
    //
    //       return
    //     }
    //
    //     // if (StudyType.SPEED_ENHANCEMENT == controller.type) {
    //     //   bool moveUp = controller.progress.section == null ||
    //     //       controller.progress.section! <= 3;
    //     //
    //     //   if (moveUp) {
    //     //     moveUp = controller.progress.passed!;
    //     //     SpeedStudyProgressController().updateCCLevel(moveUp);
    //     //   }
    //     //   return LearnSpeedEnhancementCompletion(
    //     //       progress: controller.progress,
    //     //       moveUp: moveUp,
    //     //       level: {
    //     //         'level':
    //     //             moveUp ? controller.nextLevel : controller.progress.level,
    //     //         'duration': controller.resetDuration!.inSeconds,
    //     //         'questions': 1
    //     //       });
    //     // }
    //     return SuccessfulRevision();
    //   }),
    // ).then((value) {
    //   setState(() {
    //     controller.currentQuestion = 0;
    //     controller.reviewMode = true;
    //     pageController.jumpToPage(controller.currentQuestion);
    //   });
    // });
  }

  viewResults() async {
    if (StudyType.MASTERY_IMPROVEMENT == controller.type) {
      int level = controller.progress.level!;
      controller.updateProgressSection(2);
      print("level $level");
      final masteryTopics = await MasteryCourseDB().getMasteryTopicsUpgrade(
          Provider.of<LearnModeProvider>(context, listen: false)
              .currentCourse!
              .id!);
      if (masteryTopics.isEmpty) {
        Get.to(() => MasteryImprovementTopics(
              test: testTakenSaved!,
              controller: controller as MasteryController,
            ));
      } else {
        Get.to(() => LearnMasteryFeedback(
            passed: controller.progress.passed!,
            topic: controller.progress.name!,
            topicId: masteryTopics[0].topicId!,
            masteryCourseUpgrade: masteryTopics[0],
            controller: controller as MasteryController));
      }
      return;
    }

    if (controller.type == StudyType.REVISION) {
      Get.to(() => SuccessfulRevision());
      return;
    }

    print("viewing results");
    print(testTakenSaved!.toJson().toString());
    Navigator.push<int>(
      context,
      MaterialPageRoute<int>(
        builder: (BuildContext context) {
          return StudyCCResults(test: testTakenSaved!, controller: controller);
        },
      ),
    ).then((value) {
      setState(() {
        controller.currentQuestion = 0;
        controller.reviewMode = true;
        if (value != null) {
          controller.currentQuestion = value;
        }
        pageController.jumpToPage(controller.currentQuestion);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("progress type : ${controller.type}");
    return WillPopScope(
      onWillPop: () async {
        if (!controller.enabled && !showNext) {
          return showExitDialog();
        }
        // timerController.pause();

        return showPauseDialog();
      },
      child: SafeArea(
        child: Scaffold(
            body: Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          // timerController.pause();
                          // Get.bottomSheet(quitWidget());
                          showExitDialog();
                          return;
                        },
                        icon: Icon(Icons.arrow_back)),
                    Container(
                      width: 250,
                      child: Text(
                        controller.name,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                              value: controller.percentageCompleted,
                            ),
                            Center(
                              child: Text(
                                "${controller.currentQuestion + 1}",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF969696)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          if (controller.type == StudyType.SPEED_ENHANCEMENT ||
                              controller.type == StudyType.COURSE_COMPLETION) {
                            controller.timerController!.pause();
                          }

                          await reportModalBottomSheet(context,
                              question: controller
                                  .questions[controller.currentQuestion]);
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
              Container(
                color: const Color(0xFF2D3E50),
                height: 47,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.type == StudyType.COURSE_COMPLETION ||
                        controller.type == StudyType.SPEED_ENHANCEMENT)
                      getTimerWidget(),
                    const SizedBox(
                      width: 7,
                    ),
                    const SizedBox(
                      height: 16,
                      child: VerticalDivider(
                        color: Color(0xFF9EE4FF),
                        width: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    !wasWrong
                        ? Image.asset(
                            "assets/images/un_fav.png",
                            color: Colors.green,
                          )
                        : SvgPicture.asset(
                            "assets/images/fav.svg",
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${avgScore}%",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9EE4FF),
                      ),
                    ),
                    const SizedBox(
                      width: 18.2,
                    ),
                    const SizedBox(
                      width: 17.6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "$correctAnswered",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9EE4FF),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 6.4,
                    ),
                    Text(
                      "${wrong}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9EE4FF),
                      ),
                    ),
                    const SizedBox(
                      width: 4.2,
                    ),
                    const SizedBox(
                      height: 16,
                      child: VerticalDivider(
                        color: Color(0xFF9EE4FF),
                        width: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 6.2,
                    ),
                    SavedQuestionWidget(
                      question:
                          controller.questions[controller.currentQuestion],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < controller.questions.length; i++)
                        StudyQuestionWidget(
                          controller.user,
                          controller.questions[i],
                          position: i,
                          enabled: controller.questionEnabled(i),
                          type: controller.type,
                          // useTex: useTex,
                          callback: (Answer answer, correct) async {
                            if (controller.type ==
                                StudyType.SPEED_ENHANCEMENT) {
                              setState(() {
                                ((controller) as SpeedController).resetTimer();
                              });
                              controller.timerController!.reset();
                              // showNext = true;
                            }

                            if (correct) {
                              answeredWrong = false;
                              correctAnswered++;
                            } else {
                              wrong++;
                              answeredWrong = true;
                            }

                            if (answeredWrong &&
                                controller.type ==
                                    StudyType.SPEED_ENHANCEMENT) {
                              controller.enabled = false;
                              showComplete = true;

                              controller.timerController!.pause();

                              SpeedStudyProgressController().showFailedDialog(
                                isSuccess: false,
                                action: () {
                                  SpeedStudyProgressController()
                                      .manageSpeedEnhancementLevels();

                                  completeQuiz();
                                },
                              );

                              return;
                            }

                            totalQuestionsAnswered++;
                            calAvgScore();

                            pageController.nextPage(
                                duration: Duration(milliseconds: 1),
                                curve: Curves.ease);

                            // await Future.delayed(Duration(seconds: 1));
                            // nextButton();

                            if (!controller.lastQuestion) {
                              controller.enabled = true;

                              controller.currentQuestion++;

                              if (controller.type ==
                                      StudyType.SPEED_ENHANCEMENT &&
                                  controller.enabled) {
                                print(controller.duration);
                                setState(() {
                                  ((controller) as SpeedController)
                                      .resetTimer();
                                });

                                // print(Provid)

                                print(controller.duration);
                                print("restart");
                              }
                            } else {
                              controller.reviewMode = true;
                              controller.currentQuestion = 0;

                              if (controller.type ==
                                  StudyType.SPEED_ENHANCEMENT) {
                                SpeedStudyProgressController().showFailedDialog(
                                  isSuccess: true,
                                  action: () {
                                    completeQuiz();
                                    showComplete = true;
                                    showNext = false;
                                    controller.enabled = false;
                                    controller.timerController!.pause();
                                  },
                                );
                              } else {
                                completeQuiz();
                              }
                            }
                            // controller.timerController!.reset();
                            setState(() {});
                          },
                        )
                    ],
                  ),
                ),
              ),
              Container(
                child: IntrinsicHeight(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (showPreviousButton())
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: kAccessmentButtonColor,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  pageController.previousPage(
                                      duration: Duration(milliseconds: 1),
                                      curve: Curves.ease);
                                  setState(() {
                                    controller.currentQuestion--;
                                  });
                                },
                                child: Text(
                                  "Previous",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (showSubmitButton())
                          VerticalDivider(width: 2, color: Colors.white),
                        if (showSubmitButton())
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: kAccessmentButtonColor,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    showSubmit = false;
                                    showNext = true;

                                    if (answeredWrong) {
                                      wrong++;
                                      wasWrong = true;
                                    } else {
                                      correctAnswered++;
                                      wasWrong = false;
                                    }

                                    calAvgScore();

                                    if (controller.type == StudyType.REVISION ||
                                        controller.type ==
                                            StudyType.SPEED_ENHANCEMENT) {
                                      controller.enabled = false;
                                    }

                                    if (!controller.savedTest &&
                                            controller.currentQuestion ==
                                                controller.questions.length -
                                                    1 ||
                                        (controller.enabled &&
                                            controller.type ==
                                                StudyType.SPEED_ENHANCEMENT &&
                                            controller.currentQuestion ==
                                                controller.finalQuestion)) {
                                      showComplete = true;
                                      showNext = false;
                                    }

                                    if (answeredWrong &&
                                        controller.type == StudyType.REVISION) {
                                      showNext = true;
                                      showComplete = false;
                                    }

                                    if (controller.type == StudyType.REVISION &&
                                        controller.currentQuestion ==
                                            controller.questions.length - 1) {
                                      showNext = false;
                                      showComplete = true;
                                    }

                                    if (answeredWrong &&
                                        controller.type ==
                                            StudyType.SPEED_ENHANCEMENT) {
                                      SpeedStudyProgressController()
                                          .manageSpeedEnhancementLevels();

                                      showComplete = true;
                                      showNext = false;
                                    }
                                  });
                                },
                                child: Text(
                                  "Submit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (showNextButton())
                          VerticalDivider(width: 2, color: Colors.white),
                        if (showNextButton())
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: kAccessmentButtonColor,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: nextButton,
                                child: Text(
                                  "Next",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 21,
                                  ),
                                ),
                                // style: ButtonStyle(
                                //     backgroundColor: MaterialStateProperty.all(
                                //         Color(0xFFF6F6F6))),
                              ),
                            ),
                          ),
                        if (showCompleteButton())
                          VerticalDivider(width: 2, color: Colors.white),
                        if (showCompleteButton())
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: kAccessmentButtonColor,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  completeQuiz();
                                },
                                child: Text(
                                  "Complete",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 21,
                                  ),
                                ),
                                // style: ButtonStyle(
                                //   backgroundColor: MaterialStateProperty.all(
                                //     Color(0xFFF6F6F6),
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                        if (showResultButton())
                          VerticalDivider(width: 2, color: Colors.white),
                        if (showResultButton())
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: kAccessmentButtonColor,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  viewResults();
                                },
                                child: Text(
                                  "Result",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 21,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ]),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Function()? wrongAnswerAction() {
    if (controller.type == StudyType.REVISION) {
      return () {
        return notesButton();
      };
    } else if (controller.type == StudyType.SPEED_ENHANCEMENT) {
      return () {
        return endSpeedSession();
      };
    } else {
      return () {};
    }
  }

  String getWrongAnswerText() {
    if (controller.type == StudyType.REVISION) {
      return "Study Notes";
    } else if (controller.type == StudyType.SPEED_ENHANCEMENT) {
      return "Start Over";
    }

    return "Any Action";
  }

  Widget getTimerWidget() {
    return GestureDetector(
      onTap: () {
        if (!controller.enabled) {
          return;
        }
        controller.pauseTimer();

        showPauseDialog();
      },
      child: controller.enabled
          ? Row(
              children: [
                // Image(image: AssetImage('assets/images/watch.png')),
                SizedBox(
                  width: 2,
                ),
                // Container(
                //   padding: EdgeInsets.all(4),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(5),
                //       border: Border.all(
                //         color: Color(0xFF969696),
                //         width: 1,
                //       )),
                //   child:
                AdeoTimer(
                  callbackWidget: (time) {
                    print(time);
                    print("reset timer ${controller.duration}");
                    Duration remaining = Duration(seconds: time.toInt());
                    controller.duration = remaining;
                    controller.countdownInSeconds = remaining.inSeconds;

                    if (remaining.inSeconds == 0) {
                      return Text("Time Up",
                          style: TextStyle(
                              color: Color(0xFF969696), fontSize: 14));
                    }

                    return Text(
                        "${remaining.inHours.remainder(24)}:${remaining.inMinutes.remainder(60)}:${remaining.inSeconds.remainder(60)}",
                        style:
                            TextStyle(color: Color(0xFF969696), fontSize: 14));
                  },
                  onFinish: () {
                    Future.delayed(Duration.zero, () async {
                      endSpeedSession();
                    });
                  },
                  controller: controller.timerController!,
                  startDuration: controller.duration!,
                ),

                // ),
              ],
            )
          : Text("Time Up",
              style: TextStyle(color: Color(0xFF969696), fontSize: 18)),
    );
  }

  bool showPreviousButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        if (controller.reviewMode && controller.currentQuestion > 0)
          return true;
        break;
      case StudyType.COURSE_COMPLETION:
        if (controller.reviewMode && controller.currentQuestion > 0)
          return true;
        // if (controller.currentQuestion > 0) return true;
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        if (controller.reviewMode && controller.currentQuestion > 0)
          return true;
        break;
      case StudyType.NONE:
        break;
    }
    return false;
  }

  bool showSubmitButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        return false;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        return false;
      case StudyType.NONE:
        break;
    }
    return showSubmit;
  }

  bool showNextButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        // return controller.currentQuestion < controller.questions.length - 1;
        break;
      case StudyType.SPEED_ENHANCEMENT:
        return false;
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    print("show Next= $showNext");
    return showNext || (controller.reviewMode && !controller.lastQuestion);
  }

  bool showCompleteButton() {
    if (controller.reviewMode) return false;

    switch (controller.type) {
      case StudyType.REVISION:
        if (controller.reviewMode) return false;
        break;
      case StudyType.COURSE_COMPLETION:
        if (!controller.enabled) return false;
        // return controller.lastQuestion;
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    return showComplete;
  }

  bool showResultButton() {
    switch (controller.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        break;
      case StudyType.SPEED_ENHANCEMENT:
        false;
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }

    return controller.savedTest;
  }

  Future<bool> showExitDialog() async {
    bool canExit = true;
    await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Exit?",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to close this quiz?',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Button(
                label: "Yes",
                onPressed: () {
                  canExit = true;
                  Navigator.popUntil(
                      context, ModalRoute.withName(LearnMode.routeName));
                },
              ),
              Button(
                label: "No",
                onPressed: () {
                  canExit = false;
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
    return Future.value(canExit);
  }

  Future<bool> showPauseDialog() async {
    return (await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return PauseDialog(
                backgroundColor: Colors.grey,
                backgroundColor2: Colors.black12,
                time: 0,
                callback: (action) {
                  Navigator.pop(context);
                  if (action == "resume") {
                    // startTimer();
                    controller.timerController!.resume();
                  } else if (action == "quit") {
                    Navigator.popUntil(
                        context, ModalRoute.withName(LearnMode.routeName));
                  }
                },
              );
            })) ??
        false;
  }
}

class PauseDialog extends StatefulWidget {
  PauseDialog(
      {Key? key,
      required this.time,
      required this.callback,
      required this.backgroundColor,
      required this.backgroundColor2})
      : super(key: key);
  int time;
  Function(String action) callback;
  Color backgroundColor, backgroundColor2;

  @override
  _PauseDialogState createState() => _PauseDialogState();
}

class _PauseDialogState extends State<PauseDialog> {
  String action = "";
  int min = 0;
  int sec = 0;
  @override
  void initState() {
    min = (widget.time / 60).floor();
    sec = widget.time % 60;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("event type ${controller.}");
    return Scaffold(
      body: Center(
        child: Container(
          width: 380,
          height: 560,
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.backgroundColor2,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Time Remaining ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              decoration: TextDecoration.none)),
                      Text("$min:$sec",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              decoration: TextDecoration.none))
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectText("resume", action == "resume",
                        color: Colors.black,
                        selectedColor: Colors.black,
                        normalSize: 27,
                        selectedSize: 45, select: () {
                      setState(() {
                        action = "resume";
                      });
                    }),
                    SelectText("quit", action == "quit",
                        color: Colors.black,
                        selectedColor: Colors.black,
                        normalSize: 27,
                        selectedSize: 45, select: () {
                      setState(() {
                        action = "quit";
                      });
                    }),
                  ],
                ),
              )),
              SizedBox(
                height: 70,
                child: Container(
                    decoration: BoxDecoration(
                        color: widget.backgroundColor2,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20))),
                    child: Center(
                        child: TextButton(
                      onPressed: () {
                        if (action == "") {
                          return;
                        }
                        widget.callback(action);
                      },
                      child: Text("proceed",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              decoration: TextDecoration.none)),
                    ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyQuestionWidget extends StatefulWidget {
  StudyQuestionWidget(this.user, this.question,
      {Key? key,
      this.position,
      this.useTex = false,
      this.enabled = true,
      required this.type,
      this.callback})
      : super(key: key);

  final User user;
  final Question question;
  int? position;
  bool enabled;
  bool useTex;
  StudyType type;
  Function(Answer selectedAnswer, bool correct)? callback;

  @override
  _StudyQuestionWidgetState createState() => _StudyQuestionWidgetState();
}

class _StudyQuestionWidgetState extends State<StudyQuestionWidget> {
  Color textColor = Color(0xFFBABABA);
  Color textColor2 = Color(0xFFACACAC);
  Color textColor3 = Color(0xFFC3CCDE);
  Color textColor4 = Color(0xFFA2A2A2);

  late List<Answer>? answers;
  Answer? selectedAnswer;
  Answer? correctAnswer;

  @override
  void initState() {
    if (!widget.enabled) {
      // widget.isAnswered = true;
    }

    answers = widget.question.answers;
    if (answers != null) {
      answers!.forEach((answer) {
        if (answer.value == 1) {
          correctAnswer = answer;
        }
      });
    }

    selectedAnswer = widget.question.selectedAnswer;
    print(widget.question.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
          child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              // padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              color: Color(0xFFF6F6F6),
              constraints: BoxConstraints(minHeight: 135),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //**************
                  // question
                  //*************
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      textColor: Colors.white,
                      iconColor: kAdeoGray3,
                      initiallyExpanded: true,
                      collapsedIconColor: kAdeoGray3,
                      backgroundColor: Color(0xFFEFEFEF),
                      title: Text(
                        'View Question',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: kAdeoGray3,
                        ),
                      ),
                      children: <Widget>[
                        ActualQuestion(
                          user: widget.user,
                          question: widget.question.text!,
                          // diagnostic: widget.diagnostic,
                          direction: "",
                        ),
                      ],
                    ),
                  ),

                  // choose answer
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    width: appWidth(context),
                    decoration: BoxDecoration(
                      color: const Color(0xFF67717D),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFC8C8C8),
                      ),
                    ),
                    child: Text(
                      "Choose the right answer to the question above",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),

                  //*********
                  // resoucres
                  //*******
                  if (widget.question.resource != null &&
                      widget.question.resource != "")
                    GestureDetector(
                      onTap: () {
                        print("object");
                      },
                      child: Visibility(
                        visible:
                            widget.question.resource!.isNotEmpty ? true : false,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            textColor: Colors.white,
                            iconColor: kAdeoGray3,
                            initiallyExpanded: true,
                            collapsedBackgroundColor: Colors.white,
                            collapsedIconColor: kAdeoGray3,
                            backgroundColor: Colors.white,
                            title: Text(
                              'Resource',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: kAdeoGray3,
                              ),
                            ),
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: AdeoHtmlTex(
                                      widget.user,
                                      widget.question.resource!
                                          .replaceAll("https", "http"),
                                      // removeTags: controller.questions[i].resource!.contains("src") ? false : true,
                                      useLocalImage: false,
                                      textColor: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            //
            Card(
                elevation: 0,
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: AdeoHtmlTex(
                  widget.user,
                  widget.question.instructions!.replaceAll("https", "http"),
                  // removeTags: controller.questions[i].instructions!.contains("src") ? false : true,
                  useLocalImage: false,
                  fontWeight: FontWeight.normal,
                  textColor: Colors.black,
                )),

            if (!widget.enabled &&
                selectedAnswer != null &&
                correctAnswer != null &&
                correctAnswer!.solution != null &&
                correctAnswer!.solution != "")
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Container(
                        color: Color(0xFFF6F6F6),
                        child: Center(
                          child: Text(
                            "Solution",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    if (selectedAnswer != null &&
                        correctAnswer != null &&
                        correctAnswer!.solution != null &&
                        correctAnswer!.solution != "")
                      Container(
                        color: Color(0xFFF6F6F6),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
                            child: AdeoHtmlTex(
                              widget.user,
                              correctAnswer != null
                                  ? correctAnswer!.solution!
                                  : "----",
                              textColor: Colors.black,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            // ***********
            // answers
            // ***********
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  for (int i = 0; i < answers!.length; i++)
                    newSelectedAnswer(answers![i], Color(0xFF00C664), (
                      answerSelected,
                    ) {
                      widget.callback!(
                          answerSelected, answerSelected == correctAnswer);
                    }),
                  // newSelectedAnswer(answers![i])
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget selectAnswerWidget(Answer answer, Color selectedColor,
      Function(Answer selectedAnswer)? callback) {
    return SizedBox(
      width: getWidgetSize(answer).width,
      child: Stack(children: [
        TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(
                    color: getOutlineColor(
                      answer,
                      selectedColor,
                    ),
                  ),
                ),
              ),
              minimumSize: MaterialStateProperty.all(getWidgetSize(answer)),
              backgroundColor: MaterialStateProperty.all(
                getBackgroundColor(answer, selectedColor),
              ),
              foregroundColor: MaterialStateProperty.all(
                  getBackgroundColor(answer, selectedColor))),
          onPressed: () {
            if (!widget.enabled) {
              return;
            }
            setState(() {
              selectedAnswer = widget.question.selectedAnswer = answer;
              callback!(answer);
            });
          },
          child: AdeoHtmlTex(
            widget.user,
            answer.text!,
            textColor: getForegroundColor(answer),
            fontSize: selectedAnswer == answer ? 25 : 20,
          ),
        ),
        getAnswerMarker(answer)
      ]),
    );
  }

  Size getWidgetSize(Answer answer) {
    switch (widget.type) {
      case StudyType.REVISION:
        break;
      case StudyType.COURSE_COMPLETION:
        break;
      case StudyType.SPEED_ENHANCEMENT:
        break;
      case StudyType.MASTERY_IMPROVEMENT:
        break;
      case StudyType.NONE:
        break;
    }
    if (widget.enabled) {
      if (selectedAnswer == answer) {
        return Size(310, 102);
      }
    } else {
      if (selectedAnswer == answer && answer == correctAnswer) {
        return Size(310, 102);
      } else if (answer == correctAnswer) {
        return Size(267, 88);
      }
    }
    return Size(267, 88);
  }

  Color getOutlineColor(Answer answer, Color selectedColor) {
    if (widget.enabled && selectedAnswer == answer) {
      return selectedColor;
    } else if (!widget.enabled && answer == correctAnswer) {
      return selectedColor;
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Color(0xFFFB7B76);
    }
    return Color(0xFFFAFAFA);
  }

  Color getBackgroundColor(Answer answer, Color selectedColor) {
    if (!widget.enabled && answer == correctAnswer) {
      return Color(0xFFFAFAFA);
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Color(0xFFFB7B76);
    }
    return Color(0xFFFAFAFA);
  }

  Positioned getAnswerMarker(Answer answer) {
    if (!widget.enabled && answer == correctAnswer) {
      return Positioned(
          left: 5,
          bottom: 5,
          child: Image(
            image: AssetImage('assets/images/correct.png'),
          ));
    } else if (!widget.enabled && answer == selectedAnswer) {
      return Positioned(
          left: 5,
          bottom: 5,
          child: Image(
            image: AssetImage('assets/images/wrong.png'),
          ));
    }
    return Positioned(child: Container());
  }

  Color getForegroundColor(Answer answer) {
    if (widget.enabled && selectedAnswer == answer) {
      return Colors.black;
    } else if (!widget.enabled && answer == correctAnswer) {
      return Colors.black;
    } else if (selectedAnswer == answer ||
        !widget.enabled && correctAnswer == answer) {
      return Colors.white;
    }
    return Color(0xFFBAC4D9);
  }

  Widget newSelectedAnswer(Answer answer, Color selectedColor,
      Function(Answer selectedAnswer)? callback) {
    return GestureDetector(
      onTap: () {
        if (!widget.enabled) {
          return;
        }
        setState(() {
          selectedAnswer = widget.question.selectedAnswer = answer;

          callback!(answer);
        });
      },
      child: getAnswerStatus(answer),
    );
  }

  getAnswerStatus(Answer answer) {
    if (selectedAnswer == answer && widget.enabled) {
      return newSelectedAnswerWidget(answer, widget.user);
    }
    if (!widget.enabled && answer == correctAnswer) {
      return missedAnswer(answer, widget.user);
    }
    if (!widget.enabled &&
        answer != correctAnswer &&
        answer == selectedAnswer) {
      return wrongAnswer(answer, widget.user);
    } else {
      return newAnswerWidget(answer, widget.user);
    }
  }
}
