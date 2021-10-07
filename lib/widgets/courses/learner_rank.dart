import 'package:ecoach/widgets/superscripted_denominator_fraction_horizontal.dart';
import 'package:flutter/material.dart';

class LearnerRank extends StatelessWidget {
  const LearnerRank({required this.position, required this.numberOnRoll});

  final int position;
  final int numberOnRoll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: SuperScriptedDenominatorFractionHorizontal(
            numerator: position,
            denomenator: numberOnRoll,
          ),
        ),
        Image.asset(
          'assets/icons/success.png',
          width: 28,
        ),
      ],
    );
  }
}
