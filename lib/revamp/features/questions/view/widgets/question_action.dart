import 'package:flutter/material.dart';

class QuestionActions extends StatefulWidget {
  const QuestionActions({Key? key}) : super(key: key);

  @override
  State<QuestionActions> createState() => _QuestionActionsState();
}

class _QuestionActionsState extends State<QuestionActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 30),
            child: const Text(
              "Previous",
              style: TextStyle(fontSize: 14),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 30),
            child: const Text(
              "Next",
              style: TextStyle(fontSize: 14),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
