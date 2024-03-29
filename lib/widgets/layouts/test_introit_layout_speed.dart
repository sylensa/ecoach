import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PadTop { FULL, MILD }

class TestIntroitBaseScaffold extends StatelessWidget {
  final Widget child;
  final Color background;
  final String backgroundImageURL;

  TestIntroitBaseScaffold({
    required this.child,
    required this.background,
    required this.backgroundImageURL,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned(
            child: Container(
              height: 400.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    backgroundImageURL,
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   left: -36.0,
          //   right: -36.0,
          //   top: 85,
          //   child: Container(
          //     height: backgroundIllustrationHeight,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         fit: BoxFit.cover,
          //         image: AssetImage(
          //           backgroundImageURL,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: child,
          ),
        ],
      ),
    );
  }
}

class TestIntroitLayoutSpeed extends StatelessWidget {
  final List<TestIntroitLayoutPageSpeed> pages;
  final Color background;
  final Color headerColor;
  final String backgroundImageURL;
  final PadTop? padTop;
  static PageController _controller = PageController();

  static Function goForward = () {
    _controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  };
  static Function goBack = () {
    _controller.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  };

  TestIntroitLayoutSpeed({
    required this.pages,
    required this.background,
    this.headerColor = kDefaultBlack,
    required this.backgroundImageURL,
    this.padTop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestIntroitBaseScaffold(
      background: background,
      backgroundImageURL: backgroundImageURL,
      child: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: pages
            .map(
              (page) => Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        if (padTop == PadTop.FULL) SizedBox(height: 120),
                        if (padTop == PadTop.MILD) SizedBox(height: 60),
                        SizedBox(height: 141),
                        if (page.title != null)
                          Text(
                            page.title!,
                            style: TextStyle(
                              color: headerColor,
                              fontSize: 44.0.sp,
                            ).copyWith(
                              color: page.foregroundColor,
                              fontWeight: page.fontWeight,
                            ),
                          ),
                        if (page.subText != null)
                          Column(
                            children: [
                              SizedBox(height: 11),
                              Text(
                                page.subText!,
                                style: kCustomizedTestSubtextStyle.copyWith(
                                  color: page.foregroundColor,
                                ),
                              ),
                            ],
                          ),
                        page.middlePiece,
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      page.footer,
                      SizedBox(height: 53),
                    ],
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class TestIntroitLayoutPageSpeed {
  final String? title;
  final String? subText;
  final Widget middlePiece;
  final Widget footer;
  final Color? foregroundColor;
  final FontWeight? fontWeight;

  TestIntroitLayoutPageSpeed({
    required this.middlePiece,
    required this.footer,
    this.title,
    this.subText,
    this.foregroundColor,
    this.fontWeight,
  });
}
