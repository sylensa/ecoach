import 'package:ecoach/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class QuestionWidget extends StatefulWidget {
  QuestionWidget(this.question, {Key? key, this.position}) : super(key: key);
  Question question;
  int? position;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  void initState() {
    print(widget.position);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 12,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Html(data: "${widget.question.text ?? ''}", style: {
                  // tables will have the below background color
                  "p": Style(
                    color: Colors.white,
                    fontSize: FontSize(20),
                  ),
                }),
              ),
            ),
          ),
          Container(),
          Container()
        ],
      ),
    );
  }
}
