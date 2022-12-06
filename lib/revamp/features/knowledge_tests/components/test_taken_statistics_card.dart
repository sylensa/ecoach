import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/keyword/keyword_graph.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestTakenStatisticCard extends StatefulWidget {
  const TestTakenStatisticCard({
    Key? key,
    required this.showGraph,
    required this.course,
    required this.getTest,
    this.activeMenu = TestCategory.NONE,
  }) : super(key: key);

  final bool showGraph;
  final Course course;
  final TestCategory activeMenu;

  final Future Function(BuildContext context, TestCategory testCategory,
      int currentQuestionCount) getTest;

  @override
  State<TestTakenStatisticCard> createState() => _TestTakenStatisticCardState();
}

class _TestTakenStatisticCardState extends State<TestTakenStatisticCard> {
  int _currentSlide = 0;
  String searchKeyword = '';
  late bool _showGraph;
  List<TestTaken> topicTestsTaken = [];
  String activeMenuIcon = "assets/icons/courses/";

  @override
  void initState() {
    super.initState();
    _showGraph = widget.showGraph;
    topicTestsTaken = [
      TestTaken(
        testname: "ICT",
        scoreDiff: 4,
        score: 60,
        totalQuestions: 14,
        responses: '',
        correct: 10,
        wrong: 0,
        total_test_taken: 5,
        userId: 3334,
      ),
      TestTaken(
        testname: "Psychology",
        scoreDiff: -1,
        score: 80,
        totalQuestions: 50,
        responses: '',
        correct: 10,
        wrong: 3,
        total_test_taken: 12,
        userId: 3334,
      ),
    ];

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 300,
            autoPlay: false,
            enableInfiniteScroll: false,
            autoPlayAnimationDuration: Duration(seconds: 1),
            enlargeCenterPage: false,
            viewportFraction: 1,
            aspectRatio: 2.0,
            pageSnapping: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentSlide = index;
              });
            },
          ),
          itemCount: topicTestsTaken.length, //Topc Tests Length
          itemBuilder: (BuildContext context, int indexReport, int index2) {
            if (_showGraph) {
              return Container(
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
                        sText(
                          "${properCase(topicTestsTaken[indexReport].testname!)}", //Name of Topic Test Taken
                          color: Colors.black,
                          weight: FontWeight.w500,
                          size: 16,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(26),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Graph goes here",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_showGraph) {
                                _showGraph = false;
                              } else {
                                _showGraph = true;
                              }
                            });
                          },
                          child: Image.asset("assets/icons/courses/exchange.png", width: 30,),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              searchKeyword = topicTestsTaken[indexReport]
                                  .testname!
                                  .toLowerCase();
                            });
                            await widget.getTest(
                              context,
                              TestCategory.NONE,
                              topicTestsTaken[indexReport].correct! +
                                  topicTestsTaken[indexReport].wrong!,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Image.asset("assets/icons/courses/right-arrow.png"),
                                SizedBox(width: 8,),
                                sText("Analysis",
                                    color: Colors.black, weight: FontWeight.normal),
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
              );

            } else {
              return Container(
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
                                  sText(
                                    "${properCase(topicTestsTaken[indexReport].testname!)}", //Name of Topic Test Taken
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  topicTestsTaken[indexReport].scoreDiff! > 0
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
                                    "${topicTestsTaken[indexReport].scoreDiff! > 0 ? "+" : ""}${topicTestsTaken[indexReport].scoreDiff!}",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            sText(
                              "${topicTestsTaken[indexReport].total_test_taken}",
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
                              "${topicTestsTaken[indexReport].score!.round()}%",
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
                                strength: topicTestsTaken[indexReport].score!,
                                size: Sizes.small,
                              ),
                              SizedBox(
                                height: 26,
                              ),
                              sText(
                                "strength",
                                size: 12,
                                color: Colors.white.withOpacity(0.7),
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
                        value: (topicTestsTaken[indexReport].correct! +
                                topicTestsTaken[indexReport].wrong!) /
                            topicTestsTaken[indexReport].totalQuestions,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "${topicTestsTaken[indexReport].correct! + topicTestsTaken[indexReport].wrong!}",
                              color: Colors.white,
                              weight: FontWeight.bold,
                              size: 12,
                            ),
                            sText(
                              " / ${topicTestsTaken[indexReport].totalQuestions} Q",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_showGraph) {
                                _showGraph = false;
                              } else {
                                _showGraph = true;
                              }
                            });
                          },
                          child: Image.asset("assets/images/pencil.png"),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              searchKeyword = topicTestsTaken[indexReport]
                                  .testname!
                                  .toLowerCase();
                            });
                            await widget.getTest(
                              context,
                              TestCategory.NONE,
                              topicTestsTaken[indexReport].correct! +
                                  topicTestsTaken[indexReport].wrong!,
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
              );
            }
          },
        ),
      ],
    );
  }
}
