import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

import '../../models/question.dart';
import '../../revamp/core/utils/app_colors.dart';
import '../../widgets/questions_widgets/adeo_html_tex.dart';

List<String> answers = [
  "By using a sickle",
  "By using a harvestor",
  "By uprooting",
  "By using a cutlass"
];

// class QuestionAnswer extends StatelessWidget {
//   final String details;
//   final bool hasSolution, hasImage, hasDetails, isReview;
//   const QuestionAnswer(
//       {this.hasDetails = false,
//       this.hasImage = false,
//       this.hasSolution = false,
//       this.isReview = false,
//       this.details = "",
//       Key? key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(17.0),
//       decoration: const BoxDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Visibility(
//             visible: hasDetails,
//             child: Card(
//                 elevation: 0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "placeHolderText",
//                     maxLines: 5,
//                   ),
//                 )),
//           ),
//           Visibility(
//               visible: hasImage,
//               child: Image.asset("images/green_backgroud.png")),
//           const SizedBox(
//             height: 5,
//           ),
//           // Visibility(
//           //   visible: hasSolution,
//           //   child: const QuestionSolution(),
//           // ),
//           // const SizedBox(
//           //   height: 26,
//           // ),
//           ...List.generate(answers.length, (index) {
//             if (!isReview) {
//               if (index == 1) {
//                 return selectedAnswer(answers[index]);
//               }
//
//               return answer(index);
//             } else {
//               if (index == 1) {
//                 return wrongAnswer(answers[index]);
//               } else if (index == 2) {
//                 return missedAnswer(answers[index]);
//               } else {
//                 return answer(index);
//               }
//             }
//           })
//         ],
//       ),
//     );
//   }
//

//

// }

Widget wrongAnswer(answer, User user) {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: AdeoHtmlTex(
            user,
            answer.text!.replaceAll("https", "http"),
            useLocalImage: true,
            fontSize: 25,
            textAlign: TextAlign.left,
            fontWeight: FontWeight.bold,
            removeBr: true,
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
    margin: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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

Widget missedAnswer(answer, User user) {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: AdeoHtmlTex(
            user,
            answer.text!.replaceAll("https", "http"),
            useLocalImage: true,
            fontSize: 25,
            textAlign: TextAlign.left,
            fontWeight: FontWeight.bold,
            removeBr: true,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.radio_button_checked,
          color: Colors.white,
        )
      ],
    ),
    margin: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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

Container newAnswerWidget(Answer answer, User user) {
  return Container(
    child: Row(
      children: [
        Expanded(
          child: AdeoHtmlTex(
            user,
            answer.text!.replaceAll("https", "http"),
            useLocalImage: true,
            textColor: kSecondaryTextColor,
            fontSize: 16,
            textAlign: TextAlign.left,
            fontWeight: FontWeight.bold,
            removeBr: true,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.radio_button_checked,
          color: Colors.white,
        )
      ],
    ),
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        width: 1,
        color: const Color(0xFFC8C8C8),
      ),
    ),
  );
}

Widget newSelectedAnswerWidget(Answer answer, User user) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
    child: Row(
      children: [
        Expanded(
          child: AdeoHtmlTex(
            user,
            answer.text!.replaceAll("https", "http"),
            useLocalImage: true,
            textColor: Colors.white,
            fontSize: 25,
            textAlign: TextAlign.left,
            fontWeight: FontWeight.bold,
            removeBr: true,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.radio_button_checked,
          color: Colors.white,
        )
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    decoration: BoxDecoration(
      color: const Color(0xFF0367B4),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        width: 1,
        color: const Color(0xFF0367B4),
      ),
    ),
  );
}
