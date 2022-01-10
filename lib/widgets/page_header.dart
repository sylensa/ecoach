import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.pageHeading,
    this.size = Sizes.large,
  });

  final String pageHeading;
  final Sizes size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: size == Sizes.large ? 40 : 24,
          horizontal: 12.0,
        ),
        child: Center(
          child: Text(
            pageHeading,
            textAlign: TextAlign.center,
            style: size == Sizes.large
                ? kPageHeaderStyle
                : kPageHeaderStyle.copyWith(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
