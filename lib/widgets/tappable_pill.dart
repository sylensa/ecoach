import 'package:ecoach/models/ui/pill.dart';
import 'package:flutter/material.dart';

class TappablePill extends StatelessWidget {
  const TappablePill({
    required this.pill,
    this.isSelected: false,
  });

  final Pill pill;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pill.horizontalPadding),
      height: pill.height,
      decoration: BoxDecoration(
        color: isSelected
            ? pill.activeBackgroundColor
            : pill.inActiveBackgroundColor,
        borderRadius: BorderRadius.circular(pill.borderRadius),
        border: Border.all(
          color: isSelected
              ? pill.activeBackgroundColor
              : pill.borderColor ?? Color(0xFF989898),
          width: pill.borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          pill.label,
          style: TextStyle(
            fontSize: pill.fontSize,
            color: isSelected ? pill.activeLabelColor : pill.inActiveLabelColor,
          ),
        ),
      ),
    );
  }
}
