import 'package:ecoach/new_ui_ben/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/study_mastery_controller.dart';
import '../../../controllers/test_controller.dart';
import '../../../database/mastery_course_db.dart';
import '../../../database/study_db.dart';
import '../../../database/topics_db.dart';
import '../../../models/mastery_course.dart';
import '../../../models/study.dart';
import '../../../models/test_taken.dart';
import '../../../models/topic.dart';
import '../../../models/topic_analysis.dart';
import '../../../views/learn/learn_attention_topics.dart';
import '../../../views/learn/learn_mode.dart';
import '../../providers/welcome_screen_provider.dart';
import '../../widgets/green_pill_button.dart';
import '../../widgets/highlighted_topic.dart';
import '../../widgets/highlighted_topics_container.dart';

class MasteryImprovementTopics extends StatefulWidget {
  MasteryImprovementTopics({
    Key? key,
    required this.test,
    required this.controller,
  }) : super(key: key);

  TestTaken test;
  MasteryController controller;

  @override
  State<MasteryImprovementTopics> createState() =>
      _MasteryImprovementTopicsState();
}

class _MasteryImprovementTopicsState extends State<MasteryImprovementTopics> {
  List<TopicAnalysis> topics = [];
  List<TopicAnalysis> topicsSubList1 = [];
  List<TopicAnalysis> topicsSubList2 = [];
  List<Topic> topicsToRevise = [];
  late MasteryController controller;
  bool isSorted = false;

  sortTopicsByPercentage() {
    print(isSorted);
    if (!isSorted) {
      topics.sort((a, b) => a.performace.compareTo(b.performace));
      isSorted = !isSorted;

      setState(() {});
    } else {
      topics.sort((a, b) => b.performace.compareTo(a.performace));
      isSorted = !isSorted;
      setState(() {});
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    print("test id = ${widget.test.id}");
    TestController().topicsAnalysis(widget.test).then((mapList) async {
      Iterable<String> keys = mapList.keys;
      for (int i = 0; i < keys.length; i++) {
        List<TestAnswer> answers = mapList[keys.elementAt(i)]!;
        TopicAnalysis analysis = TopicAnalysis(keys.elementAt(i), answers);
        analysis.topic = await TopicDB().getTopicById(answers[0].topicId!);
        topics.add(analysis);
        print("----------------------------------");
        print("add topic ${analysis.name}");
      }

      topicsSubList1 = topics.sublist(0, (topics.length / 2).floor());
      topicsSubList2 = topics.sublist((topics.length / 2).floor());

      topics.forEach((topic) {
        if (topic.correct < 3 && topic.topic != null) {
          topicsToRevise.add(topic.topic!);
        }
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Mastery Improvement',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 28, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Spot weaknesses and improve upon them",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.5)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  sortTopicsByPercentage();
                                },
                                icon: Image.asset(
                                  'assets/images/learn_mode2/up-and-down-arrow.png',
                                  height: 21,
                                  width: 21,
                                )),
                            const Text(
                              'Topic',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const Expanded(
                                child: SizedBox(
                              width: 10,
                            )),
                            const Text(
                              'Strength',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        HighlightedTopicsContainer(
                          topics: [
                            ...List.generate(topics.length, (index) {
                              return HighlightedTopic(
                                barsWidget: Image.asset(
                                    getBarPercentage(topics[index].performace)),
                                number:
                                    (index + 1).toString(),
                                topic: topics[index].name,
                              );
                            }),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'You have to improve your mastery in ',
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Poppins'),
                              children: [
                                TextSpan(
                                    text: '${topicsToRevise.length} Topics',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700))
                              ]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 30,
              right: 30,
              child: Align(
                alignment: Alignment.center,
                child: GreenPillButton(
                    onTap: () async {
                      List<Topic> topicsToRevise = [];
                      topics.forEach((topic) {
                        if (topic.correct < 3 && topic.topic != null) {
                          topicsToRevise.add(topic.topic!);
                        }
                      });

                      if (topicsToRevise.length > 0) {
                        print("Adding new progress");
                        print(
                            "revise topics length = ${topicsToRevise.length}");
                        StudyProgress progress = StudyProgress(
                            studyId: controller.progress.studyId!,
                            level: 2,
                            section: 1,
                            topicId: topicsToRevise[0].id,
                            name: topicsToRevise[0].name,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now());
                        await StudyDB().insertProgress(progress);

                        for (int i = 0; i < topicsToRevise.length; i++) {
                          print("saving mastery ....");
                          MasteryCourseUpgrade mastery = MasteryCourseUpgrade(
                            level: progress.level,
                            passed: false,
                            courseId: Provider.of<WelcomeScreenProvider>(
                                    context,
                                    listen: false)
                                .currentCourse!
                                .id,
                            studyId: progress.studyId,
                            topicId: topicsToRevise[i].id,
                            topicName: topicsToRevise[i].name,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          await MasteryCourseDB().insertMasteryCourseUpgrade(
                            mastery,
                          );
                          print("mastery study ${mastery.toJson()}");
                          await MasteryCourseDB().insert(
                            MasteryCourse(
                              level: progress.level,
                              passed: false,
                              studyId: progress.studyId,
                              topicId: topicsToRevise[i].id,
                              topicName: topicsToRevise[i].name,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                          );
                        }

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return LearnAttentionTopics(
                              controller: MasteryController(
                                  controller.user, controller.course,
                                  name: controller.name, progress: progress),
                              topics: topicsToRevise,
                            );
                          },
                        ), ModalRoute.withName(LearnMode.routeName));
                      } else {}
                    },
                    text: 'Start Mastery Run'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
