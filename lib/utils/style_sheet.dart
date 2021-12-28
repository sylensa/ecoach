import 'package:flutter/material.dart';

ButtonStyle greenButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Color(0xFF00C664)),
  foregroundColor: MaterialStateProperty.all(Colors.white),
);

const kCourseCardSnippetPadding = EdgeInsets.only(left: 20.0, right: 16.0);
const kCourseCardOverlayColor = Colors.black12;
const kTenPointWhiteText = TextStyle(fontSize: 10, color: Colors.white);
const kBlack38 = Colors.black38;
const kDefaultBlack = Color(0xFF2A2121);

// progress colors
const kProgressColors = [
  Color(0xFFFFD600),
  Color(0xFF5AE52B),
  Color(0xFFFE5040),
  Color(0xFF93E4EE),
  Color(0xFF8CFFC5),
];

// course card colors
const kCourseColors = [
  {'background': Color(0xFF8B00C6), 'progress': Color(0xFFFFB300)},
  {'background': Color(0xFF2A9CEA), 'progress': Color(0xFFEFFF00)},
  {'background': Color(0xFF44DAFF), 'progress': Color(0xFF707070)},
  {'background': Color(0xFF595959), 'progress': Color(0xFFFFB300)},
  {'background': Color(0xFF00C664), 'progress': Color(0xFFFFB300)},
  {'background': Color(0xFF3AAFFF), 'progress': Color(0xFFEFFF00)},
  {'background': Color(0xFFFFB444), 'progress': Color(0xFF707070)},
  {'background': Color(0xFFFF6344), 'progress': Color(0xFF6AC466)},
  {'background': Color(0xFF707070), 'progress': Color(0xFFFFB300)},
];

const kAnalysisScreenBackground = Color(0xFF636363);
const kAnalysisScreenActiveColor = Color(0xFF4C4C4C);
const kAnalysisInfoSnippetBackground1 = Color(0xFFFFB34E);
const kAnalysisInfoSnippetBackground2 = Color(0xFF28BFDF);
const kAnalysisInfoSnippetBackground3 = Color(0xFF13BFA3);

const kNavigationTopBorderColor = Color(0xFFC0C0C0);
const kAdeoTaupe = Color(0xFFFFB444);
const kAdeoBlue = Color(0xFF00ABE0);
const kAdeoGreen = Color(0xFF00C664);
const kAdeoWhiteAlpha40 = Color(0x66FFFFFF);
const kAdeoWhiteAlpha81 = Color(0xCFFFFFFF);
const kAdeoGray = Color(0xFFF1F1F1);
const kAdeoGray2 = Color(0xFF707070);
const kAdeoGray3 = Color(0xFFA2A2A2);
const kAdeoCoral = Color(0xFFFB7B76);
const kPageBackgroundGray = Color(0xFFF0F0F0);
const kDividerColor = Color(0xFF707070);

const kSixteenPointWhiteText = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins',
);

const kTableBodyMainText = TextStyle(
  fontSize: 13,
  color: Colors.white,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
);

const kTableBodySubText = TextStyle(
  fontSize: 12,
  color: Color(0x88FFFFFF),
  fontFamily: 'Poppins',
);

const kTwentyFourPointText = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.w700,
);

const kPinInputTextStyle = TextStyle(
  fontSize: 102.0,
  fontWeight: FontWeight.normal,
  color: kDefaultBlack,
  height: 1.1,
);

const kPageHeaderStyle = TextStyle(
  color: Color(0xFF2A9CEA),
  fontFamily: 'Helvetica Rounded',
  fontSize: 28,
);

const kCustomizedTestSubtextStyle = TextStyle(
  color: kDefaultBlack,
  fontSize: 16.0,
);
