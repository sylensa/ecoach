import 'package:flutter/material.dart';

class ActualQuestion extends StatelessWidget {
  final String question, direction;
  const ActualQuestion({required this.question, this.direction = "", Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(35.0),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            border: Border.all(
              width: 1,
              color: const Color(0xFFC8C8C8),
            ),
          ),
          child: Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Visibility(
          visible: direction.isNotEmpty,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF67717D),
              border: Border.all(
                width: 1,
                color: const Color(0xFFC8C8C8),
              ),
            ),
            child: Text(
              direction,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
