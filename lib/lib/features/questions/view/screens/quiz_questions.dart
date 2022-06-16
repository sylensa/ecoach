import 'package:ecoach/lib/features/questions/view/screens/quiz_review_page.dart';
import 'package:ecoach/lib/features/questions/view/widgets/actual_question.dart';
import 'package:ecoach/lib/features/questions/view/widgets/end_question.dart';
import 'package:ecoach/lib/features/questions/view/widgets/question_answer.dart';
import 'package:ecoach/lib/features/questions/view/widgets/questions_app_bar.dart';
import 'package:ecoach/lib/features/questions/view/widgets/questions_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/app_colors.dart';

class QuizQuestion extends StatelessWidget {
  const QuizQuestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.bottomSheet(const EndQuestionWidget());
        return false;
      },
      child: Scaffold(
        appBar: questionAppBar(),
        bottomNavigationBar: InkWell(
          onTap: () {
            Get.to(() => const QuizReviewPage());
          },
          child: Container(
            color: kAccessmentButtonColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const Text(
              'Submit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
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
                QuestionAnswer()
              ],
            ))
          ],
        ),
      ),
    );
  }
}
