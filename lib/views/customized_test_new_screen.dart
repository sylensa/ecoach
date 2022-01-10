import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomizedTestScreen extends StatefulWidget {
  CustomizedTestScreen({Key? key}) : super(key: key);

  @override
  State<CustomizedTestScreen> createState() => _CustomizedTestScreenState();
}

class _CustomizedTestScreenState extends State<CustomizedTestScreen> {
  int selectedObjective = 0;
  Color themeColor = kAdeoTaupe;

  void handleObjectiveSelection(id) {
    setState(() {
      selectedObjective = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3E50),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: themeColor,
              height: 53,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularPercentIndicator(
                    radius: 25,
                    lineWidth: 3,
                    progressColor: Color(0xFF222E3B),
                    backgroundColor: Colors.transparent,
                    percent: .3,
                    center: Text(
                      "${3}",
                      style: TextStyle(fontSize: 14, color: Color(0xFF222E3B)),
                    ),
                  ),
                  Row(
                    children: [
                      Image(image: AssetImage('assets/images/watch.png')),
                      SizedBox(width: 4),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFF222E3B),
                            width: 1,
                          ),
                        ),
                        child: CustomTimer(
                          onBuildAction: CustomTimerAction.auto_start,

                          builder: (CustomTimerRemainingTime remaining) {
                            return Text(
                              "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                              style: TextStyle(
                                color: Color(0xFF222E3B),
                                fontSize: 14,
                              ),
                            );
                          },
                          // controller: controller.timerController,
                          from: Duration(minutes: 40),
                          to: Duration(seconds: 0),
                          onStart: () {},
                          onPaused: () {},
                          onReset: () {
                            print("onReset");
                          },
                          onFinish: () {
                            print("finished");
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Question(question: 'Which of the following is a rabbit?'),
                    Instruction(
                      instruction: 'Choose the right answer for the question',
                    ),
                    DetailedInstruction(
                      details:
                          'Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius',
                    ),
                    Container(
                      width: double.infinity,
                      height: 10,
                      color: themeColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          Objective(
                            themeColor: themeColor,
                            id: 1,
                            label: 'Sokoto',
                            isSelected: selectedObjective == 1,
                            onTap: handleObjectiveSelection,
                          ),
                          Objective(
                            themeColor: themeColor,
                            id: 2,
                            label: 'Harlequin tryanoposoiom',
                            isSelected: selectedObjective == 2,
                            onTap: handleObjectiveSelection,
                          ),
                          Objective(
                            themeColor: themeColor,
                            id: 3,
                            label: 'White leghorn',
                            isSelected: selectedObjective == 3,
                            onTap: handleObjectiveSelection,
                          ),
                          Objective(
                            themeColor: themeColor,
                            id: 4,
                            label: 'Rhode Island red',
                            isSelected: selectedObjective == 4,
                            onTap: handleObjectiveSelection,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
