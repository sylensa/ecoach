import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/revamp/features/knowledge_test/controllers/knowledge_test_controller.dart';
import 'package:ecoach/revamp/features/knowledge_test/widgets/topic_analysis_table.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlipCardController {
  _TestTakenStatisticCardState? _state;

  Future flipCard() async => _state?.flipCard();
}

class TestTakenStatisticCard extends StatefulWidget {
  const TestTakenStatisticCard({
    Key? key,
    required this.showGraph,
    required this.course,
    required this.getTest,
    required this.knowledgeTestControllerModel,
    required this.testsTaken,
    this.activeMenu = TestCategory.NONE,
    this.currentSlide = 0,
    this.carouselController,
  }) : super(key: key);

  final int currentSlide;
  final CarouselController? carouselController;
  final List<TestTaken> testsTaken;
  final bool showGraph;
  final Course course;
  final TestCategory activeMenu;
  final KnowledgeTestControllerModel knowledgeTestControllerModel;
  final Future Function(BuildContext context, TestCategory testCategory,
      int currentQuestionCount) getTest;

  @override
  State<TestTakenStatisticCard> createState() => _TestTakenStatisticCardState();
}

class _TestTakenStatisticCardState extends State<TestTakenStatisticCard>
    with TickerProviderStateMixin {
  String searchKeyword = '';
  bool isActiveStatisticsSide = false;
  TestCategory analysisTestType = TestCategory.NONE;
  String activeMenuIcon = "assets/icons/courses/";

  late bool isActiveGraphSide;
  late int _currentSlide;
  late CarouselController? _carouselController;
  late FlipCardController flipCardController;
  late AnimationController animationController;
  late Animation<double> animation;
  late List<TestTaken> _testsTaken;
  late bool smallHeightDevice;

  @override
  void initState() {
    super.initState();
    _currentSlide = widget.currentSlide;
    _carouselController = widget.carouselController;
    flipCardController = FlipCardController();

    isActiveGraphSide = widget.showGraph;
    flipCardController._state = this;

    animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _testsTaken = widget.testsTaken;

    switch (widget.activeMenu) {
      case TestCategory.TOPIC:
        activeMenuIcon += "topic.png";
        break;
      case TestCategory.MOCK:
        activeMenuIcon += "mock.png";
        break;
      case TestCategory.EXAM:
        activeMenuIcon += "bank.png";
        break;
      case TestCategory.ESSAY:
        activeMenuIcon += "essay.png";
        break;
      case TestCategory.SAVED:
        activeMenuIcon += "saved.png";
        break;
      case TestCategory.BANK:
        activeMenuIcon += "bank.png";
        break;
      case TestCategory.NONE:
        activeMenuIcon = "";
        break;
      default:
        activeMenuIcon = "";
        break;
    }
  }

  Future flipCard() async {
    if (animationController.isAnimating) return;

    if (isActiveStatisticsSide) {
      await animationController.reverse();
    } else {
      await animationController.forward();
    }
    isActiveStatisticsSide = !isActiveStatisticsSide;
  }

  bool isFrontCard(double angle) {
    final degrees90 = math.pi / 2;
    final degrees270 = 3 * math.pi / 2;
    return angle <= degrees90 || angle >= degrees270;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          physics: widget.knowledgeTestControllerModel.isShowAnalysisBox
              ? BouncingScrollPhysics()
              : NeverScrollableScrollPhysics(),
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: widget.knowledgeTestControllerModel.isShowAnalysisBox
                  ? 600
                  : 300,
              autoPlay: false,
              enableInfiniteScroll: false,
              autoPlayAnimationDuration: Duration(seconds: 1),
              enlargeCenterPage: false,
              viewportFraction: 1,
              aspectRatio: 2.0,
              pageSnapping: true,
              initialPage: _currentSlide,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentSlide = index;
                });
                widget.knowledgeTestControllerModel.currentAlphabet =
                    _testsTaken[_currentSlide].testname![0];
              },
            ),
            itemCount: _testsTaken.length, //Topc Tests Length
            itemBuilder: (BuildContext context, int indexReport, int index2) {
              return AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  final angle = animationController.value * -math.pi;
                  final transform = Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle);

                  return Transform(
                    transform: transform,
                    alignment: Alignment.center,
                    child: !isFrontCard(angle.abs())
                        ? Transform(
                            transform: Matrix4.identity()..rotateY(math.pi),
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.all(26),
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Color(0xFFFFFFFF),
                                    Color(0xFFEEEEEE),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        width: 28,
                                        height: 28,
                                        child: Image.asset(
                                          activeMenuIcon,
                                          width: 18,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEAEAEA),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      sText(
                                        "${properCase(_testsTaken[indexReport].testname!)}", //Name of Topic Test Taken
                                        color: Colors.black,
                                        weight: FontWeight.w500,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: (() {
                                            if (widget
                                                .knowledgeTestControllerModel
                                                .isShowAnalysisBox)
                                              toggleAnalysis();
                                          }),
                                          child: AnimatedContainer(
                                            padding: EdgeInsets.all(16),
                                            width: double.maxFinite,
                                            constraints: BoxConstraints(
                                              minHeight: widget
                                                      .knowledgeTestControllerModel
                                                      .isShowAnalysisBox
                                                  ? 56
                                                  : 146,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFEAEAEA),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                widget.knowledgeTestControllerModel
                                                        .isShowAnalysisBox
                                                    ? 12
                                                    : 16,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 600),
                                            curve: Curves.linearToEaseOut,
                                            child: Center(
                                              child: widget
                                                      .knowledgeTestControllerModel
                                                      .isShowAnalysisBox
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/pencil.png",
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          "Graph",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black38,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : Text(
                                                      "Graph goes here",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black38,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        if (widget.knowledgeTestControllerModel
                                            .isShowAnalysisBox)
                                          Expanded(
                                            child: AnimatedContainer(
                                              margin: EdgeInsets.only(
                                                  top: 18, bottom: 18),
                                              padding: EdgeInsets.all(16),
                                              width: double.maxFinite,
                                              constraints: BoxConstraints(
                                                minHeight: widget
                                                        .knowledgeTestControllerModel
                                                        .isShowAnalysisBox
                                                    ? 146
                                                    : 56,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    kAdeoBlue2.withOpacity(0.1),
                                                border: Border.all(
                                                  color: kAdeoBlue,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  widget.knowledgeTestControllerModel
                                                          .isShowAnalysisBox
                                                      ? 16
                                                      : 12,
                                                ),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 600),
                                              curve: Curves.linearToEaseOut,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AnalyticsTable(),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (widget
                                              .knowledgeTestControllerModel
                                              .isShowAnalysisBox) {
                                            widget.knowledgeTestControllerModel
                                                .isShowAnalysisBox = false;
                                          }
                                          flipCardController.flipCard();
                                        },
                                        child: Image.asset(
                                          "assets/icons/courses/exchange.png",
                                          width: 30,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          toggleAnalysis();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  "assets/icons/courses/right-arrow.png"),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              sText("Analysis",
                                                  color: Colors.black,
                                                  weight: FontWeight.normal),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: kAdeoBlue2.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: kAdeoBlue,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(26),
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/oval-pattern.png"),
                                fit: BoxFit.cover,
                              ),
                              color: Color(0XFF0ff0364AE),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xFF0364AE),
                                  Color(0xFF023760),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6),
                                                width: 28,
                                                height: 28,
                                                child: Image.asset(
                                                  activeMenuIcon,
                                                  width: 18,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  shape: BoxShape.rectangle,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              sText(
                                                "${properCase(_testsTaken[indexReport].testname!)}", //Name of Topic Test Taken
                                                color: Colors.white,
                                                weight: FontWeight.bold,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              _testsTaken[indexReport]
                                                          .scoreDiff! >
                                                      0
                                                  ? Image.asset(
                                                      "assets/images/un_fav.png",
                                                      color: Colors.green,
                                                      width: 25,
                                                    )
                                                  : SvgPicture.asset(
                                                      "assets/images/fav.svg",
                                                      width: 25,
                                                    ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              sText(
                                                "${_testsTaken[indexReport].scoreDiff! > 0 ? "+" : ""}${_testsTaken[indexReport].scoreDiff!}",
                                                color: Colors.white,
                                                weight: FontWeight.bold,
                                                size: 16,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 28,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        sText(
                                          "${_testsTaken[indexReport].total_test_taken}",
                                          size: 34,
                                          weight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        sText(
                                          "times taken",
                                          size: 12,
                                          color: Colors.white.withOpacity(0.7),
                                          weight: FontWeight.w300,
                                          style: FontStyle.italic,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        sText(
                                          "${_testsTaken[indexReport].score!.round()}%",
                                          size: 34,
                                          weight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        sText(
                                          "mastery",
                                          size: 12,
                                          color: Colors.white.withOpacity(0.7),
                                          weight: FontWeight.w300,
                                          style: FontStyle.italic,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          AdeoSignalStrengthIndicator(
                                            strength:
                                                _testsTaken[indexReport]
                                                    .score!,
                                            size: Sizes.small,
                                          ),
                                          SizedBox(
                                            height: 26,
                                          ),
                                          sText(
                                            "strength",
                                            size: 12,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            weight: FontWeight.w300,
                                            style: FontStyle.italic,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: LinearProgressIndicator(
                                    color: Color(0XFF00C9B9),
                                    backgroundColor: Color(0XFF0367B4),
                                    value: (_testsTaken[indexReport]
                                                .correct! +
                                            _testsTaken[indexReport]
                                                .wrong!) /
                                        _testsTaken[indexReport]
                                            .totalQuestions,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    sText(
                                      "exposure",
                                      size: 12,
                                      color: Colors.white.withOpacity(0.7),
                                      weight: FontWeight.w300,
                                      style: FontStyle.italic,
                                    ),
                                    Row(
                                      children: [
                                        sText(
                                          "${_testsTaken[indexReport].correct! + _testsTaken[indexReport].wrong!}",
                                          color: Colors.white,
                                          weight: FontWeight.bold,
                                          size: 12,
                                        ),
                                        sText(
                                          " / ${_testsTaken[indexReport].totalQuestions} Q",
                                          color: Colors.white.withOpacity(0.7),
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        flipCardController.flipCard();
                                        // setState(() {
                                        //   if (isActiveGraphSide) {
                                        //     isActiveGraphSide = false;
                                        //   } else {
                                        //     isActiveGraphSide = true;
                                        //   }
                                        // });
                                      },
                                      child: Image.asset(
                                        "assets/images/pencil.png",
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          searchKeyword =
                                              _testsTaken[indexReport]
                                                  .testname!
                                                  .toLowerCase();
                                        });
                                        await widget.getTest(
                                          context,
                                          TestCategory.NONE,
                                          _testsTaken[indexReport]
                                                  .correct! +
                                              _testsTaken[indexReport]
                                                  .wrong!,
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        child: sText(
                                          "Take Test",
                                          color: Colors.white,
                                        ),
                                        decoration: BoxDecoration(
                                          color: kAdeoGreen4,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  void toggleAnalysis() {
    setState(() {
      widget.knowledgeTestControllerModel.isShowAnalysisBox =
          !widget.knowledgeTestControllerModel.isShowAnalysisBox;

      analysisTestType = widget.knowledgeTestControllerModel.isShowAnalysisBox
          ? TestCategory.TOPIC
          : TestCategory.NONE;
    });
  }
}
