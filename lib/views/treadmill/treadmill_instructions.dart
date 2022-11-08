import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/treadmill/treadmill_quiz_view.dart';
import 'package:flutter/material.dart';

import '../../database/topics_db.dart';
import '../../models/question.dart';
import '../../models/topic.dart';
import '../../utils/style_sheet.dart';
import '../../widgets/adeo_outlined_button.dart';
import '../../widgets/widgets.dart';

class InstructionPage extends StatefulWidget {
  InstructionPage({
    required this.controller,
    this.topicId,
    this.bankId,
    this.count,
    required this.mode,
    this.bankName,
  });
  final TreadmillController controller;
  final int? topicId;
  final int? bankId;
  final int? count;
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
      setState(() {});
    }
  }

  @override
  void initState() {
    gTime();
    super.initState();
    print(widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3E50),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 16.0),
        child: AdeoOutlinedButton(
          label: 'Start',
          fontSize: 29,
          fontWeight: FontWeight.normal,
          borderColor: kAdeoLightTeal,
          color: Colors.white,
          size: Sizes.small,
          onPressed: () async {
            showLoaderDialog(context, message: "Creating Treadmill Run");
            print(widget.mode);
            switch (widget.mode) {
              case TreadmillMode.MOCK:
                await widget.controller.createTreadmill();
                break;
              case TreadmillMode.TOPIC:
                await widget.controller.createTopicTreadmill(widget.topicId!);

                Topic? topic = await TopicDB().getTopicById(widget.topicId!);
                widget.controller.name = topic!.name;
                widget.controller.topicid = widget.topicId!;
                break;
              case TreadmillMode.BANK:
                // await TestController().getQuizQuestions(widget.topicId!);
                await widget.controller
                    .createBankTreadmill(widget.topicId!, widget.count!);

                //widget.controller.name = topic!.name;
                break;
            }

            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return TreadmillQuizView(controller: widget.controller);
              }),
            );
          },
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
