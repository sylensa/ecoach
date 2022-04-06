import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/database/autopilot_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/autopilot_selector_service.dart';

import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot_quiz_view.dart';
import 'package:ecoach/widgets/autopilot_topic_selector.dart';

import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:ecoach/widgets/widgets.dart';

import 'package:flutter/material.dart';

enum topics { TOPIC, MOCK }

class AutopilotTopicMenu extends StatefulWidget {
  AutopilotTopicMenu({required this.controller});
  AutopilotController controller;

  @override
  State<AutopilotTopicMenu> createState() => _AutopilotTopicMenuState();
}

class _AutopilotTopicMenuState extends State<AutopilotTopicMenu> {
  late int topicId;
  late AutopilotController controller;
  List<int> topicIds = [];
  AutopilotSelectorService _selectorService = AutopilotSelectorService();

  String? name;
  late int isSelected;
  late bool showInPercentage;

  List<AutopilotTopic> autopilots = [];
  List completedAutopilots = [];
  late AutopilotTopic currentAutoTopic;

  @override
  void initState() {
    super.initState();

    showInPercentage = false;
    isSelected = _selectorService.selectedTopic;
    controller = widget.controller;

    currentAutoTopic = controller.currentTopic!;
    topicId = currentAutoTopic.topicId!;
    isSelected = controller.currentTopicNumber;

    print('this value is from selectorService ${isSelected}');
    print('controller topics list is: ${widget.controller.topics}');

    print('topicId is : ${topicId}');
    //controller.autopilot = topicId;
    print("name from topic_menu ${controller.name}");
    //controller.loadAutopilot();
    //print("name from topic_menu ${controller.name}");
    print('isSelected = ${isSelected}');
    print('the total correct is: ${controller.getTotalCorrect()}');
  }

  handleNext() async {
    print('new value o f isSlected is ${isSelected}');
    showLoaderDialog(context, message: "Creating Autopilot questions");
    await controller.createTopicQuestions(currentAutoTopic);
    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AutopilotQuizView(controller: controller);
    }));
  }

//no need to handle on top since Autopilot

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 35,
                ),
                child: Center(
                  child: Text(
                    // TODO:
                    '${widget.controller.topics.length - isSelected}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: kAdeoBlue2,
                      fontFamily: 'Helvetica Rounded',
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "topics remaining",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.5),
                fontFamily: 'Poppins',
              ),
            ),
            Divider(
              height: 50,
              thickness: 5,
              endIndent: 0,
              color: Colors.white,
            ),
            SizedBox(height: 17),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        PercentageSwitch(
                          showInPercentage: showInPercentage,
                          onChanged: (val) {
                            setState(() {
                              showInPercentage = val;
                            });
                          },
                        ),
                        SizedBox(height: 15),
                        for (int i = 0; i < controller.topics.length; i++)
                          AutopilotTopicSelector(
                              showInPercentage: showInPercentage,
                              topicId: controller.autoTopics[i].topicId!,
                              label: controller.autoTopics[i].topicName!,
                              isSelected:
                                  topicId == controller.autoTopics[i].topicId!,
                              isUnselected: topicId != '' &&
                                  topicId != controller.autoTopics[i].topicId!,
                              numberOfQuestions:
                                  controller.autoTopics[i].totalQuestions!,
                              correctlyAnswered:
                                  controller.autoTopics[i].correct!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
      bottomSheet: AdeoTextButton(
        label: "Start",
        onPressed: handleNext,
        color: Colors.white,
        background: kAdeoOrange2,
      ),
    );
  }
}
