import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/topic_analysis.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:ecoach/widgets/tab_bar_views/results_page_questions_view.dart';
import 'package:ecoach/widgets/tab_bar_views/results_page_topics_view.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ResultsView extends StatefulWidget {
  ResultsView(this.user, this.course,
      {Key? key,
      required this.test,
      this.history = false,
      this.diagnostic = false})
      : super(key: key);
  final User user;
  final Course course;
  TestTaken test;
  bool diagnostic;
  bool history;

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  static const TextStyle _topLabelStyle = TextStyle(
    fontSize: 14.0,
    color: Color(0xFF969696),
  );
  static const TextStyle _topMainTextStyle = TextStyle(
    fontFamily: 'Helvetica Rounded',
    fontSize: 35.0,
    color: kAdeoGray2,
  );

  List<TopicAnalysis> topics = [];
  List topicsPlaceholder = [];
  List questionPlaceholder = [];

  @override
  void initState() {
    super.initState();

    List<TestAnswer>? answers;

    TestController().topicsAnalysis(widget.test).then((mapList) async {
      mapList.keys.forEach((key) {
        answers = mapList[key]!;
        TopicAnalysis analysis = TopicAnalysis(key, answers!);

        topicsPlaceholder.add({
          'topicId': analysis.answers[0].topicId,
          'name': analysis.name,
          'rating': analysis.performanceNote,
          'total_questions': analysis.total,
          'correctly_answered': analysis.correct,
        });
      });

      List<Question> questions =
          await TestController().getAllQuestions(widget.test);

      print("questions=${questions.length}");
      for (int i = 0; i < questions.length; i++) {
        Question? question = questions[i];

        questionPlaceholder.add({
          'id': question.id,
          'question': question.text,
          'score': getScoreEnum(question),
          'position': i + 1,
        });
      }
      setState(() {});
    });
  }

  getScoreEnum(Question question) {
    print('get score');
    if (question.isCorrect) {
      print('question is correct');
      return ExamScore.CORRECTLY_ANSWERED;
    }
    if (question.isWrong) {
      print('question is wrong');
      return ExamScore.WRONGLY_ANSWERED;
    }

    print('question is not attempted');
    return ExamScore.NOT_ATTEMPTED;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPageBackgroundGray,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 31.0,
                bottom: 21.0,
                left: 24,
                right: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.test.score!.ceil().toString() + '%',
                        style: _topMainTextStyle,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Score',
                        style: _topLabelStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        getDurationTime(
                          Duration(seconds: widget.test.usedTime ?? 0),
                        ),
                        style: _topMainTextStyle,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Time Taken',
                        style: _topLabelStyle,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${widget.test.numberOfQuestions}",
                        style: _topMainTextStyle,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Questions',
                        style: _topLabelStyle,
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              thickness: 3.0,
              color: Colors.white,
            ),
            SizedBox(height: 25),
            AdeoTabControl(
              variant: 'default',
              tabs: ['topics', 'questions'],
              tabPages: [
                TopicsTabPage(
                    topics: topicsPlaceholder,
                    diagnostic: widget.diagnostic,
                    user: widget.user,
                    history: widget.history),
                QuestionsTabPage(
                    questions: questionPlaceholder,
                    diagnostic: widget.diagnostic,
                    user: widget.user,
                    history: widget.history),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
