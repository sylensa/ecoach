import 'package:ecoach/lib/features/questions/view/widgets/actual_question.dart';
import 'package:ecoach/lib/features/questions/view/widgets/question_action.dart';
import 'package:ecoach/lib/features/questions/view/widgets/question_answer.dart';
import 'package:ecoach/lib/features/questions/view/widgets/questions_app_bar.dart';
import 'package:ecoach/lib/features/questions/view/widgets/questions_header.dart';
import 'package:flutter/material.dart';

class QuizReviewPage extends StatefulWidget {
  const QuizReviewPage({Key? key}) : super(key: key);

  @override
  State<QuizReviewPage> createState() => _QuizReviewPageState();
}

class _QuizReviewPageState extends State<QuizReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: questionAppBar(),
      body: Column(
        children: [
          const QuestionsHeader(),
          Expanded(
              child: ListView(
            children: const [
              ActualQuestion(
                question: "What is the best the dry season ?",
                direction: "Choose the right answer to the question above",
              ),
              QuestionAnswer(
                hasSolution: true,
                hasDetails: true,
                hasImage: true,
                isReview: true,
              ),
              QuestionActions()
            ],
          ))
        ],
      ),
    );
  }
}
