import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

ButtonStyle greenButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Color(0xFF00C664)),
  foregroundColor: MaterialStateProperty.all(Colors.white),
);

const kCourseCardSnippetPadding = EdgeInsets.only(left: 20.0, right: 16.0);
const kCourseCardOverlayColor = Colors.black12;
const kTenPointWhiteText = TextStyle(fontSize: 10, color: Colors.white);
const kBlack38 = Colors.black38;
const kDefaultBlack = Color(0xFF2A2121);
const reviewBackgroundColors = Color(0xFF464FA0);
const reviewSelectedColor = Color(0xFF2E346F);
const reviewDividerColor = Color(0xFFA8B1FF);
const kDefaultBlack2 = Color(0xFF132239);
const kDefaultBlack2SubtextColor = Color(0xFF787E87);

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
Color kAdeoOrangeH = HexColor("#FF8444");
const kAdeoBlue = Color(0xFF00ABE0);
const kAdeoBlue2 = Color(0xFF2A9CEA);
const kAdeoBlue3 = Color(0xFF0078D7);
const kAdeoBlueAccent = Color(0xFF9EE4FF);
const kAdeoGreen = Color(0xFF00C664);
const kAdeoGreen4 = Color(0xFF00C9B9);
const kAdeoWhiteAlpha40 = Color(0x66FFFFFF);
const kAdeoWhiteAlpha50 = Color(0x80FFFFFF);
const kAdeoWhiteAlpha81 = Color(0xCFFFFFFF);
const kAdeoGray = Color(0xFFF1F1F1);
const kAdeoGray2 = Color(0xFF707070);
const kAdeoGray3 = Color(0xFFA2A2A2);
const kAdeoCoral = Color(0xFFFB7B76);
const kAdeoOrange = Color(0xFFFF4F18);
const kAdeoOrange2 = Color(0xFFFF6344);
const kAdeoRoyalBlue = Color(0xFF2D3E50);
const kPageBackgroundGray = Color(0xFFF0F0F0);
const kDividerColor = Color(0xFF707070);
const kAdeoLightTeal = Color(0xFF00C9B9);
const kInputBorderColor = Color(0xFFB7B7B7);
const kInactiveOnDarkMode = Color(0xFF263443);
const kSixteenPointWhiteText = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins',
);
const kShadowColor = Color(0x29000000);
const kAdeoPrimary = Color(0xFF00C9B9);
const kPageBackgroundGray2 = Color(0xFFF8F8F8);
const kAdeoDark = Color(0xFF202B31);
const kAdeoDark_Green = Color(0xFF00C664);
const kAdeoDark_Gray = Color(0xFF3C3D42);
const kAdeoDark_Gray2 = Color(0xFF9B9B9B);
const kActiveOnDarkMode = Color(0xFF222E3B);

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
  fontFamily: 'Poppins',
);

const kCustomizedTestSubtextStyleWhite = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
  fontFamily: 'Poppins',
);

const kSpeedTestSubtextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
);

TextStyle kRightWidgetStyle(bool isSelected) {
  return TextStyle(
    fontSize: 11,
    color: isSelected ? Colors.white : Color(0xFF2A9CEA),
  );
}

TextStyle kIntroitScreenHeadingStyle({Color color = kDefaultBlack}) {
  return TextStyle(
    color: color,
    fontSize: 40,
    fontFamily: 'Hamelin',
  );
}

TextStyle kIntroitScreenHeadingStyle2({Color color = kDefaultBlack}) {
  return TextStyle(
    color: color,
    fontSize: 26,
    fontFamily: 'Hamelin',
  );
}

TextStyle kIntroitScreenSubHeadingStyle({Color color = kDefaultBlack}) {
  return TextStyle(
    color: color,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
  );
}

TextStyle inlinePromptStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
);
