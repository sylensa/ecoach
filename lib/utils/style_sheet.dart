import 'package:flutter/material.dart';

ButtonStyle greenButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Color(0xFF00C664)),
  foregroundColor: MaterialStateProperty.all(Colors.white),
);

const kCourseCardSnippetPadding = EdgeInsets.only(left: 20.0, right: 16.0);
const kCourseCardOverlayColor = Colors.black12;
const kTenPointWhiteText = TextStyle(fontSize: 10, color: Colors.white);
const kBlack38 = Colors.black38;

// progress colors
const kProgressColors = [
  Color(0xFFFFD600),
  Color(0xFF5AE52B),
  Color(0xFFFE5040),
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
const kNavigationTopBorderColor = Color(0xFFC0C0C0);

const kSixteenPointWhiteText = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins',
);

const kTableBodyMainText = TextStyle(
  fontSize: 12,
  color: Colors.white,
  fontFamily: 'Poppins',
);

const kTableBodySubText = TextStyle(
  fontSize: 12,
  color: Color(0x88FFFFFF),
  fontFamily: 'Poppins',
);

const kAnalysisInfoSnippetBackground1 = Color(0xFFFFB34E);
const kAnalysisInfoSnippetBackground2 = Color(0xFF28BFDF);
const kAnalysisInfoSnippetBackground3 = Color(0xFF13BFA3);
