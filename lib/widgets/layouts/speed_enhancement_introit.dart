import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_gray_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SpeedEnhancementIntroit extends StatelessWidget {
  const SpeedEnhancementIntroit({
    required this.heroText,
    required this.subText,
    required this.heroImageURL,
    required this.stage,
    this.topActionOnPressed,
    this.mainActionOnPressed,
  });

  final String heroText;
  final String subText;
  final String heroImageURL;
  final int stage;
  final mainActionOnPressed;
  final topActionOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 32.0,
                  lineWidth: 4.0,
                  percent: stage / 3,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stage.toString(),
                        style: TextStyle(
                          color: kAdeoCoral,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  progressColor: kAdeoCoral,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                ),
                AdeoGrayOutlinedButton(
                  label: 'return',
                  onPressed: topActionOnPressed,
                  size: Sizes.small,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    heroText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kAdeoCoral,
                      fontWeight: FontWeight.w600,
                      fontSize: 32.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      subText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFACACAC),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 48.0),
                  Container(
                    height: 270.0,
                    width: double.infinity,
                    child: Image.asset(
                      heroImageURL,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ),
          AdeoOutlinedButton(
            label: 'Proceed',
            onPressed: mainActionOnPressed,
            color: kAdeoCoral,
            borderRadius: 0,
          ),
          SizedBox(height: 48.0),
        ],
      ),
    );
  }
}
