import 'package:ecoach/controllers/marathon_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/customized_test/speed_quiz_menu.dart';
import 'package:ecoach/views/customized_test/speed_test_question_mode.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:flutter/material.dart';

class SpeedTestIntro extends StatefulWidget {
  const SpeedTestIntro({
    required this.user,
    required this.course,
    Key? key,
  }) : super(key: key);

  final User user;
  final Course course;

  @override
  State<SpeedTestIntro> createState() => _SpeedTestIntroState();
}

class _SpeedTestIntroState extends State<SpeedTestIntro> {
  late String mode;

  @override
  void initState() {
    mode = 'QUIZ';
    super.initState();
  }

  handleModeSelection(newMode) {
    setState(() {
      mode = newMode.toUpperCase();
    });
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
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    Text(
                      'Select your mode',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kDefaultBlack,
                        fontSize: 41,
                        fontFamily: 'Hamelin',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Choose your preferred timing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kDefaultBlack,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 65),
                    CustomizeModeSelector(
                      label: 'Quiz',
                      isSelected: mode.toUpperCase() == 'QUIZ',
                      onTap: handleModeSelection,
                      textcolor: Colors.white,
                    ),
                    SizedBox(height: 35),
                    CustomizeModeSelector(
                      label: 'Question',
                      isSelected: mode.toUpperCase() == 'QUESTION',
                      onTap: handleModeSelection,
                      textcolor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                AdeoOutlinedButton(
                  label: 'Next',
                  backcolor: Colors.red,
                  onPressed: () {
                    if (mode.toUpperCase() == 'QUIZ')
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SpeedQuizMenu(
                              controller: MarathonController(
                                  widget.user, widget.course,
                                  name: widget.course.name!),
                            );
                          },
                        ),
                      );
                    else if (mode.toUpperCase() == 'QUESTION')
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SpeedTestQuestionMode(
                              widget.user,
                              widget.course,
                            );
                          },
                        ),
                      );
                  },
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
