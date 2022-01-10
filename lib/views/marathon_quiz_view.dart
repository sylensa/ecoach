import 'package:custom_timer/custom_timer.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/marathon_complete_congratulation.dart';
import 'package:ecoach/views/marathon_ended.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MarathonQuizView extends StatefulWidget {
  MarathonQuizView({Key? key}) : super(key: key);

  @override
  State<MarathonQuizView> createState() => _MarathonQuizViewState();
}

class _MarathonQuizViewState extends State<MarathonQuizView> {
  int selectedObjective = 0;
  Color themeColor = kAdeoBlue;

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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 31, right: 4.0),
                      child: Text(
                        'life cycle of flowering plants',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kAdeoBlueAccent,
                          fontSize: 14,
                          fontFamily: 'Hamelin',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Image(image: AssetImage('assets/images/watch.png')),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: Feedback.wrapForTap(() {
                          showPopup(
                            context,
                            PauseMenuDialog(themeColor: themeColor),
                          );
                        }, context),
                        child: Container(
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
            QuizStats(
              averageScore: '65.05%',
              speed: '40s',
              correctScore: '254',
              wrongScrore: '2',
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

Future<bool> showPopup(BuildContext context, Widget dialog) async {
  return (await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return dialog;
        },
      )) ??
      false;
}

class PauseMenuDialog extends StatefulWidget {
  const PauseMenuDialog({Key? key, required this.themeColor}) : super(key: key);

  final Color themeColor;

  @override
  _PauseMenuDialogState createState() => _PauseMenuDialogState();
}

class _PauseMenuDialogState extends State<PauseMenuDialog> {
  int selected = -1;

  handleSelection(id) {
    setState(() {
      selected = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 53),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                color: kAdeoRoyalBlue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Objective(
                        id: 5,
                        label: 'submit & save',
                        themeColor: widget.themeColor,
                        isSelected: selected == 5,
                        onTap: handleSelection,
                      ),
                      Objective(
                        id: 6,
                        label: 'submit & end',
                        themeColor: widget.themeColor,
                        isSelected: selected == 6,
                        onTap: handleSelection,
                      ),
                      Objective(
                        id: 7,
                        label: 'submit & pause',
                        themeColor: widget.themeColor,
                        isSelected: selected == 7,
                        onTap: handleSelection,
                      ),
                      Objective(
                        id: 8,
                        label: 'resume',
                        themeColor: widget.themeColor,
                        isSelected: selected == 8,
                        onTap: handleSelection,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selected > -1)
              Container(
                child: AdeoTextButton(
                  label: 'Submit',
                  onPressed: () {
                    switch (selected) {
                      case 5:
                        showPopup(context, SessionSavedPrompt());
                        break;
                      case 6:
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return MarathonEnded();
                        }));
                        break;
                      case 7:
                        showPopup(context, TestPausedPrompt());
                        break;
                      case 8:
                        Navigator.pop(context);
                        break;
                    }
                  },
                  background: kAdeoBlue,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class SessionSavedPrompt extends StatelessWidget {
  const SessionSavedPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Session Saved',
                style: TextStyle(
                  fontSize: 52,
                  fontFamily: 'Hamelin',
                  color: kAdeoBlue,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'Continue whenever\nyou are ready',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 64),
              AdeoOutlinedButton(
                label: 'Exit',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return MarathonCompleteCongratulations();
                  }));
                },
                size: Sizes.large,
                color: Color(0xFFFF4949),
                borderRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestPausedPrompt extends StatelessWidget {
  const TestPausedPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Test Paused',
                style: TextStyle(
                  fontSize: 52,
                  fontFamily: 'Hamelin',
                  color: kAdeoBlue,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'Continue whenever\nyou are ready',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kAdeoBlueAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 64),
              AdeoOutlinedButton(
                label: 'Resume',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return MarathonQuizView();
                  }));
                },
                size: Sizes.large,
                color: kAdeoBlue,
                borderRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
