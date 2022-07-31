import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/customize_input_field.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomizedTestQuizMode extends StatefulWidget {
  const CustomizedTestQuizMode(this.user, this.course, {Key? key})
      : super(key: key);
  final User user;
  final Course course;

  @override
  _CustomizedTestQuizModeState createState() => _CustomizedTestQuizModeState();
}

class _CustomizedTestQuizModeState extends State<CustomizedTestQuizMode> {
  int numberOfQuestions = 0;
  String durationLeft = '';
  String durationRight = '';
  String duration = '';
  late FocusNode focusNode, focusNode2, numberFocus;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode2 = FocusNode();
    numberFocus = FocusNode();
    numberFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: kAdeoTaupe),
      body: TestIntroitLayout(
        background: kAdeoTaupe,
        backgroundImageURL: 'assets/images/deep_pool_taupe.png',
        pages: [
          TestIntroitLayoutPage(
            title: 'Questions',
            subText: 'Enter your preferred number',
            middlePiece: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Container(
                  width: 180.0,
                  child: CustomizeInputField(
                      number: numberOfQuestions,
                      numberFocus: numberFocus,
                      onChange: (number) {
                        print("number of question = $number");
                        numberOfQuestions = number;
                      }),
                ),
              ],
            ),
            footer: AdeoOutlinedButton(
              label: 'Next',
              onPressed: () {
                if (numberOfQuestions > 0) {
                  focusNode.requestFocus();
                  TestIntroitLayout.goForward();
                } else
                  showFeedback(
                    context,
                    'Enter the number of questions you want to answer',
                  );
              },
            ),
          ),
          TestIntroitLayoutPage(
            title: 'Time',
            subText: 'Enter your preferred number',
            middlePiece: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120.0,
                      child: PinInput(
                        length: 2,
                        focusNode: focusNode,
                        onChanged: (v) {
                          setState(() {
                            durationLeft = v.split('').join('');
                            if (durationLeft.length > 1) {
                              focusNode2.requestFocus();
                            }
                          });
                        },
                      ),
                    ),
                    Text(':', style: kPinInputTextStyle),
                    Container(
                      width: 120.0,
                      child: PinInput(
                        autoFocus: durationLeft.length == 2,
                        focusNode: focusNode2,
                        length: 2,
                        onChanged: (v) {
                          setState(() {
                            durationRight = v.split('').join('');
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
                  onPressed: () {
                    setState(() {
                      focusNode = FocusNode();
                      focusNode2 = FocusNode();
                    });
                    numberFocus.requestFocus();
                    TestIntroitLayout.goBack();
                  },
                ),
                SizedBox(width: 8.0),
                AdeoOutlinedButton(
                  label: 'let\'s go',
                  onPressed: () async {
                    if (durationRight.length > 0) {
                      showLoaderDialog(context, message: "loading questions");

                      List<Question> questions = await TestController()
                          .getCustomizedQuestions(
                              widget.course, numberOfQuestions);
                      int min = int.parse(durationLeft);
                      int sec = int.parse(durationRight);
                      int time = (min * 60) + sec;

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return QuizCover(
                              widget.user,
                              questions,
                              course: widget.course,
                              type: TestType.CUSTOMIZED,
                              theme: QuizTheme.BLUE,
                              time: time,
                              name: "Customized Quiz Test",
                            );
                          },
                        ),
                      );
                    } else
                      showFeedback(
                        context,
                        'Enter a valid duration',
                      );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
