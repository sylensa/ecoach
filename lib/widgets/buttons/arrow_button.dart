import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({
    required this.arrow,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String arrow;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: Feedback.wrapForTap(() async {
        await Future.delayed(Duration(milliseconds: 600));
        onPressed();
      }, context),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => Color(0x402A9CEA),
        ),
      ),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: Image.asset(
          arrow,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
