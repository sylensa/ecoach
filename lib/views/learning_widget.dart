import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/layouts/learn_peripheral_layout.dart';
import 'package:flutter/material.dart';

class LearningWidget extends StatefulWidget {
  const LearningWidget(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearningWidgetState createState() => _LearningWidgetState();
}

class _LearningWidgetState extends State<LearningWidget> {
  final CarouselController controller = CarouselController();
  int currentSliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CarouselSlider(
        items: [
          LearnPeripheralWidget(
            heroText: 'Great Job',
            subText: 'Matter\ncompleted',
            heroImageURL: 'assets/images/revision_module/module_completed.png',
            mainActionLabel: 'Next topic',
            mainActionColor: Color(0xFFFB7B76),
            mainActionOnPressed: () {
              controller.nextPage();
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
              controller.nextPage();
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
            onPageChanged: (index, reason) {
              setState(() {
                currentSliderIndex = index;
              });
            }),
      ),
    );
  }
}
