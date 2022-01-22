import 'package:accordion/accordion.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tex/flutter_tex.dart';

class QuestionWidget extends StatefulWidget {
  QuestionWidget(
    this.question, {
    Key? key,
    this.position,
    this.useTex = false,
    this.enabled = true,
    this.currentStage = 'QUESTION',
  }) : super(key: key);

  Question question;
  int? position;
  bool enabled;
  bool useTex;
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
                      content: widget.question.text!,
                      useTex: widget.useTex,
                    ),
                  if (widget.question.instructions != null &&
                      widget.question.instructions!.isNotEmpty)
                    SubSectionNonAccordionView(
                      content: widget.question.instructions!,
                      useTex: widget.useTex,
                    ),
                  for (int i = 0; i < answers!.length; i++)
                    SubSectionNonAccordionView(
                      content: answers![i].text!,
                      useTex: widget.useTex,
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
                          heading: 'Preamble',
                          content: widget.question.text!,
                          isSolution: false,
                          useTex: widget.useTex,
                        ),
                      if (widget.question.instructions != null &&
                          widget.question.instructions!.isNotEmpty)
                        SubQuestionAccordionSection(
                          heading: 'Instructions',
                          content: widget.question.instructions!,
                          isSolution: true,
                          useTex: widget.useTex,
                        ),
                    ],
                  ),
                  // if ((widget.question.text != null &&
                  //         widget.question.text != '' &&
                  //         widget.question.text!.isNotEmpty) ||
                  //     (widget.question.instructions != null &&
                  //         widget.question.instructions!.isNotEmpty))
                  //   Column(
                  //     children: [
                  //       Container(height: 3, color: kAdeoGreen),
                  //       SizedBox(height: 12),
                  //     ],
                  //   ),
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
                          heading: answers![i].text!,
                          content: answers![i].solution!,
                          isSolution: true,
                          useTex: widget.useTex,
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
    header: !useTex!
        ? Html(data: heading, style: {
            "body": Style(
              backgroundColor: Color(0xFF444444),
              color: Colors.white,
              fontSize: FontSize(18),
            ),
          })
        : TeXView(
            renderingEngine: TeXViewRenderingEngine.katex(),
            child: TeXViewDocument(
              heading,
              style: TeXViewStyle(
                backgroundColor: Color(0xFF444444),
                contentColor: Colors.white,
                fontStyle: TeXViewFontStyle(
                  fontSize: 18,
                ),
              ),
            ),
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
        Html(data: content, style: {
          "body": Style(
            color: Colors.white,
            backgroundColor: Color(0xFF595959),
            fontSize: FontSize(12),
            fontStyle: FontStyle.italic,
            textAlign: TextAlign.justify,
            lineHeight: LineHeight(1.6),
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        }),
      ],
    ),
  );
}

Widget SubSectionNonAccordionView({
  required String content,
  bool useTex = false,
}) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: Color(0xFF444444),
        child: !useTex
            ? Html(data: content, style: {
                "body": Style(
                  backgroundColor: Color(0xFF444444),
                  color: Colors.white,
                  fontSize: FontSize(18),
                ),
              })
            : TeXView(
                renderingEngine: TeXViewRenderingEngine.katex(),
                child: TeXViewDocument(
                  content,
                  style: TeXViewStyle(
                    backgroundColor: Color(0xFF444444),
                    contentColor: Colors.white,
                    fontStyle: TeXViewFontStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
      ),
      SizedBox(height: 12),
    ],
  );
}
