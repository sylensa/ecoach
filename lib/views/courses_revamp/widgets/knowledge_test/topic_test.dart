import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/keyword/keyword_graph.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KnowledgeTopicTestWidget extends StatefulWidget {
  const KnowledgeTopicTestWidget({
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
  State<KnowledgeTopicTestWidget> createState() =>
      _KnowledgeTopicTestWidgetState();
}

class _KnowledgeTopicTestWidgetState extends State<KnowledgeTopicTestWidget> {
  int _currentSlide = 0;
  String searchKeyword = '';
  late bool _showGraph;

  @override
  void initState() {
    super.initState();
    _showGraph = widget.showGraph;
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
            height: _showGraph ? 200 : 300,
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
          itemCount: keywordTestTaken.length,
          itemBuilder: (BuildContext context, int indexReport, int index2) {
            if (_showGraph) {
              return MaterialButton(
                onPressed: () {
                  setState(() {
                    _showGraph = false;
                  });
                },
                child: KeywordGraph(
                  course: widget.course,
                  keyword: keywordTestTaken[indexReport].testname!,
                  changeState: true,
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
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.trending_up,
                                      color: Colors.black,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        shape: BoxShape.rectangle),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  sText(
                                    "${properCase(keywordTestTaken[indexReport].testname!)}",
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
                                  keywordTestTaken[indexReport].scoreDiff! > 0
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
                                    "${keywordTestTaken[indexReport].scoreDiff! > 0 ? "+" : ""}${keywordTestTaken[indexReport].scoreDiff!}",
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
                              "${keywordTestTaken[indexReport].total_test_taken}",
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
                              "${keywordTestTaken[indexReport].score!.round()}%",
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
                                strength: keywordTestTaken[indexReport].score!,
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
                        value: (keywordTestTaken[indexReport].correct! +
                                keywordTestTaken[indexReport].wrong!) /
                            keywordTestTaken[indexReport].totalQuestions,
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
                              "${keywordTestTaken[indexReport].correct! + keywordTestTaken[indexReport].wrong!}",
                              color: Colors.white,
                              weight: FontWeight.bold,
                              size: 12,
                            ),
                            sText(
                              " / ${keywordTestTaken[indexReport].totalQuestions} Q",
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
                              searchKeyword = keywordTestTaken[indexReport]
                                  .testname!
                                  .toLowerCase();
                            });
                            await widget.getTest(
                              context,
                              TestCategory.NONE,
                              keywordTestTaken[indexReport].correct! +
                                  keywordTestTaken[indexReport].wrong!,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
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
