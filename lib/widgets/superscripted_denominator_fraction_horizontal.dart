import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class SuperScriptedDenominatorFractionHorizontal extends StatelessWidget {
  const SuperScriptedDenominatorFractionHorizontal({
    required this.numerator,
    required this.denomenator,
    this.numeratorColor = kBlack38,
  });

  final int numerator;
  final int denomenator;
  final Color numeratorColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          numerator.toString(),
          style: kTwentyFourPointText.copyWith(color: numeratorColor),
        ),
        Container(
          margin: EdgeInsets.only(top: 6.0),
          child: Row(
            children: [
              Text(
                '/',
                style: kTenPointWhiteText,
              ),
              Text(
                denomenator.toString(),
                style: kTenPointWhiteText,
              ),
            ],
          ),
        )
      ],
    );
  }
}
