import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/speed/speed_topic_menu.dart';
import 'package:ecoach/views/marathon/marathon_practise_mock.dart';
import 'package:ecoach/views/marathon/marathon_practise_topic_menu.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/marathon_mode_selector.dart';
import 'package:ecoach/widgets/speed_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Modes { TOPIC, MOCK }

class SpeedQuizMenu extends StatefulWidget {
  SpeedQuizMenu({
    Key? key,
    required this.controller,
    this.time,
  }) : super(key: key);

  final MarathonController controller;
  int? time;

  @override
  State<SpeedQuizMenu> createState() => _SpeedQuizMenuState();
}

class _SpeedQuizMenuState extends State<SpeedQuizMenu> {
  late dynamic mode;
  late MarathonController controller;

  @override
  void initState() {
    mode = '';
    controller = widget.controller;
    super.initState();
  }

  handleModeSelection(newMode) {
    setState(() {
      if (mode == newMode)
        mode = '';
      else
        mode = newMode;
    });
  }

  handleNext() async {
    dynamic screenToNavigateTo;

    switch (mode) {
      case Modes.TOPIC:
        List<TestNameAndCount> topics =
            await TestController().getTopics(controller.course);
        screenToNavigateTo =
            SpeedTopicMenu(topics: topics, controller: controller);
        break;
      case Modes.MOCK:
        int count =
            await QuestionDB().getTotalQuestionCount(controller.course.id!);
        screenToNavigateTo =
            MarathonPractiseMock(count: count, controller: controller);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return screenToNavigateTo;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoOrangeH,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 70),
                      Text(
                        'Choose Test Option',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kDefaultBlack,
                          fontSize: 33.sp,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Choose your preferred option',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kDefaultBlack,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 65),
                      SpeedModeSelector(
                        label: 'Topic',
                        textcolor: Colors.white,
                        mode: Modes.TOPIC,
                        isSelected: mode == Modes.TOPIC,
                        isUnselected: mode != '' && mode != Modes.TOPIC,
                        onTap: handleModeSelection,
                      ),
                      SizedBox(height: 35),
                      SpeedModeSelector(
                        label: 'Mock',
                        textcolor: Colors.white,
                        mode: Modes.MOCK,
                        isSelected: mode == Modes.MOCK,
                        isUnselected: mode != '' && mode != Modes.MOCK,
                        onTap: handleModeSelection,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (mode != '')
              Column(
                children: [
                  AdeoFilledButton(
                    label: 'Next',
                    onPressed: handleNext,
                    background: Colors.black26,
                    size: Sizes.large,
                  ),
                  SizedBox(height: 53),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
