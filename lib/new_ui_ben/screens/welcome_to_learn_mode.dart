import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/new_ui_ben/providers/speed_enhancement_provider.dart';
import 'package:ecoach/new_ui_ben/screens/speed_improvement/speed_completion.dart';
import 'package:ecoach/widgets/layouts/speed_enhancement_introit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../models/topic.dart';
import '../providers/welcome_screen_provider.dart';
import '../widgets/learn_card.dart';
import 'course_completion/course_completion.dart';
import 'mastery/mastery_improvement_rules.dart';
import 'revision/revision.dart';

class WelcomeToLearnMode extends StatefulWidget {
  final Course course;
  final Function(StudyType) startLearning;
  const WelcomeToLearnMode(
      {required this.startLearning, required this.course, Key? key})
      : super(key: key);

  @override
  State<WelcomeToLearnMode> createState() => _WelcomeToLearnModeState();
}

class _WelcomeToLearnModeState extends State<WelcomeToLearnMode> {
  Future<List<Topic>> getTopic() async {
    return await TopicDB().courseTopics(widget.course);
    // return topics;
  }

  int revisionLevel = 1;

  getStudyProgress() async {
    // Provider.of<WelcomeScreenProvider>(context, listen: false).setCCRemaining();
    RevisionStudyProgress? revisionStudyProgress =
        await StudyDB().getCurrentRevisionProgressByCourse(widget.course.id!);

    // print("course progress: ${revisionStudyProgress!.toMap()}");
    if (revisionStudyProgress != null) {
      print("course progress: ${revisionStudyProgress.toMap()}");
      setState(() {
        revisionLevel = revisionStudyProgress.level!;
      });
    } else {
      print("revision is null");
      setState(() {
        revisionLevel = 1;
      });
    }

    Provider.of<WelcomeScreenProvider>(context, listen: false)
        .setCurrentRevisionProgressLevel(revisionLevel);
  }

  @override
  void initState() {
    super.initState();
    getStudyProgress();
    print("this is the course ${widget.course.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    // getStudyProgress();
    // Provider.of<SpeedEnhancementProvider>(context, listen: false).level;
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Welcome to Learn Mode',
          style: TextStyle(
              fontFamily: 'Cocon', fontWeight: FontWeight.w700, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Consumer<WelcomeScreenProvider>(
            builder: (_, welcome, __) {
              // welcome.setRevisionRemaining();
              // welcome.setCCRemaining();
              // Provider.of<WelcomeScreenProvider>(context, listen: false).setRevisionRemaining();
              return Column(
                children: [
                  const Text(
                    "What's your goal for today?",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(255, 255, 255, 0.5)),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  LearnCard(
                    title: 'Revision',
                    desc:
                        'Do a quick revision for an upcoming exam',
                    value: welcome.currentRevisionStudyProgress != null
                        ? (((welcome.currentRevisionStudyProgress!.level! - 1)) / welcome.totalTopics) * 100
                        : (((revisionLevel - 1)) / welcome.totalTopics) * 100,
                    icon: 'assets/images/learn_mode2/stopwatch.png',
                    onTap: () async {
                      widget.startLearning(StudyType.REVISION);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LearnCard(
                    title: 'Course Completion',
                    desc: 'Do a quick revision for an upcoming exam',
                    value: welcome.progress != null
                        ? (((welcome.totalTopics - welcome.totalCC)) /
                                welcome.totalTopics) *
                            100
                        : 0,
                    icon: 'assets/images/learn_mode2/books.png',
                    onTap: () {
                      // Get.to(() => const CourseCompletion());
                      widget.startLearning(StudyType.COURSE_COMPLETION);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LearnCard(
                    title: 'Mastery Improvement',
                    desc: 'Do a quick revision for an upcoming exam',
                    value: 0,
                    icon: 'assets/images/learn_mode2/target.png',
                    onTap: () {
                      // Get.to(() => const MasteryImprovementRules());
                      widget.startLearning(StudyType.MASTERY_IMPROVEMENT);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LearnCard(
                    title: 'Speed Enhancement',
                    desc: 'Do a quick revision for an upcoming exam',
                    isLevel: true,
                    value: welcome.progress != null
                        ? welcome.progress!.level!.toDouble()
                        : 0,
                    icon: 'assets/images/learn_mode2/speedometer.png',
                    onTap: () {
                      // Get.to(() => const SpeedCompletion());
                      widget.startLearning(StudyType.SPEED_ENHANCEMENT);
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
