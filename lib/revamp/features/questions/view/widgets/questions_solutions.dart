import 'package:ecoach/revamp/core/utils/extra.dart';
import 'package:flutter/material.dart';

class QuestionSolution extends StatefulWidget {
  const QuestionSolution({Key? key}) : super(key: key);

  @override
  State<QuestionSolution> createState() => _QuestionSolutionState();
}

class _QuestionSolutionState extends State<QuestionSolution> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF00C9B9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ExpansionTile(
        textColor: Colors.white,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: const Text(
          'Solution',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        children: <Widget>[
          const Divider(
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              placeHolderText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
