import 'package:ecoach/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgressIndicatorWrapper extends StatelessWidget {
  const CircularProgressIndicatorWrapper({
    this.onTap,
    this.progress,
    this.progressColor = Colors.orange,
    this.size = ProgressIndicatorSize.small,
    this.progressPostFix = '%',
    this.subCenterText,
    this.useProgressAsMainCenterText = true,
    this.mainCenterText,
    this.mainCenterTextSize = ProgressIndicatorSize.small,
  });

  final onTap;
  final progress;
  final String progressPostFix;
  final Color progressColor;
  final ProgressIndicatorSize size;
  final String? subCenterText;
  final bool useProgressAsMainCenterText;
  final String? mainCenterText;
  final ProgressIndicatorSize? mainCenterTextSize;

  static const TextStyle centerTextStyle = TextStyle(
    fontSize: 10.0,
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Stack(
        children: [
          Container(
            width: (() {
              switch (size) {
                case ProgressIndicatorSize.small:
                  return 56.0;
                case ProgressIndicatorSize.large:
                  return 80.0;
              }
            }()),
            height: (() {
              switch (size) {
                case ProgressIndicatorSize.small:
                  return 56.0;
                case ProgressIndicatorSize.large:
                  return 80.0;
              }
            }()),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
            ),
          ),
          CircularPercentIndicator(
            radius: (() {
              switch (size) {
                case ProgressIndicatorSize.small:
                  return 56.0;
                case ProgressIndicatorSize.large:
                  return 80.0;
              }
            }()),
            lineWidth: 6.0,
            percent: progress * 0.01,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (useProgressAsMainCenterText ? progress.toInt().toString() : mainCenterText!) +
                      progressPostFix,
                  style: centerTextStyle.copyWith(
                    fontSize: mainCenterTextSize == ProgressIndicatorSize.large ? 20.0 : 10.0,
                  ),
                ),
                if (subCenterText != null)
                  Text(
                    subCenterText!,
                    style: centerTextStyle,
                  )
              ],
            ),
            progressColor: progressColor,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
