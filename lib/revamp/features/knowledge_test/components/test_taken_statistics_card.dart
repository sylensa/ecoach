import 'dart:math' as math;

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/revamp/features/knowledge_test/controllers/knowledge_test_controller.dart';
import 'package:ecoach/revamp/features/knowledge_test/widgets/topic_analysis_table.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestsStatisticCard extends StatefulWidget {
  const TestsStatisticCard({
    Key? key,
    required this.showGraph,
    required this.getTest,
    required this.knowledgeTestControllerModel,
    required this.test,
    this.activeMenu = TestCategory.NONE,
    this.testTaken,
    this.isTestTaken = false,
  }) : super(key: key);

  final TestTaken? testTaken;
  final dynamic test;
  final bool showGraph;
  final bool isTestTaken;
  final TestCategory activeMenu;
  final KnowledgeTestControllerModel knowledgeTestControllerModel;
  final Future Function(BuildContext context, TestCategory testCategory,
      TestNameAndCount selectedTopic) getTest;

  @override
  State<TestsStatisticCard> createState() => _TestTakenStatisticCardState();
}

class _TestTakenStatisticCardState extends State<TestsStatisticCard>
    with TickerProviderStateMixin {
  String searchKeyword = '';
  bool isActiveStatisticsSide = false;
  TestCategory analysisTestType = TestCategory.NONE;
  String activeMenuIcon = "assets/icons/courses/";

  late bool isActiveGraphSide;
  late FlipCardController flipCardController;
  late AnimationController animationController;
  late Animation<double> animation;
  late dynamic _test;
  late bool isTestTaken;
  late bool smallHeightDevice;
  late int? topicId;
  late TestTaken? testTaken;

  @override
  void initState() {
    super.initState();
    flipCardController = FlipCardController();
    isActiveGraphSide = widget.showGraph;
    flipCardController._state = this;
    animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );


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
    _test = widget.test;
    testTaken = widget.testTaken ?? null;
    isTestTaken = widget.isTestTaken;

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                borderRadius: BorderRadius.circular(8),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: 280,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: sText(
                                  "${properCase(_test.name)}",
                                  color: Colors.black,
                                  weight: FontWeight.w500,
                                  size: 16,
                                ),
                              ),
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
                                  if (widget.knowledgeTestControllerModel
                                      .isShowAnalysisBox) toggleAnalysis();
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
                                    borderRadius: BorderRadius.circular(
                                      widget.knowledgeTestControllerModel
                                              .isShowAnalysisBox
                                          ? 12
                                          : 16,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.linearToEaseOut,
                                  child: Center(
                                    child: widget.knowledgeTestControllerModel
                                            .isShowAnalysisBox
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                "assets/images/pencil.png",
                                                width: 20,
                                              ),
                                              Text(
                                                "Graph",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black38,
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
                                    margin:
                                        EdgeInsets.only(top: 18, bottom: 18),
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
                                      color: kAdeoBlue2.withOpacity(0.1),
                                      border: Border.all(
                                        color: kAdeoBlue,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        widget.knowledgeTestControllerModel
                                                .isShowAnalysisBox
                                            ? 16
                                            : 12,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 600),
                                    curve: Curves.linearToEaseOut,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (widget.knowledgeTestControllerModel
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
                                  borderRadius: BorderRadius.circular(8),
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
              : AnimatedContainer(
                  padding: EdgeInsets.all(26),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/oval-pattern.png"),
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
                  duration: Duration(milliseconds: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                        borderRadius: BorderRadius.circular(8),
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    SizedBox(
                                      width: isTestTaken ? 220 : 280,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: sText(
                                          "${properCase(_test.name)}",
                                          color: Colors.white,
                                          weight: FontWeight.bold,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isTestTaken)
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      testTaken!.scoreDiff! > 0
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
                                        width: 4,
                                      ),
                                      sText(
                                        "${testTaken!.scoreDiff! > 0 ? "+" : ""}${testTaken!.scoreDiff!.round()}",
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
                      isTestTaken
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 28,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        isTestTaken
                                            ? sText(
                                                "${testTaken!.total_test_taken}",
                                                size: 34,
                                                weight: FontWeight.w600,
                                                color: Colors.white,
                                              )
                                            : sText(
                                                "${_test.count}",
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
                                        isTestTaken
                                            ? sText(
                                                "${testTaken!.score!.round()}%",
                                                size: 34,
                                                weight: FontWeight.w600,
                                                color: Colors.white,
                                              )
                                            : sText(
                                                "${_test.averageScore!.round()}%",
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
                                          isTestTaken
                                              ? AdeoSignalStrengthIndicator(
                                                  strength: testTaken!.score!,
                                                  size: Sizes.small,
                                                )
                                              : AdeoSignalStrengthIndicator(
                                                  strength: _test.averageScore!,
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
                                    value: isTestTaken
                                        ? (testTaken!.correct! +
                                                testTaken!.wrong!) /
                                            testTaken!.totalQuestions
                                        : _test.progress,
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
                                          "${isTestTaken ? testTaken!.correct! + testTaken!.wrong! : _test.count}",
                                          color: Colors.white,
                                          weight: FontWeight.bold,
                                          size: 12,
                                        ),
                                        sText(
                                          " / ${isTestTaken ? testTaken!.totalQuestions : _test.totalCount} Q",
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
                              ],
                            )
                          : Center(
                              child: sText(
                                "No tests taken for this topic",
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isTestTaken)
                            GestureDetector(
                              onTap: () {
                                flipCardController.flipCard();
                              },
                              child: Image.asset(
                                "assets/images/pencil.png",
                              ),
                            ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              setState(() {
                                searchKeyword = _test.name.toLowerCase();
                              });

                              await widget.getTest(
                                context,
                                TestCategory.TOPIC,
                                _test,
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
                                borderRadius: BorderRadius.circular(8),
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

class FlipCardController {
  _TestTakenStatisticCardState? _state;

  Future flipCard() async => _state?.flipCard();
}
