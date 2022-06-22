
import 'package:ecoach/revamp/features/questions/view/widgets/actual_question.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/question_action.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/question_answer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'view/widgets/questions_app_bar.dart';
import 'view/widgets/questions_header.dart';

class QuestionOne extends StatelessWidget {
  const QuestionOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: questionAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            QuestionsHeader(),
            // ActualQuestion(
            //   question: "What is the best the dry season ?",
            //   direction: "Choose the right answer to the question above",
            // ),
            
            QuestionAnswer(
              details: "What is the best the dry season ?",
            ),
            QuestionActions()
          ],
        ),
      ),
    );
  }
}
