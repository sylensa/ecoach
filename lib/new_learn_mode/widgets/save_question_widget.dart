import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helper/helper.dart';

class SavedQuestionWidget extends StatefulWidget {
  final Question? question;

  const SavedQuestionWidget({Key? key, required this.question})
      : super(key: key);

  @override
  State<SavedQuestionWidget> createState() => _SavedQuestionWidgetState();
}

class _SavedQuestionWidgetState extends State<SavedQuestionWidget> {
  bool isSaved = false;

  // save question if not save
  // remove question if already saved
  manageQuestionSavedInDatabase() async {
    if (widget.question != null) {
      if (isSaved) {
        await QuestionDB().deleteSavedTest(widget.question!.id!);
        isSaved = false;
        setState(() {});
      } else {
        await QuestionDB().insertTestQuestion(widget.question!);
        isSaved = true;
        setState(() {});
        toastMessage("Question saved successfully");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // checkIfQuestionIsSaved();
  }

  @override
  Widget build(BuildContext context) {
    // checkIfQuestionIsSaved();
    return GestureDetector(
      onTap: () {
        manageQuestionSavedInDatabase();
      },
      child: widget.question == null
          ? SizedBox()
          : FutureBuilder<Question?>(
              future:
                  QuestionDB().getSavedTestQuestionById(widget.question!.id!),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  // setState(() {
                  isSaved = false;
                  // });
                } else {
                  // setState(() {
                  isSaved = true;
                  // });
                }
                return SvgPicture.asset(
                  isSaved
                      ? "assets/images/on_switch.svg"
                      : "assets/images/off_switch.svg",
                );
              }),
    );
  }
}
