import 'dart:developer';

import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/treadmill/treadmill_quiz_view.dart';
import 'package:ecoach/views/treadmill/treadmill_quiz_view_old.dart';
import 'package:ecoach/widgets/adeo_duration_input.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TreadmillTimeAndInstruction extends StatefulWidget {
  TreadmillTimeAndInstruction({
    required this.controller,
    required this.mode,
    this.topicId,
    this.bankId,
    this.bankName,
  });

  final TreadmillController controller;
  final int? topicId;
  final int? bankId;
  final String? bankName;
  final TreadmillMode mode;

  @override
  State<TreadmillTimeAndInstruction> createState() =>
      _TreadmillTimeAndInstructionState();
}

class _TreadmillTimeAndInstructionState
    extends State<TreadmillTimeAndInstruction> {
  late FocusNode focusNode, focusNode2;
  Duration? duration;
  int timePerQuestion = 0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode2 = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TestIntroitLayout(
      key: UniqueKey(),
      background: kAdeoRoyalBlue,
      backgroundImageURL: 'assets/images/deep_pool_light_teal.png',
      pages: [
        TestIntroitLayoutPage(
          title: 'Time',
          subText: 'Allocation per question',
          foregroundColor: Colors.white,
          middlePiece: Column(
            children: [
              SizedBox(height: 60),
              AdeoDurationInput(onDurationChange: (d) {
                setState(() {
                  duration = d;
                });
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    alignment: Alignment.center,
                    child: Text(
                      'minutes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  Container(
                    width: 120,
                    alignment: Alignment.center,
                    child: Text(
                      'seconds',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdeoOutlinedButton(
                label: 'let\'s go',
                color: Colors.white,
                borderColor: kAdeoLightTeal,
                fontSize: 22,
                onPressed: () {
                  if (duration != null ) {
                    if(duration!.inSeconds > 1){
                      setState(() {
                        timePerQuestion = duration!.inSeconds;
                        TestIntroitLayout.goForward();
                      });
                    }else{
                      showFeedback(
                        context,
                        'Enter a valid duration',
                      );
                    }

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
        getInstructionsLayout(() async {
          showLoaderDialog(context, message: "Creating Treadmill Run");

          switch (widget.mode) {
            case TreadmillMode.MOCK:
              await widget.controller.createTreadmill();
              break;
            case TreadmillMode.TOPIC:
              await widget.controller.createTopicTreadmill(widget.topicId!);
              Topic? topic = await TopicDB().getTopicById(widget.topicId!);
              widget.controller.name = topic!.name!;
              break;
            case TreadmillMode.BANK:
              //  await widget.controller.createBankTreadmill(widget.bankId!);
              widget.controller.name = widget.bankName;
              break;
          }

          widget.controller.time = timePerQuestion;

          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return TreadmillQuizView(
                controller: widget.controller,
              );
            }),
          );
        }),
      ],
    );
  }
}

TestIntroitLayoutPage getInstructionsLayout(Function onPressed) {
  return TestIntroitLayoutPage(
    foregroundColor: Colors.white,
    fontWeight: FontWeight.w700,
    title: 'Instructions',
    middlePiece: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SizedBox(height: 7),
          Text(
            '1. When the time on a question runs out, it moves to the next question',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoWhiteAlpha50,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '2. You cannot go back to a previous question',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoWhiteAlpha50,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '3. Once you choose an answer option, it can\'t be changed, you move autotically to the next ',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoWhiteAlpha50,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7),
          Text(
            '4. You can\'t pause the test, \nbut you can end it',
            style: kCustomizedTestSubtextStyle.copyWith(
              color: kAdeoWhiteAlpha50,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    footer: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AdeoOutlinedButton(
          color: Colors.white,
          borderColor: kAdeoLightTeal,
          label: 'Start',
          onPressed: onPressed,
          fontSize: 22,
        )
      ],
    ),
  );
}
