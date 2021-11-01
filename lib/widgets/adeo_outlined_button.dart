import 'package:ecoach/utils/constants.dart';
import 'package:flutter/material.dart';

class AdeoOutlinedButton extends StatelessWidget {
  const AdeoOutlinedButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.ignoring = false,
    this.size,
    this.borderRadius,
  });

  final String label;
  final Color? color;
  final onPressed;
  final bool ignoring;
  final Sizes? size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: color ?? Colors.white,
          textStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
          side: BorderSide(color: color ?? Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 44)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: () {
              switch (size) {
                case Sizes.small:
                  return 32.0;
                case Sizes.medium:
                  return 44.0;
                case Sizes.large:
                  return 60.0;
                default:
                  return 44.0;
              }
            }(),
            vertical: () {
              switch (size) {
                case Sizes.small:
                  return 8.0;
                case Sizes.medium:
                  return 16.0;
                case Sizes.large:
                  return 20.0;
                default:
                  return 16.0;
              }
            }(),
          ),
        ),
        child: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
