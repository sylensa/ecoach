import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/revamp/features/knowledge_tests/components/test_taken_statistics_card.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class KnowledgeTestController {
  TextEditingController searchKeywordController = TextEditingController();
  String searchKeyword = '';
  bool searchTap = false;
  bool showGraph = false;
  List<CourseKeywords> listCourseKeywordsData = [];
  List<Question> listQuestions = [];

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

  knowledgeTestModalBottomSheet(
    context,
  ) async {
    // if (listCourseKeywordsData.isNotEmpty) {
    //   groupedCourseKeywordsLists = {
    //     'A': [],
    //     'B': [],
    //     'C': [],
    //     'D': [],
    //     'E': [],
    //     'F': [],
    //     'G': [],
    //     'H': [],
    //     'I': [],
    //     'J': [],
    //     'K': [],
    //     'L': [],
    //     'M': [],
    //     'N': [],
    //     'O': [],
    //     'P': [],
    //     'Q': [],
    //     'R': [],
    //     'S': [],
    //     'T': [],
    //     'U': [],
    //     'V': [],
    //     'W': [],
    //     'X': [],
    //     'Y': [],
    //     'Z': []
    //   };
    // } else {
    //   groupedCourseKeywordsLists.clear();
    // }
    searchKeywordController.text = searchKeyword.trim();
    searchTap = false;
    double sheetHeight = appHeight(context) * 0.56;
    bool isActiveTopicMenu = false;
    bool sheetHeightIncreased = false;
    late TestCategory activeMenu = TestCategory.NONE;

    // listCourseKeywordsData.forEach((courseKeyword) {
    //   if (groupedCourseKeywordsLists[
    //           '${courseKeyword.keyword![0]}'.toUpperCase()] ==
    //       null) {
    //     groupedCourseKeywordsLists[
    //         '${courseKeyword.keyword![0]}'.toUpperCase()] = <CourseKeywords>[];
    //   }
    //   groupedCourseKeywordsLists['${courseKeyword.keyword![0]}'.toUpperCase()]!
    //       .add(courseKeyword);
    // });

    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return AnimatedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: sheetHeight,
                  onEnd: (() {
                    switch (activeMenu) {
                      case TestCategory.TOPIC:
                        isActiveTopicMenu = true;
                        sheetHeightIncreased = true;
                        break;
                      case TestCategory.MOCK:
                        break;
                      case TestCategory.EXAM:
                        break;
                      case TestCategory.ESSAY:
                        break;
                      case TestCategory.SAVED:
                        break;
                      case TestCategory.BANK:
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
                          if (showGraph)
                            GestureDetector(
                              onTap: () {
                                stateSetter(() {
                                  if (showGraph) {
                                    showGraph = false;
                                  } else {
                                    showGraph = true;
                                  }
                                });
                              },
                              child: Image.asset(
                                "assets/images/pencil.png",
                                height: 20,
                              ),
                            ),
                        ],
                      ),

                      if (isActiveTopicMenu)
                        TestTakenStatisticCard(
                          course: Course(),
                          showGraph: showGraph,
                          activeMenu: activeMenu,
                          getTest: (
                            BuildContext context,
                            TestCategory testCategory,
                            int currentQuestionCount,
                          ) async {
                            // await getTest(
                            //   context,
                            //   testCategory,
                            //   currentQuestionCount: currentQuestionCount,
                            // );
                          },
                        ),
                      if (isActiveTopicMenu && keywordTestTaken.isNotEmpty)
                        Spacer(),
                      // Container(
                      //   height: 50,
                      //   child: ListView.builder(
                      //     padding:
                      //         EdgeInsets.only(left: 0, right: 0),
                      //     shrinkWrap: true,
                      //     itemCount: keywordTestTaken.length,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder:
                      //         (BuildContext context, int index) {
                      //       return Container(
                      //         width: 10,
                      //         height: 10,
                      //         margin: EdgeInsets.only(right: 5),
                      //         decoration: BoxDecoration(
                      //             color: _currentSlide == index
                      //                 ? Color(0xFF2A9CEA)
                      //                 : sGray,
                      //             shape: BoxShape.circle),
                      //       );
                      //     },
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                        child: TextFormField(
                          controller: searchKeywordController,
                          onChanged: (String value) async {
                            // stateSetter(() {
                            //   searchKeyword = value.trim();
                            //   listQuestions.clear();
                            // });

                            // if (searchKeyword.isNotEmpty) {
                            //   for (int i = 0;
                            //       i < keywordTestTaken.length;
                            //       i++) {
                            //     if (keywordTestTaken[i]
                            //             .testname!
                            //             .toLowerCase() ==
                            //         searchKeyword.toLowerCase()) {
                            //       listQuestions = await TestController()
                            //           .getKeywordQuestions(
                            //               searchKeyword.toLowerCase(),
                            //               widget.course.id!,
                            //               currentQuestionCount:
                            //                   keywordTestTaken[i].correct! +
                            //                       keywordTestTaken[i].wrong!);
                            //       stateSetter(() {});
                            //       return;
                            //     }
                            //   }
                            // }
                            // if (searchKeyword.isNotEmpty) {
                            //   listQuestions = await TestController()
                            //       .getKeywordQuestions(
                            //           searchKeyword.toLowerCase(),
                            //           widget.course.id!,
                            //           currentQuestionCount: 0);
                            // }
                            // stateSetter(() {});
                          },
                          onTap: () {
                            if (activeMenu != TestCategory.NONE)
                              activeMenu = TestCategory.NONE;
                            sheetHeight = appHeight(context) * 0.90;
                            sheetHeightIncreased = true;
                            isActiveTopicMenu = false;
                            searchTap = true;
                            stateSetter(() {});
                          },
                          decoration: textDecorSuffix(
                            fillColor: Color(0xFFEEEEEE),
                            showBorder: false,
                            size: 60,
                            icon: IconButton(
                                onPressed: () async {
                                  // await getTest(
                                  //   context,
                                  //   TestCategory.NONE,
                                  // );
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                )),
                            suffIcon: null,
                            label: "Search Keywords",
                            enabled: true,
                          ),
                        ),
                      ),

                      if (!searchTap) Spacer(),
                      if (searchTap)
                        Expanded(
                          child: Container(
                              child: Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 14.0,
                              top: 26,
                              bottom: 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  child: Container(
                                    child: listQuestions.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              sText("Most Popular",
                                                  weight: FontWeight.w600),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              for (var entry
                                                  in groupedCourseKeywordsLists
                                                      .entries)
                                                if (entry.value.isNotEmpty)
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(entry.key),
                                                      for (int i = 0;
                                                          i <
                                                              entry
                                                                  .value.length;
                                                          i++)
                                                        if (properCase(
                                                                "${entry.value[i].keyword}")
                                                            .isNotEmpty)
                                                          MaterialButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed:
                                                                () async {},
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(Icons
                                                                        .trending_up),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        sText(
                                                                            "${properCase("${entry.value[i].keyword}")}",
                                                                            weight:
                                                                                FontWeight.bold),
                                                                        sText(
                                                                            "${entry.value[i].total} appearances",
                                                                            size:
                                                                                12,
                                                                            color:
                                                                                kAdeoGray3),
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
                                              sText("Search Result",
                                                  weight: FontWeight.w600),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  // stateSetter(() {});
                                                  // await getTest(context,
                                                  //     TestCategory.NONE);
                                                },
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.trending_up),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            sText(
                                                                "${properCase("$searchKeyword")}",
                                                                weight:
                                                                    FontWeight
                                                                        .bold),
                                                            sText(
                                                                "${listQuestions.length} appearances",
                                                                size: 12,
                                                                color:
                                                                    kAdeoGray3),
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
                                Container(
                                  child: Column(children: [
                                    Icon(
                                      Icons.trending_up,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Icon(
                                      Icons.numbers,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    if (listQuestions.isEmpty)
                                      for (var entry
                                          in groupedCourseKeywordsLists.entries)
                                        if (entry.value.isNotEmpty)
                                          Text(entry.key),
                                  ]),
                                )
                              ],
                            ),
                          )),
                        ),
                      if (!searchTap && !keywordTestTaken.isNotEmpty) Spacer(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 14,
                          left: 10,
                          right: 10,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: kAdeoWhiteAlpha81,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 240,
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/stethoscope.png",
                                  height: 35.0,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                sText("Diagnostic ",
                                    color: Colors.grey,
                                    align: TextAlign.center,
                                    size: 12),
                              ],
                            ),
                            MaterialButton(
                              onPressed: () {
                                // getTest(context, TestCategory.TOPIC);
                                if (isActiveTopicMenu) {
                                  sheetHeight = appHeight(context) * 0.55;
                                  activeMenu = TestCategory.NONE;
                                  sheetHeightIncreased = false;
                                  if (!sheetHeightIncreased)
                                    isActiveTopicMenu = false;
                                } else if (!isActiveTopicMenu || searchTap) {
                                  if (searchTap) searchTap = false;
                                  sheetHeight = appHeight(context) * 0.90;
                                  activeMenu = TestCategory.TOPIC;
                                  if (sheetHeightIncreased)
                                    isActiveTopicMenu = true;
                                }

                                stateSetter(() {});
                              },
                              padding: EdgeInsets.zero,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        color: activeMenu == TestCategory.TOPIC
                                            ? Color(0xFF003D6C)
                                            : Colors.grey,
                                        align: TextAlign.center,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                  if (activeMenu == TestCategory.TOPIC)
                                    Positioned(
                                      bottom: 20,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 2,
                                        width: 46,
                                        color: Color(0xFF003D6C),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                // getTest(context, TestCategory.EXAM);
                              },
                              padding: EdgeInsets.zero,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/courses/exam.png",
                                        height: 35.0,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      sText("Exam ",
                                          color: activeMenu == TestCategory.EXAM
                                              ? Color(0xFF003D6C)
                                              : Colors.grey,
                                          align: TextAlign.center,
                                          size: 12),
                                    ],
                                  ),
                                  if (activeMenu == TestCategory.EXAM)
                                    Positioned(
                                      bottom: 20,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 2,
                                        width: 46,
                                        color: Color(0xFF003D6C),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                // getTest(context, TestCategory.BANK);
                              },
                              padding: EdgeInsets.zero,
                              child: Center(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/courses/bank.png",
                                        height: 35.0,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      sText("Bank",
                                          color: Colors.grey,
                                          align: TextAlign.center,
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
                              padding: EdgeInsets.zero,
                              child: Container(
                                // padding: EdgeInsets.only(
                                //     top: 10, bottom: 10, left: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/courses/saved.png",
                                      height: 35.0,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    sText("Saved",
                                        color: Colors.grey,
                                        align: TextAlign.center,
                                        size: 12),
                                  ],
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                // getTest(context, TestCategory.ESSAY);
                              },
                              padding: EdgeInsets.zero,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      color: Colors.grey,
                                      align: TextAlign.center,
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
                  ));
            },
          );
        });
  }
}
