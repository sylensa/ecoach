import 'package:ecoach/utils/constants.dart';
import 'package:flutter/material.dart';

class AdeoFilledButton extends StatelessWidget {
  const AdeoFilledButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.background,
    this.fontSize,
    this.size,
    this.borderRadius,
  });

  final String label;
  final onPressed;
  final Color? color;
  final Color? background;
  final double? fontSize;
  final Sizes? size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background ?? Colors.black,
      shape: StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: Feedback.wrapForTap(() async {
          await Future.delayed(Duration(milliseconds: 600));
          onPressed();
        }, context),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: () {
              switch (size) {
                case Sizes.small:
                  return 32.0;
                case Sizes.medium:
                  return 44.0;
                case Sizes.large:
                  return 56.0;
                default:
                  return 44.0;
              }
            }(),
            vertical: () {
              switch (size) {
                case Sizes.small:
                  return 8.0;
                case Sizes.medium:
                  return 12.0;
                case Sizes.large:
                  return 16.0;
                default:
                  return 12.0;
              }
            }(),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize ?? 22.0,
              color: color ?? Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
