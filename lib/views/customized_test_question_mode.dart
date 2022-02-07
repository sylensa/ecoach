import 'package:ecoach/controllers/customized_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/customized_test_new_screen.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/buttons/adeo_outlined_button.dart';
import 'package:ecoach/widgets/customize_input_field.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomizedTestQuestionMode extends StatefulWidget {
  const CustomizedTestQuestionMode(this.user, this.course, {Key? key})
      : super(key: key);
  final User user;
  final Course course;

  @override
  State<CustomizedTestQuestionMode> createState() =>
      _CustomizedTestQuestionModeState();
}

class _CustomizedTestQuestionModeState
    extends State<CustomizedTestQuestionMode> {
  int duration = 0;
  int numberOfQuestion = 0;

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      background: kAdeoTaupe,
      backgroundImageURL: 'assets/images/deep_pool_taupe.png',
      pages: [
        TestIntroitLayoutPage(
          title: 'Questions',
          subText: 'Enter your preferred number',
          middlePiece: Column(
            children: [
              SizedBox(height: 20),
              CustomizeInputField(
                  number: numberOfQuestion,
                  onChange: (number) {
                    numberOfQuestion = number;
                  }),
            ],
          ),
          footer: AdeoOutlinedButton(
            label: 'Next',
            onPressed: TestIntroitLayout.goForward,
          ),
        ),
        TestIntroitLayoutPage(
          title: 'Time',
          subText: 'Allocation per question',
          middlePiece: Column(
            children: [
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.0,
                    child: PinInput(
                      autoFocus: true,
                      length: 2,
                      onChanged: (v) {
                        setState(() {
                          duration = int.parse(v);
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                label: 'Previous',
                onPressed: TestIntroitLayout.goBack,
              ),
              SizedBox(width: 8.0),
              AdeoOutlinedButton(
                label: 'Next',
                onPressed: TestIntroitLayout.goForward,
              )
            ],
          ),
        ),
        getInstructionsPage(context),
      ],
    );
  }

  TestIntroitLayoutPage getInstructionsPage(BuildContext context) {
    return TestIntroitLayoutPage(
      title: 'Instructions',
      middlePiece: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            SizedBox(height: 11),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '1.',
                  style: kCustomizedTestSubtextStyle,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'When the time on a question runs out, it moves to the next question',
                    style: kCustomizedTestSubtextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '2.',
                  style: kCustomizedTestSubtextStyle,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'You cannot jump or skip a question ',
                    style: kCustomizedTestSubtextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '3.',
                  style: kCustomizedTestSubtextStyle,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Once you choose an answer option it can\'t be changed, you move automatically to the next',
                    style: kCustomizedTestSubtextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdeoOutlinedButton(
            label: 'Previous',
            onPressed: TestIntroitLayout.goBack,
          ),
          SizedBox(width: 8.0),
          AdeoOutlinedButton(
            label: 'Start',
            onPressed: () async {
              showLoaderDialog(context, message: "loading questions");

              List<Question> questions = await TestController()
                  .getCustomizedQuestions(widget.course, numberOfQuestion);
              Navigator.pop(context);
              if (questions.length == 0) {
                AdeoDialog(
                  title: "No Questions",
                  content: "There are no questions for this course",
                  actions: [
                    AdeoDialogAction(
                        label: "Ok",
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CustomizedTestScreen(
                        controller: CustomizedController(
                      widget.user,
                      widget.course,
                      questions: questions,
                      name: "Customized Test",
                      time: duration,
                    ));
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
