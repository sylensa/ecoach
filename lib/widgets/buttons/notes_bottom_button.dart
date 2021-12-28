import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class NotesBottomButton extends StatelessWidget {
  const NotesBottomButton({
    required this.label,
    this.onTap,
    this.ignore = false,
  });

  final String label;
  final onTap;
  final bool ignore;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignore,
      child: GestureDetector(
        onTap: Feedback.wrapForTap(onTap, context),
        child: Container(
          alignment: Alignment.center,
          height: 72.0,
          width: double.infinity,
          color: kAdeoWhiteAlpha81,
          child: Text(
            label,
            style: TextStyle(
              color: kAdeoBlue,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
