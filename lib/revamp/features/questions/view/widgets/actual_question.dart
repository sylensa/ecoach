import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';

class ActualQuestion extends StatelessWidget {
  final String question, direction;
  User user;
  bool diagnostic;
   ActualQuestion({required this.question, this.direction = "",required this.user,this.diagnostic = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            border: Border.all(
              width: 1,
              color: const Color(0xFFC8C8C8),
            ),
          ),
          child:   AdeoHtmlTex(
            user,
            question.replaceAll("https", "http"),
            fontStyle: FontStyle.italic,
            useLocalImage: diagnostic ? false : true,
            // removeTags: question.contains("src") ? false : true,
            textColor: Colors.black,
            removeBr: true,
          ),
        ),
        Visibility(
          visible: direction.isNotEmpty,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
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
