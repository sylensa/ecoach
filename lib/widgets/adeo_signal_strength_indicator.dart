import 'package:ecoach/utils/constants.dart';
import 'package:flutter/material.dart';

class AdeoSignalStrengthIndicator extends StatelessWidget {
  const AdeoSignalStrengthIndicator({
    required this.strength,
    this.size = Sizes.large,
    Key? key,
  }) : super(key: key);

  final int strength;
  final Sizes size;

  bool getStrengthOfLevel(level) {
    int singalCount = 7;
    double percentageOfCount = strength / 100 * singalCount;
    return percentageOfCount / level >= 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SignalIndicator(
          size: size,
          step: StrengthStep.ONE,
          isFilled: getStrengthOfLevel(1),
        ),
        SizedBox(width: size == Sizes.large ? 4 : 2),
        SignalIndicator(
          size: size,
          step: StrengthStep.TWO,
          isFilled: getStrengthOfLevel(2),
        ),
        SizedBox(width: size == Sizes.large ? 4 : 2),
        SignalIndicator(
          size: size,
          step: StrengthStep.THREE,
          isFilled: getStrengthOfLevel(3),
        ),
        SizedBox(width: size == Sizes.large ? 4 : 2),
        SignalIndicator(
          size: size,
          step: StrengthStep.FOUR,
          isFilled: getStrengthOfLevel(4),
        ),
        SizedBox(width: size == Sizes.large ? 4 : 2),
        SignalIndicator(
          size: size,
          step: StrengthStep.FIVE,
          isFilled: getStrengthOfLevel(5),
        ),
        SizedBox(width: size == Sizes.large ? 4 : 2),
        SignalIndicator(
          size: size,
          step: StrengthStep.SIX,
          isFilled: getStrengthOfLevel(6),
        ),
        SizedBox(width: size == Sizes.large ? 4 : 2),
        SignalIndicator(
          size: size,
          step: StrengthStep.SEVEN,
          isFilled: getStrengthOfLevel(7),
        ),
      ],
    );
  }
}

class SignalIndicator extends StatefulWidget {
  const SignalIndicator({
    required this.isFilled,
    required this.step,
    this.size = Sizes.large,
    Key? key,
  }) : super(key: key);

  final bool isFilled;
  final StrengthStep step;
  final Sizes size;

  @override
  State<SignalIndicator> createState() => _SignalIndicatorState();
}

class _SignalIndicatorState extends State<SignalIndicator> {
  late double height;
  late double width;
  late Color fillColor;

  @override
  void initState() {
    super.initState();
    setState(() {
      switch (widget.size) {
        case Sizes.small:
          width = 4;
          break;
        default:
          width = 8;
      }

      switch (widget.step) {
        case StrengthStep.ONE:
          widget.size == Sizes.large ? height = 14 : height = 7;
          fillColor = StrengthColors.one;
          break;
        case StrengthStep.TWO:
          widget.size == Sizes.large ? height = 18 : height = 9;
          fillColor = StrengthColors.two;
          break;
        case StrengthStep.THREE:
          widget.size == Sizes.large ? height = 23 : height = 12;
          fillColor = StrengthColors.three;
          break;
        case StrengthStep.FOUR:
          widget.size == Sizes.large ? height = 27 : height = 13;
          fillColor = StrengthColors.four;
          break;
        case StrengthStep.FIVE:
          widget.size == Sizes.large ? height = 31 : height = 15;
          fillColor = StrengthColors.five;
          break;
        case StrengthStep.SIX:
          widget.size == Sizes.large ? height = 36 : height = 18;
          fillColor = StrengthColors.six;
          break;
        case StrengthStep.SEVEN:
          widget.size == Sizes.large ? height = 40 : height = 20;
          fillColor = StrengthColors.seven;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: widget.isFilled ? fillColor : Colors.transparent,
          border: widget.isFilled
              ? Border.all(width: 0, color: Colors.transparent)
              : Border.all(
                  width: 1,
                  color: Color(0x33707070),
                ),
        ),
      ),
    );
  }
}

enum StrengthStep { ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN }

class StrengthColors {
  static Color one = Color(0xFFFF3100);
  static Color two = Color(0xFFFF6F00);
  static Color three = Color(0xFFFFBB00);
  static Color four = Color(0xFFFFF700);
  static Color five = Color(0xFFCCFF00);
  static Color six = Color(0xFF56FF00);
  static Color seven = Color(0xFF4AD902);
}
