import 'package:ecoach/utils/style_sheet.dart';
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                position.toString(),
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: kBlack38,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Text(
                      '/',
                      style: kTenPointWhiteText,
                    ),
                    Text(
                      numberOnRoll.toString(),
                      style: kTenPointWhiteText,
                    ),
                  ],
                ),
              )
            ],
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
