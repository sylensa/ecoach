import 'package:accordion/accordion.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tex/flutter_tex.dart';

class QuestionWidget extends StatefulWidget {
  QuestionWidget(
    this.user,
    this.question, {
    Key? key,
    this.position,
    this.enabled = true,
    this.currentStage = 'QUESTION',
  }) : super(key: key);

  User user;
  Question question;
  int? position;
  bool enabled;

  String currentStage;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late List<Answer>? answers;
  Color? backgroundColor;
  // List<bool> expand = [];

  @override
  void initState() {
    backgroundColor = const Color(0xFF5DA5EA);
    answers = widget.question.answers;
    answers!.forEach((answer) {
      // expand.add(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.currentStage.toUpperCase() == 'QUESTION')
              Column(
                children: [
                  if (widget.question.text != null &&
                      widget.question.text != '' &&
                      widget.question.text!.isNotEmpty)
                    SubSectionNonAccordionView(
                      user: widget.user,
                      content: widget.question.text!,
                    ),
                  if (widget.question.instructions != null &&
                      widget.question.instructions!.isNotEmpty)
                    SubSectionNonAccordionView(
                      user: widget.user,
                      content: widget.question.instructions!,
                    ),
                  for (int i = 0; i < answers!.length; i++)
                    SubSectionNonAccordionView(
                      user: widget.user,
                      content: answers![i].text!,
                    )
                ],
              ),
            if (widget.currentStage.toUpperCase() == 'ANSWER')
              Column(
                children: [
                  Accordion(
                    disableScrolling: true,
                    headerPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    headerBackgroundColor: Color(0xFF444444),
                    headerBorderRadius: 0,
                    paddingListHorizontal: 0,
                    paddingListTop: 0,
                    paddingListBottom: 0,
                    contentBackgroundColor: Color(0xFF595959),
                    contentHorizontalPadding: 0,
                    children: [
                      if (widget.question.text != null &&
                          widget.question.text != '' &&
                          widget.question.text!.isNotEmpty)
                        SubQuestionAccordionSection(
                          user: widget.user,
                          heading: 'Preamble',
                          content: widget.question.text!,
                          isSolution: false,
                        ),
                      if (widget.question.instructions != null &&
                          widget.question.instructions!.isNotEmpty)
                        SubQuestionAccordionSection(
                          user: widget.user,
                          heading: 'Instructions',
                          content: widget.question.instructions!,
                          isSolution: true,
                        ),
                    ],
                  ),
                  Accordion(
                    disableScrolling: true,
                    headerPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    headerBackgroundColor: Color(0xFF444444),
                    headerBorderRadius: 0,
                    paddingListHorizontal: 0,
                    paddingListTop: 0,
                    contentBackgroundColor: Color(0xFF595959),
                    contentHorizontalPadding: 0,
                    children: [
                      for (int i = 0; i < answers!.length; i++)
                        SubQuestionAccordionSection(
                          user: widget.user,
                          heading: answers![i].text!,
                          content: answers![i].solution!,
                          isSolution: true,
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

AccordionSection SubQuestionAccordionSection({
  required User user,
  required String heading,
  required String content,
  bool? isSolution,
  bool? useTex,
  bool isOpen = false,
}) {
  return AccordionSection(
    isOpen: isOpen,
    contentBorderWidth: 0,
    contentBorderColor: Color(0xFF595959),
    contentBorderRadius: 0,
    contentHorizontalPadding: 0,
    header: AdeoHtmlTex(
      user,
      heading,
      fontSize: 18,
    ),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isSolution == true)
          Column(
            children: [
              Container(
                height: 33,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 3,
                      color: Color(0xFF444444),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Solution',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13),
            ],
          ),
        AdeoHtmlTex(
          user,
          content,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ],
    ),
  );
}

Widget SubSectionNonAccordionView({
  required User user,
  required String content,
  bool useTex = false,
}) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: Color(0xFF444444),
        child: AdeoHtmlTex(
          user,
          content,
          fontSize: 18,
        ),
      ),
      SizedBox(height: 12),
    ],
  );
}
