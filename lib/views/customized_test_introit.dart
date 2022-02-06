import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/customized_test_question_mode.dart';
import 'package:ecoach/views/customized_test_quiz_mode.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:flutter/material.dart';

class CustomizedTestIntroit extends StatefulWidget {
  const CustomizedTestIntroit({
    required this.user,
    required this.course,
    Key? key,
  }) : super(key: key);

  final User user;
  final Course course;

  @override
  State<CustomizedTestIntroit> createState() => _CustomizedTestIntroitState();
}

class _CustomizedTestIntroitState extends State<CustomizedTestIntroit> {
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
      backgroundColor: kAdeoTaupe,
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
                        fontSize: 40,
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
                    ),
                    SizedBox(height: 35),
                    CustomizeModeSelector(
                      label: 'Question',
                      isSelected: mode.toUpperCase() == 'QUESTION',
                      onTap: handleModeSelection,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                AdeoOutlinedButton(
                  label: 'Next',
                  onPressed: () {
                    if (mode.toUpperCase() == 'QUIZ')
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CustomizedTestQuizMode(
                              widget.user,
                              widget.course,
                            );
                          },
                        ),
                      );
                    else if (mode.toUpperCase() == 'QUESTION')
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CustomizedTestQuestionMode(
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

class CustomizeModeSelector extends StatelessWidget {
  const CustomizeModeSelector({
    required this.label,
    required this.isSelected,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String label;
  final bool isSelected;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() {
        onTap(label);
      }, context),
      child: AnimatedContainer(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                )
              : Border(),
        ),
        duration: Duration(milliseconds: 50),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kDefaultBlack,
            fontSize: isSelected ? 60 : 35,
          ),
        ),
      ),
    );
  }
}
