import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/treadmill/quiz_questions.dart';
import 'package:ecoach/views/treadmill/quiz_questions_copy.dart';
import 'package:ecoach/views/treadmill/treadmill_quiz_view.dart';
import 'package:flutter/material.dart';

import '../../database/topics_db.dart';
import '../../models/question.dart';
import '../../models/topic.dart';
import '../../widgets/widgets.dart';

class InstructionPage extends StatefulWidget {
  InstructionPage({
    required this.controller,
    this.topicId,
    this.bankId,
    required this.mode,
    this.bankName,
  });
  final TreadmillController controller;
  final int? topicId;
  final int? bankId;
  final String? bankName;
  final TreadmillMode mode;

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  late dynamic topicId;
  List<Question> questions = [];

  gTime() {
    if (mounted) {
      setState(() {
        widget.controller.m1 = widget.controller.min_1 ?? "0";
        widget.controller.m2 = (widget.controller.min_2 ?? "0");
        widget.controller.s1 = widget.controller.sec_1 ?? "0";
        widget.controller.s2 = widget.controller.sec_2 ?? "0";
        widget.controller.minutes =
            widget.controller.m1! + widget.controller.m2!;
        widget.controller.seconds =
            widget.controller.s1! + widget.controller.s2!;
        widget.controller.countdown_min =
            int.parse(widget.controller.minutes!) * 60;
        widget.controller.countdown_sec = int.parse(widget.controller.seconds!);
        widget.controller.countdown += (widget.controller.countdown_min! +
                widget.controller.countdown_sec!) *
            128;
        print(
            'mim: ${widget.controller.minutes}, ${widget.controller.countdown_min}');
        print(
            'mim: ${widget.controller.seconds}, ${widget.controller.countdown_sec}');
        print('countdown: ${widget.controller.countdown}');
      });
    }
  }

  @override
  void initState() {
    gTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3E50),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 16.0),
        child: InkWell(
          onTap: () async {
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
                await widget.controller.createBankTreadmill(widget.bankId!);
                widget.controller.name = widget.bankName;
                break;
            }

            widget.controller.time = widget.controller.timePerQuestion;

            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return QuizQuestionCopy(controller: widget.controller);
              }),
            );
            //getQ();
            //Get.to(() => const QuizQuestion());
          },
          child: Container(
            child: const Center(
              child: Text(
                'Start',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            height: 70,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3E50),
              border: Border.all(
                color: const Color(0xFFFFFFFF),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/deep_pool_light_teal.png',
            color: const Color(0xFF00C9B9),
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 150, 0, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Instructions',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 45.0),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '1. When the time on a questions runs out,\n it moves you to the next question',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '2. You cannot go back to a previous question.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '3. Once you choose an answer option, it can\'t \n be changed, you move automatically \n to the next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '4. You can\'t pause the test, \n but you can end it',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
