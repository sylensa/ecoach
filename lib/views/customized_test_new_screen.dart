import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomizedTestScreen extends StatefulWidget {
  CustomizedTestScreen({Key? key}) : super(key: key);

  @override
  State<CustomizedTestScreen> createState() => _CustomizedTestScreenState();
}

class _CustomizedTestScreenState extends State<CustomizedTestScreen> {
  int selectedObjective = 0;

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
              color: kAdeoTaupe,
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
                      color: kAdeoTaupe,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          Objective(
                            id: 1,
                            label: 'Sokoto',
                            isSelected: selectedObjective == 1,
                            onTap: handleObjectiveSelection,
                          ),
                          Objective(
                            id: 2,
                            label: 'Harlequin tryanoposoiom',
                            isSelected: selectedObjective == 2,
                            onTap: handleObjectiveSelection,
                          ),
                          Objective(
                            id: 3,
                            label: 'White leghorn',
                            isSelected: selectedObjective == 3,
                            onTap: handleObjectiveSelection,
                          ),
                          Objective(
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

class Objective extends StatelessWidget {
  const Objective({
    required this.id,
    required this.label,
    this.onTap,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  final int id;
  final String label;
  final onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() {
        onTap(id);
      }, context),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 35,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF222E3B) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: isSelected
              ? Border.all(
                  color: kAdeoTaupe,
                  width: 1,
                  style: BorderStyle.solid,
                )
              : Border(),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSelected ? 25 : 20,
            color: isSelected ? Colors.white : Color(0xB3FFFFFF),
          ),
        ),
      ),
    );
  }
}

class DetailedInstruction extends StatelessWidget {
  const DetailedInstruction({
    required this.details,
    Key? key,
  }) : super(key: key);

  final String details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      child: Text(
        details,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class Instruction extends StatelessWidget {
  const Instruction({
    required this.instruction,
    Key? key,
  }) : super(key: key);

  final String instruction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      color: Color(0xFF66717D),
      child: Text(
        instruction,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontFamily: 'Hamelin',
        ),
      ),
    );
  }
}

class Question extends StatelessWidget {
  const Question({
    required this.question,
    Key? key,
  }) : super(key: key);

  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 28,
      ),
      color: Color(0xFF222E3B),
      child: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
