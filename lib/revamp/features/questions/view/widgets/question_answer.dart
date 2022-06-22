
import 'package:ecoach/revamp/core/utils/extra.dart';
import 'package:ecoach/revamp/features/questions/view/widgets/questions_solutions.dart';
import 'package:flutter/material.dart';

List<String> answers = [
  "By using a sickle",
  "By using a harvestor",
  "By uprooting",
  "By using a cutlass"
];

class QuestionAnswer extends StatelessWidget {
  final String details;
  final bool hasSolution, hasImage, hasDetails, isReview;
  const QuestionAnswer(
      {this.hasDetails = false,
      this.hasImage = false,
      this.hasSolution = false,
      this.isReview = false,
      this.details = "",
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17.0),
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: hasDetails,
            child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    placeHolderText,
                    maxLines: 5,
                  ),
                )),
          ),
          Visibility(
              visible: hasImage,
              child: Image.asset("assets/images/green_backgroud.png")),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: hasSolution,
            child: const QuestionSolution(),
          ),
          const SizedBox(
            height: 26,
          ),
          ...List.generate(answers.length, (index) {
            if (!isReview) {
              if (index == 1) {
                return selectedAnswer(answers[index]);
              }

              return answer(index);
            } else {
              if (index == 1) {
                return wrongAnswer(answers[index]);
              } else if (index == 2) {
                return missedAnswer(answers[index]);
              } else {
                return answer(index);
              }
            }
          })
        ],
      ),
    );
  }

  Container answer(int index) {
    return Container(
      child: Text(
        answers[index],
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 1,
          color: const Color(0xFFE7E7E7),
        ),
      ),
    );
  }

  Widget selectedAnswer(answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Expanded(
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.radio_button_checked,
            color: Color(0xFF00C9B9),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 1,
          color: const Color(0xFF00C9B9),
        ),
      ),
    );
  }

  Widget wrongAnswer(answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Expanded(
            child: Text(
              answer,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.radio_button_unchecked,
            color: Colors.white,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6060),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 1,
          color: const Color(0xFFFF6060),
        ),
      ),
    );
  }

  Widget missedAnswer(answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Text(
        answer,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF00C9B9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 1,
          color: const Color(0xFF00C9B9),
        ),
      ),
    );
  }
}
