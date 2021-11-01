import 'package:ecoach/utils/constants.dart';
import 'package:flutter/material.dart';

class AdeoGrayOutlinedButton extends StatelessWidget {
  const AdeoGrayOutlinedButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.size,
  });

  final String label;
  final Color? color;
  final onPressed;
  final Sizes? size;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: color ?? Color(0xFF9C9C9C),
        textStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        side: BorderSide(color: Color(0xFFC6C6C6)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: () {
            switch (size) {
              case Sizes.small:
                return 32.0 / 2;
              case Sizes.medium:
                return 44.0 / 2;
              case Sizes.large:
                return 60.0 / 2;
              default:
                return 44.0 / 2;
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
    );
  }
}
