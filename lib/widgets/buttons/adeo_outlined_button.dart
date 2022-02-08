import 'package:flutter/material.dart';

class AdeoOutlinedButton extends StatelessWidget {
  const AdeoOutlinedButton({
    required this.label,
    required this.onPressed,
    this.ignoring = false,
  });

  final String label;
  final onPressed;
  final bool ignoring;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          textStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(color: Colors.white),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(
            horizontal: 44.0,
            vertical: 16.0,
          ),
        ),
        child: Text(label),
        onPressed: Feedback.wrapForTap(() async {
          await Future.delayed(Duration(milliseconds: 600));
          onPressed();
        }, context),
      ),
    );
  }
}
