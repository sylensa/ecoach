import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/QuestionCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class QuestionsTabPage extends StatefulWidget {
  const QuestionsTabPage({
    required this.questions,
    required this.diagnostic,
    required this.user,
    Key? key,
  }) : super(key: key);

  final List questions;
  final diagnostic;
  final user;

  @override
  _QuestionsTabPageState createState() => _QuestionsTabPageState();
}

class _QuestionsTabPageState extends State<QuestionsTabPage> {
  List selected = [];
  late int page;
  late PageController controller;
  List tabs = [
    {
      'label': 'All\nQuestions',
      'icon': null,
    },
    {
      'label': 'Correctly\nAnswered',
      'icon': 'assets/icons/courses/answered.png',
    },
    {
      'label': 'Wrongly\nAnswered',
      'icon': 'assets/icons/courses/unanswered.png',
    },
    {
      'label': 'Not\nAttempted',
      'icon': 'assets/icons/courses/not_attempted.png',
    }
  ];
  late List questions;

  List savedQuestions = [2, 4, 3, 5];

  TextStyle tabStyle(bool isActive) {
    return TextStyle(
      fontSize: 10,
      color: isActive ? Colors.black : kAdeoGray2,
      fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
      height: 1.6,
    );
  }

  @override
  void initState() {
    page = 0;
    controller = PageController();
    questions = widget.questions;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 41),
        Container(
          height: 5,
          color: Colors.white,
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: tabs
                      .map(
                        (tab) => Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: tabs.indexOf(tab) == page
                                    ? BorderSide(
                                        color: kAdeoGray2,
                                        width: 2,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  page = tabs.indexOf(tab);
                                  controller.animateToPage(
                                    tabs.indexOf(tab),
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                  );
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (tab['icon'] != null)
                                    Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: Image.asset(
                                            tab['icon'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                      ],
                                    ),
                                  Text(
                                    tab['label'],
                                    textAlign: TextAlign.center,
                                    style: tabStyle(page == tabs.indexOf(tab)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (newPage) {
                    // setState(() {
                    //   page = newPage;
                    // });
                  },
                  children: [
                    QuestionTabView(
                      questions: questions,
                      savedQuestions: savedQuestions,
                      selectedQuestions: selected,
                      onSelected: (question) {
                        if (!selected.contains(question))
                          setState(
                            () {
                              selected = [...selected, question];
                            },
                          );
                        else
                          setState(() {
                            selected =
                                selected.where((q) => q != question).toList();
                          });
                      },
                      onQuestionToggled: (int id, bool isOn) {
                        if (isOn)
                          setState(() {
                            savedQuestions = [...savedQuestions, id];
                          });
                        else
                          setState(() {
                            savedQuestions = savedQuestions
                                .where((qid) => qid != id)
                                .toList();
                          });
                      },
                    ),
                    QuestionTabView(
                      questions: questions
                          .where(
                            (question) =>
                                question['score'] ==
                                ExamScore.CORRECTLY_ANSWERED,
                          )
                          .toList(),
                      savedQuestions: savedQuestions,
                      selectedQuestions: selected,
                      onSelected: (question) {
                        if (!selected.contains(question))
                          setState(
                            () {
                              selected = [...selected, question];
                            },
                          );
                        else
                          setState(() {
                            selected =
                                selected.where((q) => q != question).toList();
                          });
                      },
                      onQuestionToggled: (int id, bool isOn) {
                        if (isOn)
                          setState(() {
                            savedQuestions = [...savedQuestions, id];
                          });
                        else
                          setState(() {
                            savedQuestions = savedQuestions
                                .where((qid) => qid != id)
                                .toList();
                          });
                      },
                    ),
                    QuestionTabView(
                      questions: questions
                          .where(
                            (question) =>
                                question['score'] == ExamScore.WRONGLY_ANSWERED,
                          )
                          .toList(),
                      savedQuestions: savedQuestions,
                      selectedQuestions: selected,
                      onSelected: (question) {
                        if (!selected.contains(question))
                          setState(
                            () {
                              selected = [...selected, question];
                            },
                          );
                        else
                          setState(() {
                            selected =
                                selected.where((q) => q != question).toList();
                          });
                      },
                      onQuestionToggled: (int id, bool isOn) {
                        if (isOn)
                          setState(() {
                            savedQuestions = [...savedQuestions, id];
                          });
                        else
                          setState(() {
                            savedQuestions = savedQuestions
                                .where((qid) => qid != id)
                                .toList();
                          });
                      },
                    ),
                    QuestionTabView(
                      questions: questions
                          .where(
                            (question) =>
                                question['score'] == ExamScore.NOT_ATTEMPTED,
                          )
                          .toList(),
                      savedQuestions: savedQuestions,
                      selectedQuestions: selected,
                      onSelected: (question) {
                        if (!selected.contains(question))
                          setState(
                            () {
                              selected = [...selected, question];
                            },
                          );
                        else
                          setState(() {
                            selected =
                                selected.where((q) => q != question).toList();
                          });
                      },
                      onQuestionToggled: (int id, bool isOn) {
                        if (isOn)
                          setState(() {
                            savedQuestions = [...savedQuestions, id];
                          });
                        else
                          setState(() {
                            savedQuestions = savedQuestions
                                .where((qid) => qid != id)
                                .toList();
                          });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 3.0,
          color: kPageBackgroundGray,
        ),
        Container(
          color: Colors.white,
          height: 48.0,
          child: Row(
            children: [
              if (selected.length > 0)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'review',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
              if (!widget.diagnostic && selected.length > 0)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'revise',
                          onPressed: () async {},
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
              if (!widget.diagnostic)
                Expanded(
                  child: Button(
                    label: 'new test',
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(CourseDetailsPage.routeName),
                      );
                    },
                  ),
                ),
              if (widget.diagnostic)
                Expanded(
                  child: Button(
                    label: 'Purchase',
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              StorePage(widget.user),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class QuestionTabView extends StatelessWidget {
  const QuestionTabView({
    required this.questions,
    required this.savedQuestions,
    required this.selectedQuestions,
    required this.onQuestionToggled,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final List questions;
  final List savedQuestions;
  final List selectedQuestions;
  final Function onQuestionToggled;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: questions.length,
      itemBuilder: (context, i) {
        var question = questions[i];

        return QuestionCard(
          question: question,
          questionNumber: (i + 1).toString(),
          isSaved: savedQuestions.contains(question['id']),
          isSelected: selectedQuestions.contains(question),
          onSaveToggled: onQuestionToggled,
          onSelected: () {
            onSelected(question);
          },
        );
      },
    );
  }
}
