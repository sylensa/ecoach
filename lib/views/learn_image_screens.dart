import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/views/learn_mode.dart';
import 'package:ecoach/views/learn_revision.dart';
import 'package:ecoach/widgets/layouts/learn_peripheral_layout.dart';
import 'package:flutter/material.dart';

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
            heroImageURL: 'assets/images/revision_module/module_completed.png',
            mainActionLabel: 'Next topic',
            mainActionColor: Color(0xFFFB7B76),
            mainActionOnPressed: () async {
              int nextLevel = studyController.nextLevel;
              Topic? topic = await TopicDB()
                  .getLevelTopic(studyController.course.id!, nextLevel);
              if (topic != null) {
                print("${topic.name}");
                StudyProgress progress = StudyProgress(
                    id: topic.id,
                    studyId: studyController.progress.studyId!,
                    level: nextLevel,
                    topicId: topic.id,
                    name: topic.name,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now());
                await StudyDB().insertProgress(progress);

                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return LearnRevision(
                      studyController.user, studyController.course, progress);
                }), (route) => false);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("No more topics")));
              }
            },
            topActionLabel: 'exit',
            topActionColor: Color(0xFFFB7B76),
            topActionOnPressed: () {},
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
              }), (route) => false);
            },
            topActionLabel: 'return',
            topActionOnPressed: () {},
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
