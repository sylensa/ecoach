import 'package:ecoach/controllers/autopilot_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/autopilot.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/AutopilotTopicSelector.dart';
import 'package:ecoach/views/autopilot_quiz_view.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

enum topics { TOPIC, MOCK }

class AutopilotTopicMenu extends StatefulWidget {
  AutopilotTopicMenu({this.topics = const [], required this.controller});
  AutopilotController controller;
  List<TestNameAndCount> topics;

  @override
  State<AutopilotTopicMenu> createState() => _AutopilotTopicMenuState();
}

class _AutopilotTopicMenuState extends State<AutopilotTopicMenu> {
  late dynamic topicId;
  late AutopilotController controller;

  String? name;
  int isSelected = 0;

  @override
  void initState() {
    super.initState();
    topicId = widget.topics[isSelected].id;
    controller = widget.controller;
    controller.name = widget.topics[isSelected].name;
    //controller.autopilot = topicId;
    print("name from topic_menu ${controller.name}");
    //controller.loadAutopilot();
    //print("name from topic_menu ${controller.name}");
  }

  handleNext() async {
    print('topic id is ${topicId}');
    await controller.createTopicAutopilot(topicId);
    Topic? topic = await TopicDB().getTopicById(topicId);
    controller.name = topic!.name!;

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AutopilotQuizView(controller: controller);
    }));
  }

//no need to handle on top since Autopilot
  handletopicSelection(newTopic) {
    setState(() {
      if (topicId == newTopic)
        topicId = '';
      else
        topicId = newTopic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Center(
                  child: Text(
                    '${widget.controller.topics.length}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: kAdeoBlue2,
                      fontFamily: 'HelveticaRoundedLTStd-Bd',
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "topics remaining",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Divider(
              height: 50,
              thickness: 5,
              endIndent: 0,
              color: Colors.white,
            ),
            SizedBox(height: 33),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.topics.length; i++)
                        /*  MultiPurposeCourseCard(
                          title: widget.controller.topics[i].name,
                          subTitle: "here is a subtitle",
                        ), */

                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Card(
                            elevation: 0,
                            child: Row(
                              children: [
                                if (isSelected == i)
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Image.asset(
                                          'assets/icons/courses/auto.png'),
                                      iconSize: 36,
                                      onPressed: null,
                                    ),
                                  ),
                                Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    title: Text(
                                        "${widget.controller.topics[i].name}"),
                                    subtitle: Text("here is a subtitle"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
