import 'dart:math' as math;

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/revamp/features/knowledge_test/components/alphabet_scroll_slider.dart';
import 'package:ecoach/revamp/features/knowledge_test/components/test_taken_statistics_card.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;
  final double elevation;

  const CustomSliderThumbCircle({
    required this.thumbRadius,
    this.min = 0,
    this.max = 10,
    this.elevation = 1.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = thumbRadius
      ..style = PaintingStyle.stroke;

    final Path shadowPath = Path()
      ..addArc(
        Rect.fromCenter(
          center: center,
          width: 3 * thumbRadius,
          height: 3 * thumbRadius,
        ),
        0,
        math.pi * 2,
      );

    canvas.drawShadow(
        shadowPath, Colors.black.withOpacity(0.3), elevation, true);
    canvas.drawCircle(center, thumbRadius, borderPaint);
    canvas.drawCircle(center, thumbRadius * 0.7, fillPaint);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}

class KnowledgeTestControllerModel extends ChangeNotifier {
  bool _isShowAnalysisBox = false;

  bool get isShowAnalysisBox => _isShowAnalysisBox;

  set isShowAnalysisBox(bool value) {
    if (value != _isShowAnalysisBox) {
      _isShowAnalysisBox = value;
    }
    notifyListeners();
  }
}

class KnowledgeTestController extends ChangeNotifier {
  TextEditingController searchKeywordController = TextEditingController();
  String searchKeyword = '';
  bool searchTap = false;
  bool showGraph = false;
  List<CourseKeywords> listCourseKeywordsData = [];
  List<Question> listQuestions = [];
  bool isActiveAnyMenu = false;
  bool sheetHeightIncreased = false;
  late double sheetHeight;
  late TestCategory activeMenu = TestCategory.NONE;
  bool isShowAlphaScroll = false;

  bool _isShowAnalysisBox = false;
  bool get isShowAnalysisBox => _isShowAnalysisBox;

  set isShowAnalysisBox(bool value) {
    if (value != _isShowAnalysisBox) {
      _isShowAnalysisBox = value;
    }
    notifyListeners();
  }

  Map<String, List<CourseKeywords>> groupedCourseKeywordsLists = {
    'A': [
      CourseKeywords(
        keyword: "Animal",
        total: 12,
      ),
      CourseKeywords(
        keyword: "Anonymous",
        total: 1,
      ),
      CourseKeywords(
        keyword: "Abstract",
        total: 3,
      ),
    ],
    'B': [
      CourseKeywords(
        keyword: "Bat",
        total: 4,
      ),
      CourseKeywords(
        keyword: "Banter",
        total: 100,
      ),
      CourseKeywords(
        keyword: "Bible",
        total: 2,
      ),
      CourseKeywords(
        keyword: "Boat",
        total: 16,
      ),
      CourseKeywords(
        keyword: "Bootstap",
        total: 6,
      ),
    ],
    'C': [],
    'D': [],
    'E': [],
    'F': [],
    'G': [],
    'H': [],
    'I': [],
    'J': [],
    'K': [],
    'L': [],
    'M': [],
    'N': [],
    'O': [],
    'P': [],
    'Q': [],
    'R': [],
    'S': [],
    'T': [],
    'U': [],
    'V': [],
    'W': [],
    'X': [],
    'Y': [],
    'Z': []
  };

  toggleKnowledgeTestMenus(BuildContext context, bool smallHeightDevice) {
    if (activeMenu != TestCategory.NONE) {
      sheetHeight = smallHeightDevice ? 510 : appHeight(context) * 0.56;
      activeMenu = TestCategory.NONE;
      sheetHeightIncreased = false;
      isActiveAnyMenu = false;
      isShowAlphaScroll = false;
    } else if (!isActiveAnyMenu || searchTap) {
      searchTap = false;
      sheetHeight = appHeight(context) * 0.90;
      activeMenu = TestCategory.TOPIC;
      if (sheetHeightIncreased) {
        isActiveAnyMenu = true;
      }
    }
    return isActiveAnyMenu;
  }

  knowledgeTestModalBottomSheet(
    context,
  ) async {
    searchKeywordController.text = searchKeyword.trim();
    searchTap = false;
    bool smallHeightDevice = appHeight(context) < 890 ? true : false;
    sheetHeight = smallHeightDevice ? 500 : appHeight(context) * 0.56;
    bool isActiveTopicMenu = false;

    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return ChangeNotifierProvider(
                create: (_) => KnowledgeTestControllerModel(),
                child: Consumer<KnowledgeTestControllerModel>(
                  builder: (context, model, child) {
                    return AnimatedContainer(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: sheetHeight,
                        onEnd: (() {
                          switch (activeMenu) {
                            case TestCategory.TOPIC:
                              isActiveTopicMenu = true;
                              isActiveAnyMenu = true;
                              sheetHeightIncreased = true;
                              break;
                            case TestCategory.MOCK:
                              isActiveAnyMenu = true;
                              break;
                            case TestCategory.EXAM:
                              isActiveAnyMenu = true;
                              break;
                            case TestCategory.ESSAY:
                              isActiveAnyMenu = true;
                              break;
                            case TestCategory.SAVED:
                              isActiveAnyMenu = true;
                              break;
                            case TestCategory.BANK:
                              isActiveAnyMenu = true;
                              break;
                            case TestCategory.NONE:
                              break;
                            default:
                              // sheetHeightIncreased = false;
                              break;
                          }
                          stateSetter(() {});
                        }),
                        decoration: BoxDecoration(
                          color: kAdeoGray4,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              color: Colors.grey,
                              height: 3,
                              width: 84,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Center(
                                      child: Image.asset(
                                    "assets/icons/courses/knowledge.png",
                                    width: 30,
                                    height: 30,
                                  )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: sText(
                                "Knowledge Test",
                                color: Colors.black,
                                weight: FontWeight.w400,
                                align: TextAlign.center,
                                size: 24,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: sText("Select your category",
                                      color: kAdeoGray3,
                                      weight: FontWeight.w400,
                                      align: TextAlign.center,
                                      size: 14),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  // height:
                                  constraints: BoxConstraints(
                                    maxHeight: smallHeightDevice && searchTap
                                        ? 600
                                        : isActiveAnyMenu
                                            ? 674
                                            : !smallHeightDevice && searchTap
                                                ? 660
                                                : 346,
                                  ),
                                  width: double.maxFinite,
                                  child: Column(
                                    children: [
                                      if (isActiveAnyMenu)
                                        TestTakenStatisticCard(
                                          course: Course(),
                                          showGraph: showGraph,
                                          activeMenu: activeMenu,
                                          knowledgeTestControllerModel: model,
                                          getTest: (
                                            BuildContext context,
                                            TestCategory testCategory,
                                            int currentQuestionCount,
                                          ) async {},
                                        ),
                                      if (!model
                                          .isShowAnalysisBox)
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                if (isActiveAnyMenu &&
                                                    keywordTestTaken.isNotEmpty)
                                                  Spacer(),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Dismissible(
                                                  key: UniqueKey(),
                                                  direction: DismissDirection
                                                      .horizontal,
                                                  confirmDismiss: (direction) {
                                                    if (isActiveAnyMenu) {
                                                      if (direction ==
                                                              DismissDirection
                                                                  .endToStart ||
                                                          direction ==
                                                              DismissDirection
                                                                  .startToEnd) {
                                                        stateSetter(
                                                          (() {
                                                            isShowAlphaScroll =
                                                                !isShowAlphaScroll;
                                                          }),
                                                        );
                                                      }
                                                    }
                                                    return Future.value(false);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      isShowAlphaScroll
                                                          ? AlphabetScrollSlider(
                                                              selectedAlphabet:
                                                                  "A",
                                                              callback:
                                                                  (selectedAlphabet) =>
                                                                      print(
                                                                          "Selected: $selectedAlphabet"),
                                                            )
                                                          : Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 0,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    searchKeywordController,
                                                                onChanged: (String
                                                                    value) async {},
                                                                onTap: () {
                                                                  stateSetter(
                                                                      () {
                                                                    if (isActiveAnyMenu) {
                                                                      activeMenu =
                                                                          TestCategory
                                                                              .NONE;
                                                                      isActiveAnyMenu =
                                                                          false;
                                                                    }
                                                                    sheetHeight =
                                                                        appHeight(context) *
                                                                            0.90;
                                                                    sheetHeightIncreased =
                                                                        true;
                                                                    searchTap =
                                                                        true;
                                                                  });
                                                                },
                                                                decoration:
                                                                    textDecorSuffix(
                                                                  fillColor: Color(
                                                                      0xFFEEEEEE),
                                                                  showBorder:
                                                                      false,
                                                                  size: 60,
                                                                  icon: IconButton(
                                                                      onPressed: () async {
                                                                        model.isShowAnalysisBox =
                                                                            !model.isShowAnalysisBox;
                                                                      },
                                                                      icon: Icon(
                                                                        Icons
                                                                            .search,
                                                                        color: Colors
                                                                            .grey,
                                                                      )),
                                                                  suffIcon:
                                                                      null,
                                                                  label:
                                                                      "Search Keywords",
                                                                  enabled: true,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                if (!searchTap) Spacer(),
                                                if (searchTap)
                                                  Expanded(
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 14.0,
                                                          top: 26,
                                                          bottom: 14,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SingleChildScrollView(
                                                              child: Container(
                                                                child: listQuestions
                                                                        .isEmpty
                                                                    ? Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          sText(
                                                                              "Most Popular",
                                                                              weight: FontWeight.w600),
                                                                          SizedBox(
                                                                            height:
                                                                                14,
                                                                          ),
                                                                          for (var entry
                                                                              in groupedCourseKeywordsLists.entries)
                                                                            if (entry.value.isNotEmpty)
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(entry.key),
                                                                                  for (int i = 0; i < entry.value.length; i++)
                                                                                    if (properCase("${entry.value[i].keyword}").isNotEmpty)
                                                                                      MaterialButton(
                                                                                        padding: EdgeInsets.zero,
                                                                                        onPressed: () async {},
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Row(
                                                                                              children: [
                                                                                                Icon(Icons.trending_up),
                                                                                                SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    sText("${properCase("${entry.value[i].keyword}")}", weight: FontWeight.bold),
                                                                                                    sText("${entry.value[i].total} appearances", size: 12, color: kAdeoGray3),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                ],
                                                                              )
                                                                        ],
                                                                      )
                                                                    : Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          sText(
                                                                              "Search Result",
                                                                              weight: FontWeight.w600),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          MaterialButton(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            onPressed:
                                                                                () async {
                                                                              // stateSetter(() {});
                                                                              // await getTest(context,
                                                                              //     TestCategory.NONE);
                                                                            },
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Icon(Icons.trending_up),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        sText("${properCase("")}", weight: FontWeight.bold),
                                                                                        sText("${listQuestions.length} appearances", size: 12, color: kAdeoGray3),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                              ),
                                                            ),
                                                            SingleChildScrollView(
                                                              child: Container(
                                                                child: Column(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .trending_up,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .numbers,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      if (listQuestions
                                                                          .isEmpty)
                                                                        for (var entry
                                                                            in groupedCourseKeywordsLists
                                                                                .entries)
                                                                          if (entry
                                                                              .value
                                                                              .isNotEmpty)
                                                                            Text(entry.key),
                                                                    ]),
                                                              ),
                                                            )
                                                          ],
                                                        )),
                                                  ),

                                                // MENUS
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: 14,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 20,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: kAdeoWhiteAlpha81,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  height: 240,
                                                  child: GridView.count(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    crossAxisCount: 3,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            "assets/icons/stethoscope.png",
                                                            height: 35.0,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          sText("Diagnostic ",
                                                              color:
                                                                  Colors.grey,
                                                              align: TextAlign
                                                                  .center,
                                                              size: 12),
                                                        ],
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          toggleKnowledgeTestMenus(
                                                            context,
                                                            smallHeightDevice,
                                                          );
                                                          stateSetter(() {});
                                                        },
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Stack(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icons/courses/topic.png",
                                                                  height: 35.0,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                sText(
                                                                  "Topic ",
                                                                  color: activeMenu ==
                                                                          TestCategory
                                                                              .TOPIC
                                                                      ? Color(
                                                                          0xFF003D6C)
                                                                      : Colors
                                                                          .grey,
                                                                  align: TextAlign
                                                                      .center,
                                                                  size: 12,
                                                                ),
                                                              ],
                                                            ),
                                                            if (activeMenu ==
                                                                TestCategory
                                                                    .TOPIC)
                                                              Positioned(
                                                                bottom: 20,
                                                                left: 0,
                                                                right: 0,
                                                                child:
                                                                    Container(
                                                                  height: 2,
                                                                  width: 46,
                                                                  color: Color(
                                                                      0xFF003D6C),
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          // getTest(context, TestCategory.EXAM);
                                                        },
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Stack(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icons/courses/exam.png",
                                                                  height: 35.0,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                sText("Exam ",
                                                                    color: activeMenu ==
                                                                            TestCategory
                                                                                .EXAM
                                                                        ? Color(
                                                                            0xFF003D6C)
                                                                        : Colors
                                                                            .grey,
                                                                    align: TextAlign
                                                                        .center,
                                                                    size: 12),
                                                              ],
                                                            ),
                                                            if (activeMenu ==
                                                                TestCategory
                                                                    .EXAM)
                                                              Positioned(
                                                                bottom: 20,
                                                                left: 0,
                                                                right: 0,
                                                                child:
                                                                    Container(
                                                                  height: 2,
                                                                  width: 46,
                                                                  color: Color(
                                                                      0xFF003D6C),
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          // getTest(context, TestCategory.BANK);
                                                        },
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Center(
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icons/courses/bank.png",
                                                                  height: 35.0,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                sText("Bank",
                                                                    color: Colors
                                                                        .grey,
                                                                    align: TextAlign
                                                                        .center,
                                                                    size: 12),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          // getTest(context, TestCategory.SAVED);
                                                        },
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Container(
                                                          // padding: EdgeInsets.only(
                                                          //     top: 10, bottom: 10, left: 0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/courses/saved.png",
                                                                height: 35.0,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              sText("Saved",
                                                                  color: Colors
                                                                      .grey,
                                                                  align: TextAlign
                                                                      .center,
                                                                  size: 12),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          // getTest(context, TestCategory.ESSAY);
                                                        },
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icons/courses/essay.png",
                                                                height: 35.0,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              sText(
                                                                "Essay",
                                                                color:
                                                                    Colors.grey,
                                                                align: TextAlign
                                                                    .center,
                                                                size: 12,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ));
                  },
                ),
              );
            },
          );
        });
  }
}
