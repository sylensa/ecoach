import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading(
    this.heading, {
    Key? key,
    this.textStyle,
  }) : super(key: key);

  final String heading;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    bool isLarge = MediaQuery.of(context).size.width > 1200;
    
    TextStyle _textStyle = textStyle ??
        TextStyle(
          fontFamily: 'PoppinsMedium',
          fontSize: isLarge ? 24 : 18,
          color: kDefaultBlack,
        );

    return Text(
      heading.toTitleCase(),
      textAlign: TextAlign.left,
      style: _textStyle,
    );
  }
}
