import 'package:ecoach/models/question.dart';
import 'package:ecoach/widgets/select_text.dart';
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
        color: Color(0xFF595959),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFF444444),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Html(data: "${widget.question.text ?? ''}", style: {
                        // tables will have the below background color
                        "body": Style(
                          color: Colors.white,
                          fontSize: FontSize(23),
                        ),
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Color(0xFF00C664),
              child: Padding(
                padding: EdgeInsets.all(4),
              ),
            ),
            if (!widget.enabled)
              Container(
                color: Color(0xFF595959),
              ),
            if (!widget.enabled)
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Container(
                        color: Colors.amber.shade200,
                        child: Center(
                          child: Text(
                            "Solution",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.orange,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
                          child: Text(
                            selectedAnswer != null
                                ? selectedAnswer!.solution!
                                : "----",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Container(
              color: Color(0xFF595959),
              child: Column(
                children: [
                  for (int i = 0; i < answers!.length; i++)
                    SelectHtml(answers![i].text!,
                        widget.question.selectedAnswer == answers![i],
                        normalSize: 15, selectedSize: 48, select: () {
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
