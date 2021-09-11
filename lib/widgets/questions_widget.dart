import 'package:ecoach/models/question.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionWidget extends StatefulWidget {
  QuestionWidget(this.question, {Key? key, this.position, this.enabled = true})
      : super(key: key);
  Question question;
  int? position;
  bool enabled;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late List<Answer>? answers;
  Answer? selectedAnswer;
  @override
  void initState() {
    answers = widget.question.answers;
    selectedAnswer = widget.question.selectedAnswer;
    print(widget.question.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Html(data: "${widget.question.text ?? ''}", style: {
                    // tables will have the below background color
                    "body": Style(
                      color: Colors.white,
                      fontSize: FontSize(20),
                    ),
                  }),
                ),
              ),
            ),
            Container(),
            Container(
              child: Column(
                children: [
                  for (int i = 0; i < answers!.length; i++)
                    selectHtml(answers![i].text!.replaceFirst("<br>", ""),
                        widget.question.selectedAnswer == answers![i],
                        normalSize: 20, selectedSize: 22, select: () {
                      if (!widget.enabled) {
                        return;
                      }
                      setState(() {
                        widget.question.selectedAnswer = answers![i];
                      });
                    })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
