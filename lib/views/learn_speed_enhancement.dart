import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn_speed_enhancement_questions_placeholder.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_gray_outlined_button.dart';
import 'package:ecoach/widgets/layouts/speed_enhancement_introit.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:another_xlider/another_xlider.dart';

class LearnSpeed extends StatefulWidget {
  const LearnSpeed(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnSpeedState createState() => _LearnSpeedState();
}

class _LearnSpeedState extends State<LearnSpeed> {
  final CarouselController controller = CarouselController();
  int currentSliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        items: [
          SpeedEnhancementIntroit(
            heroText: 'Speed Enhancement',
            subText:
                'Let\'s help you improve your speed,\none question at a time.',
            heroImageURL: 'assets/images/learn_module/speed_enhancement_1.png',
            stage: 1,
            mainActionOnPressed: () {
              controller.nextPage();
            },
          ),
          SecondComponent(controller: controller),
          SpeedEnhancementIntroit(
            heroText: 'Speed Test',
            subText:
                'If you answer 10 questions correctly , you move to the next level\nif you fail 3 questions consecutive questions,\nyou go back to the previous level.\nFor every wrong answer, the test restarts.',
            heroImageURL: 'assets/images/learn_module/speed_enhancement_3.png',
            stage: 3,
            mainActionOnPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LearnSpeedEnhancementQuestionsPlaceholder();
              }));
            },
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
          },
        ),
      ),
    );
  }
}

class SecondComponent extends StatelessWidget {
  const SecondComponent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 12.0,
            bottom: 24.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 32.0,
                lineWidth: 4.0,
                percent: 2 / 3,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      2.toString(),
                      style: TextStyle(
                        color: kAdeoCoral,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                progressColor: kAdeoCoral,
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.transparent,
              ),
              AdeoGrayOutlinedButton(
                label: 'return',
                onPressed: () {},
                size: Sizes.small,
              ),
            ],
          ),
        ),
        Text(
          'Available Levels',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kAdeoCoral,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: 24.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 100.0,
                          height: 550.0,
                          // color: Colors.red.shade100,
                          child: FlutterSlider(
                            values: [10, 15, 30, 60, 90, 120],
                            max: 120,
                            min: 10,
                            fixedValues: [
                              FlutterSliderFixedValue(
                                percent: 5,
                                value: '10sec',
                              ),
                              FlutterSliderFixedValue(
                                percent: 22,
                                value: '15sec',
                              ),
                              FlutterSliderFixedValue(
                                percent: 40,
                                value: '30sec',
                              ),
                              FlutterSliderFixedValue(
                                percent: 58,
                                value: '60sec',
                              ),
                              FlutterSliderFixedValue(
                                percent: 76,
                                value: '90sec',
                              ),
                              FlutterSliderFixedValue(
                                percent: 96,
                                value: '120sec',
                              ),
                            ],
                            axis: Axis.vertical,
                            jump: true,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          LevelDescriptor(
                            duration: '10 sec',
                            imageURL: 'assets/images/learn_module/falcon.png',
                          ),
                          LevelDescriptor(
                            duration: '15 sec',
                            imageURL: 'assets/images/learn_module/eagle.png',
                          ),
                          LevelDescriptor(
                            duration: '30 sec',
                            imageURL: 'assets/images/learn_module/cheetah.png',
                          ),
                          LevelDescriptor(
                            duration: '60 sec',
                            imageURL: 'assets/images/learn_module/antelope.png',
                          ),
                          LevelDescriptor(
                            duration: '90 sec',
                            imageURL: 'assets/images/learn_module/fowl.png',
                          ),
                          LevelDescriptor(
                            duration: '120 sec',
                            imageURL: 'assets/images/learn_module/tortoise.png',
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 32.0),
                  AdeoOutlinedButton(
                    label: 'Proceed',
                    onPressed: () {
                      controller.nextPage();
                    },
                    color: kAdeoCoral,
                    borderRadius: 0,
                  ),
                  SizedBox(height: 48.0),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class LevelDescriptor extends StatelessWidget {
  const LevelDescriptor({
    required this.duration,
    required this.imageURL,
  });

  final String duration;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 16.0),
          Text(
            duration,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
              fontStyle: FontStyle.italic,
              color: kAdeoGray2,
            ),
          ),
          SizedBox(width: 16.0),
          Container(
            width: 140.0,
            height: 80.0,
            child: Image.asset(
              imageURL,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}
