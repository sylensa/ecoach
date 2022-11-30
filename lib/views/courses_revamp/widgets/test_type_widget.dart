import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/performance_gragh.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/database/conquest_test_taken_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_introit.dart';
import 'package:ecoach/views/conquest/conquest_onboarding.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/keyword/keyword_assessment.dart';
import 'package:ecoach/views/keyword/keyword_graph.dart';
import 'package:ecoach/views/keyword/keyword_quiz_cover.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/review/review_onboarding.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/speed/speed_quiz_cover.dart';
import 'package:ecoach/views/test/test_challenge_list.dart';
import 'package:ecoach/views/test/test_type_list.dart';
import 'package:ecoach/views/treadmill/treadmill_save_resumption_menu.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TestTypeWidget extends StatefulWidget {
  TestTypeWidget(
      {Key? key,
      required this.course,
      required this.user,
      required this.subscription,
      required this.controller,
      required this.listCourseKeywordsData})
      : super(key: key);
  Course course;
  User user;
  Plan subscription;
  List<CourseKeywords> listCourseKeywordsData;
  final MainController controller;

  @override
  State<TestTypeWidget> createState() => _TestTypeWidgetState();
}

class _TestTypeWidgetState extends State<TestTypeWidget> {
  String selectedConquestType = '';
  String searchKeyword = '';
  List<Question> listQuestions = [];
  bool searchTap = false;
  TestType testType = TestType.NONE;
  int _currentSlide = 0;
  bool progressCodeAll = true;
  bool showGraph = false;
  List listReportData = [true];
  TextEditingController searchKeywordController = TextEditingController();
  Map<String, List<CourseKeywords>> groupedCourseKeywordsLists = {
    'A': [],
    'B': [],
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

  List<T> map<T>(int listLength, Function handler) {
    List list = [];
    for (var i = 0; i < listLength; i++) {
      list.add(i);
    }
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  List<ListNames> conquestTypes = [
    ListNames(name: "Unseen", id: "1"),
    ListNames(name: "Unanswered", id: "2"),
    ListNames(name: "Wrong answered", id: "3"),
  ];
  getTest(BuildContext context, TestCategory testCategory,
      {int currentQuestionCount = 0}) {
    Future futureList;
    switch (testCategory) {
      case TestCategory.MOCK:
        Question? q;
        futureList = TestController().getMockTests(widget.course);
        break;
      case TestCategory.EXAM:
        futureList = TestController().getExamTests(widget.course);
        break;
      case TestCategory.TOPIC:
        futureList = TestController().getTopics(widget.course);
        break;
      case TestCategory.ESSAY:
        // futureList = TestController().getEssays(course, 5);
        futureList = TestController().getEssayTests(widget.course);
        break;
      case TestCategory.SAVED:
        futureList = TestController().getSavedTests(widget.course, limit: 10);
        break;
      case TestCategory.BANK:
        futureList = TestController().getBankTest(widget.course);
        break;
      case TestCategory.NONE:
        for (int i = 0; i < keywordTestTaken.length; i++) {
          if (keywordTestTaken[i].testname!.toLowerCase() ==
              searchKeyword.toLowerCase()) {
            futureList = TestController().getKeywordQuestions(
                searchKeyword.toLowerCase(), widget.course.id!,
                currentQuestionCount:
                    keywordTestTaken[i].correct! + keywordTestTaken[i].wrong!);
            futureList.then(
              (data) async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      Widget? widgetView;
                      switch (testCategory) {
                        case TestCategory.MOCK:
                          List<Question> questions = data as List<Question>;
                          widgetView = testType == TestType.SPEED
                              ? SpeedQuizCover(
                                  widget.user,
                                  testType,
                                  questions,
                                  course: widget.course,
                                  theme: QuizTheme.ORANGE,
                                  category: testCategory,
                                  time: questions.length * 60,
                                  name: "Mock Test",
                                )
                              : QuizCover(
                                  widget.user,
                                  questions,
                                  course: widget.course,
                                  type: testType,
                                  theme: QuizTheme.BLUE,
                                  category: testCategory,
                                  time: questions.length * 60,
                                  name: "Mock Test",
                                );
                          break;
                        case TestCategory.EXAM:
                          widgetView = TestTypeListView(
                            widget.user,
                            widget.course,
                            data,
                            testType,
                            title: "Exams",
                            testCategory: TestCategory.EXAM,
                          );
                          break;
                        case TestCategory.TOPIC:
                          widgetView = TestTypeListView(
                            widget.user,
                            widget.course,
                            data,
                            testType,
                            title: "Topic",
                            multiSelect: true,
                            testCategory: TestCategory.TOPIC,
                          );
                          break;
                        case TestCategory.ESSAY:
                          widgetView = TestTypeListView(
                            widget.user,
                            widget.course,
                            data,
                            testType,
                            title: "Essays",
                            testCategory: TestCategory.ESSAY,
                          );
                          break;
                        case TestCategory.SAVED:
                          List<Question> questions = data as List<Question>;
                          widgetView = QuizCover(
                            widget.user,
                            questions,
                            category: testCategory,
                            course: widget.course,
                            theme: QuizTheme.BLUE,
                            time: questions.length * 60,
                            name: "Saved Test",
                          );
                          break;
                        case TestCategory.NONE:
                          List<Question> questions = data as List<Question>;

                          widgetView = KeywordAssessment(
                            quizCover: KeywordQuizCover(
                              widget.user,
                              questions,
                              category: testCategory,
                              course: widget.course,
                              theme: QuizTheme.BLUE,
                              time: questions.length * 60,
                              name: searchKeyword,
                            ),
                            questionCount: questions.length,
                          );
                          break;
                        case TestCategory.BANK:
                          widgetView = TestTypeListView(
                            widget.user,
                            widget.course,
                            data,
                            testType,
                            title: "Bank",
                            testCategory: TestCategory.BANK,
                          );
                          break;
                        default:
                          widgetView = null;
                      }
                      return widgetView!;
                    },
                  ),
                );
              },
            );
            return;
          }
        }
        futureList = TestController().getKeywordQuestions(
            searchKeyword.toLowerCase(), widget.course.id!,
            currentQuestionCount: currentQuestionCount);

        break;
      default:
        futureList = TestController().getBankTest(widget.course);
    }

    futureList.then(
      (data) async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              Widget? widgetView;
              switch (testCategory) {
                case TestCategory.MOCK:
                  List<Question> questions = data as List<Question>;
                  widgetView = testType == TestType.SPEED
                      ? SpeedQuizCover(
                          widget.user,
                          testType,
                          questions,
                          course: widget.course,
                          theme: QuizTheme.ORANGE,
                          category: testCategory,
                          time: questions.length * 60,
                          name: "Mock Test",
                        )
                      : QuizCover(
                          widget.user,
                          questions,
                          course: widget.course,
                          type: testType,
                          theme: QuizTheme.BLUE,
                          category: testCategory,
                          time: questions.length * 60,
                          name: "Mock Test",
                        );
                  break;
                case TestCategory.EXAM:
                  widgetView = TestTypeListView(
                    widget.user,
                    widget.course,
                    data,
                    testType,
                    title: "Exams",
                    testCategory: TestCategory.EXAM,
                  );
                  break;
                case TestCategory.TOPIC:
                  widgetView = TestTypeListView(
                    widget.user,
                    widget.course,
                    data,
                    testType,
                    title: "Topic",
                    multiSelect: true,
                    testCategory: TestCategory.TOPIC,
                  );
                  break;
                case TestCategory.ESSAY:
                  widgetView = TestTypeListView(
                    widget.user,
                    widget.course,
                    data,
                    testType,
                    title: "Essays",
                    testCategory: TestCategory.ESSAY,
                  );
                  break;
                case TestCategory.SAVED:
                  List<Question> questions = data as List<Question>;
                  widgetView = QuizCover(
                    widget.user,
                    questions,
                    category: testCategory,
                    course: widget.course,
                    theme: QuizTheme.BLUE,
                    time: questions.length * 60,
                    name: "Saved Test",
                  );
                  break;
                case TestCategory.NONE:
                  List<Question> questions = data as List<Question>;

                  widgetView = KeywordAssessment(
                    quizCover: KeywordQuizCover(
                      widget.user,
                      questions,
                      category: testCategory,
                      course: widget.course,
                      theme: QuizTheme.BLUE,
                      time: questions.length * 60,
                      name: searchKeyword,
                    ),
                    questionCount: questions.length,
                  );
                  break;
                case TestCategory.BANK:
                  widgetView = TestTypeListView(
                    widget.user,
                    widget.course,
                    data,
                    testType,
                    title: "Bank",
                    testCategory: TestCategory.BANK,
                  );
                  break;
                default:
                  widgetView = null;
              }
              return widgetView!;
            },
          ),
        );
      },
    );
  }

  conquestModalBottomSheet(
    context,
  ) {
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: Image.asset("assets/images/flag.png")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Conquest",
                            color: kAdeoGray3,
                            weight: FontWeight.bold,
                            align: TextAlign.center,
                            size: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: conquestTypes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MaterialButton(
                                  onPressed: () async {
                                    showLoaderDialog(context);
                                    List<Question> listQuestions = [];
                                    if (conquestTypes[index]
                                            .name
                                            .toUpperCase() ==
                                        "UNSEEN") {
                                      testType = TestType.UNSEEN;
                                      listQuestions = await QuestionDB()
                                          .getConquestQuestionByCorrectUnAttempted(
                                              widget.course.id!,
                                              confirm: 0,
                                              unseen: true);
                                      print(
                                          "listQuestions:${listQuestions.length}");
                                      // if(listQuestions.isEmpty){
                                      //   listQuestions = await QuestionDB().getQuestionsByCourseId(widget.course.id!);
                                      //   print("$testType:$listQuestions");
                                      // }
                                    } else if (conquestTypes[index]
                                            .name
                                            .toUpperCase() ==
                                        "UNANSWERED") {
                                      testType = TestType.UNANSWERED;
                                      listQuestions = await QuestionDB()
                                          .getConquestQuestionByCorrectUnAttempted(
                                        widget.course.id!,
                                        confirm: 0,
                                      );
                                      print("$testType:$listQuestions");
                                    } else {
                                      testType = TestType.WRONGLYANSWERED;
                                      listQuestions = await QuestionDB()
                                          .getConquestQuestionByCorrectUnAttempted(
                                              widget.course.id!,
                                              confirm: 1);
                                      print("$testType:$listQuestions");
                                    }
                                    stateSetter(() {
                                      selectedConquestType =
                                          conquestTypes[index].name;
                                    });
                                    Navigator.pop(context);
                                    goTo(
                                        context,
                                        ConquestOnBoarding(
                                          user: widget.user,
                                          course: widget.course,
                                          testType: testType,
                                          listQuestions: listQuestions,
                                        ));
                                  },
                                  child: Container(
                                    width: appWidth(context),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: selectedConquestType ==
                                                conquestTypes[index].name
                                            ? Color(0XFFFD6363)
                                            : Colors.white,
                                        border: Border.all(
                                            color: selectedConquestType ==
                                                    conquestTypes[index].name
                                                ? Colors.transparent
                                                : Colors.black,
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: sText("${conquestTypes[index].name}",
                                        color: selectedConquestType ==
                                                conquestTypes[index].name
                                            ? Colors.white
                                            : Colors.black,
                                        weight: FontWeight.w500,
                                        align: TextAlign.center),
                                  ),
                                );
                              })),
                    ],
                  ));
            },
          );
        });
  }

  knowledgeTestModalBottomSheet(
    context,
  ) async {
    if (widget.listCourseKeywordsData.isNotEmpty) {
      groupedCourseKeywordsLists = {
        'A': [],
        'B': [],
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
    } else {
      groupedCourseKeywordsLists.clear();
    }

    searchKeywordController.text = searchKeyword;
    setState(() {});
    searchTap = true;
    double sheetHeight = appHeight(context) * 0.56;
    widget.listCourseKeywordsData.forEach((courseKeyword) {
      if (groupedCourseKeywordsLists[
              '${courseKeyword.keyword![0]}'.toUpperCase()] ==
          null) {
        groupedCourseKeywordsLists[
            '${courseKeyword.keyword![0]}'.toUpperCase()] = <CourseKeywords>[];
      }
      groupedCourseKeywordsLists['${courseKeyword.keyword![0]}'.toUpperCase()]!
          .add(courseKeyword);
    });
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              // if (searchTap && keywordTestTaken.isNotEmpty) {
              //   sheetHeight += 320;
              // }

              return AnimatedContainer(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: sheetHeight,
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
                      // if (searchTap && keywordTestTaken.isNotEmpty)

                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       SizedBox(
                      //         height: 20,
                      //       ),
                      //       CarouselSlider.builder(
                      //         options: CarouselOptions(
                      //           height: showGraph ? 200 : 300,
                      //           autoPlay: false,
                      //           enableInfiniteScroll: false,
                      //           autoPlayAnimationDuration: Duration(seconds: 1),
                      //           enlargeCenterPage: false,
                      //           viewportFraction: 1,
                      //           aspectRatio: 2.0,
                      //           pageSnapping: true,
                      //           onPageChanged: (index, reason) {
                      //             setState(() {
                      //               _currentSlide = index;
                      //             });
                      //           },
                      //         ),
                      //         itemCount: keywordTestTaken.length,
                      //         itemBuilder: (BuildContext context,
                      //             int indexReport, int index2) {
                      //           if (showGraph) {
                      //             return MaterialButton(
                      //               onPressed: () {
                      //                 stateSetter(() {
                      //                   showGraph = false;
                      //                 });
                      //               },
                      //               child: KeywordGraph(
                      //                 course: widget.course,
                      //                 keyword: keywordTestTaken[indexReport]
                      //                     .testname!,
                      //                 changeState: true,
                      //               ),
                      //             );
                      //           } else {
                      //             return Container(
                      //               padding: EdgeInsets.all(26),
                      //               margin: EdgeInsets.symmetric(
                      //                 horizontal: 10,
                      //               ),
                      //               decoration: BoxDecoration(
                      //                 image: DecorationImage(
                      //                   image: AssetImage(
                      //                       "assets/images/oval-pattern.png"),
                      //                   fit: BoxFit.cover,
                      //                 ),
                      //                 color: Color(0XFF0ff0364AE),
                      //                 gradient: LinearGradient(
                      //                   begin: Alignment.topCenter,
                      //                   end: Alignment.bottomCenter,
                      //                   colors: <Color>[
                      //                     Color(0xFF0364AE),
                      //                     Color(0xFF023760),
                      //                   ],
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(24),
                      //               ),
                      //               child: Column(
                      //                 mainAxisSize: MainAxisSize.max,
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       Container(
                      //                         child: Column(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment
                      //                                   .spaceBetween,
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.start,
                      //                           children: [
                      //                             Row(
                      //                               children: [
                      //                                 Container(
                      //                                   padding:
                      //                                       EdgeInsets.all(5),
                      //                                   child: Icon(
                      //                                     Icons.trending_up,
                      //                                     color: Colors.black,
                      //                                   ),
                      //                                   decoration: BoxDecoration(
                      //                                       color: Colors.white,
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(
                      //                                                   8),
                      //                                       shape: BoxShape
                      //                                           .rectangle),
                      //                                 ),
                      //                                 SizedBox(
                      //                                   width: 12,
                      //                                 ),
                      //                                 sText(
                      //                                   "${properCase(keywordTestTaken[indexReport].testname!)}",
                      //                                   color: Colors.white,
                      //                                   weight: FontWeight.bold,
                      //                                   size: 16,
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                       Container(
                      //                         child: Column(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment
                      //                                   .spaceBetween,
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.end,
                      //                           children: [
                      //                             Row(
                      //                               children: [
                      //                                 keywordTestTaken[
                      //                                                 indexReport]
                      //                                             .scoreDiff! >
                      //                                         0
                      //                                     ? Image.asset(
                      //                                         "assets/images/un_fav.png",
                      //                                         color:
                      //                                             Colors.green,
                      //                                         width: 25,
                      //                                       )
                      //                                     : SvgPicture.asset(
                      //                                         "assets/images/fav.svg",
                      //                                         width: 25,
                      //                                       ),
                      //                                 SizedBox(
                      //                                   width: 12,
                      //                                 ),
                      //                                 sText(
                      //                                   "${keywordTestTaken[indexReport].scoreDiff! > 0 ? "+" : ""}${keywordTestTaken[indexReport].scoreDiff!}",
                      //                                   color: Colors.white,
                      //                                   weight: FontWeight.bold,
                      //                                   size: 16,
                      //                                 )
                      //                               ],
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   SizedBox(
                      //                     height: 28,
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       Column(
                      //                         children: [
                      //                           sText(
                      //                             "${keywordTestTaken[indexReport].total_test_taken}",
                      //                             size: 34,
                      //                             weight: FontWeight.w600,
                      //                             color: Colors.white,
                      //                           ),
                      //                           SizedBox(
                      //                             height: 6,
                      //                           ),
                      //                           sText(
                      //                             "times taken",
                      //                             size: 12,
                      //                             color: Colors.white
                      //                                 .withOpacity(0.7),
                      //                             weight: FontWeight.w300,
                      //                             style: FontStyle.italic,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       Column(
                      //                         children: [
                      //                           sText(
                      //                             "${keywordTestTaken[indexReport].score!.round()}%",
                      //                             size: 34,
                      //                             weight: FontWeight.w600,
                      //                             color: Colors.white,
                      //                           ),
                      //                           SizedBox(
                      //                             height: 6,
                      //                           ),
                      //                           sText(
                      //                             "mastery",
                      //                             size: 12,
                      //                             color: Colors.white
                      //                                 .withOpacity(0.7),
                      //                             weight: FontWeight.w300,
                      //                             style: FontStyle.italic,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       Container(
                      //                         child: Column(
                      //                           children: [
                      //                             AdeoSignalStrengthIndicator(
                      //                               strength: keywordTestTaken[
                      //                                       indexReport]
                      //                                   .score!,
                      //                               size: Sizes.small,
                      //                             ),
                      //                             SizedBox(
                      //                               height: 26,
                      //                             ),
                      //                             sText(
                      //                               "strength",
                      //                               size: 12,
                      //                               color: Colors.white
                      //                                   .withOpacity(0.7),
                      //                               weight: FontWeight.w300,
                      //                               style: FontStyle.italic,
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   SizedBox(
                      //                     height: 20,
                      //                   ),
                      //                   Container(
                      //                     clipBehavior: Clip.hardEdge,
                      //                     decoration: BoxDecoration(
                      //                       borderRadius:
                      //                           BorderRadius.circular(12),
                      //                     ),
                      //                     child: LinearProgressIndicator(
                      //                       color: Color(0XFF00C9B9),
                      //                       backgroundColor: Color(0XFF0367B4),
                      //                       value: (keywordTestTaken[
                      //                                       indexReport]
                      //                                   .correct! +
                      //                               keywordTestTaken[
                      //                                       indexReport]
                      //                                   .wrong!) /
                      //                           keywordTestTaken[indexReport]
                      //                               .totalQuestions,
                      //                     ),
                      //                   ),
                      //                   SizedBox(
                      //                     height: 10,
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       sText(
                      //                         "exposure",
                      //                         size: 12,
                      //                         color:
                      //                             Colors.white.withOpacity(0.7),
                      //                         weight: FontWeight.w300,
                      //                         style: FontStyle.italic,
                      //                       ),
                      //                       Row(
                      //                         children: [
                      //                           sText(
                      //                             "${keywordTestTaken[indexReport].correct! + keywordTestTaken[indexReport].wrong!}",
                      //                             color: Colors.white,
                      //                             weight: FontWeight.bold,
                      //                             size: 12,
                      //                           ),
                      //                           sText(
                      //                             " / ${keywordTestTaken[indexReport].totalQuestions} Q",
                      //                             color: Colors.white
                      //                                 .withOpacity(0.7),
                      //                             size: 12,
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   SizedBox(
                      //                     height: 24,
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       GestureDetector(
                      //                         onTap: () {
                      //                           stateSetter(() {
                      //                             if (showGraph) {
                      //                               showGraph = false;
                      //                             } else {
                      //                               showGraph = true;
                      //                             }
                      //                           });
                      //                         },
                      //                         child: Image.asset(
                      //                             "assets/images/pencil.png"),
                      //                       ),
                      //                       Spacer(),
                      //                       GestureDetector(
                      //                         onTap: () async {
                      //                           stateSetter(() {
                      //                             searchKeyword =
                      //                                 keywordTestTaken[
                      //                                         indexReport]
                      //                                     .testname!
                      //                                     .toLowerCase();
                      //                           });
                      //                           await getTest(
                      //                               context, TestCategory.NONE,
                      //                               currentQuestionCount:
                      //                                   keywordTestTaken[
                      //                                               indexReport]
                      //                                           .correct! +
                      //                                       keywordTestTaken[
                      //                                               indexReport]
                      //                                           .wrong!);
                      //                         },
                      //                         child: Container(
                      //                           padding: EdgeInsets.symmetric(
                      //                             horizontal: 20,
                      //                             vertical: 14,
                      //                           ),
                      //                           child: sText(
                      //                             "Take Test",
                      //                             color: Colors.white,
                      //                           ),
                      //                           decoration: BoxDecoration(
                      //                             color: kAdeoGreen4,
                      //                             borderRadius:
                      //                                 BorderRadius.circular(8),
                      //                           ),
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           }
                      //         },
                      //       ),
                      //     ],
                      //   ),

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
                            stateSetter(() {
                              searchKeyword = value.trim();
                              listQuestions.clear();
                            });
                            if (searchKeyword.isNotEmpty) {
                              for (int i = 0;
                                  i < keywordTestTaken.length;
                                  i++) {
                                if (keywordTestTaken[i]
                                        .testname!
                                        .toLowerCase() ==
                                    searchKeyword.toLowerCase()) {
                                  listQuestions = await TestController()
                                      .getKeywordQuestions(
                                          searchKeyword.toLowerCase(),
                                          widget.course.id!,
                                          currentQuestionCount:
                                              keywordTestTaken[i].correct! +
                                                  keywordTestTaken[i].wrong!);
                                  stateSetter(() {});
                                  return;
                                }
                              }
                            }
                            if (searchKeyword.isNotEmpty) {
                              listQuestions = await TestController()
                                  .getKeywordQuestions(
                                      searchKeyword.toLowerCase(),
                                      widget.course.id!,
                                      currentQuestionCount: 0);
                            }
                            stateSetter(() {});
                          },
                          onTap: () {
                            stateSetter(() {
                              sheetHeight = appHeight(context) * 0.90;
                              searchTap = false;
                            });
                          },
                          decoration: textDecorSuffix(
                            fillColor: Color(0xFFEEEEEE),
                            showBorder: false,
                            size: 60,
                            icon: IconButton(
                                onPressed: () async {
                                  await getTest(
                                    context,
                                    TestCategory.NONE,
                                  );
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

                      if (!searchTap)
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            top: 26,
                            bottom: 14,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: SingleChildScrollView(
                                    child: listQuestions.isEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 20.0, right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    sText("Most Popular",
                                                        weight:
                                                            FontWeight.w600),
                                                    Column(children: [
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
                                                      sText("")
                                                    ]),
                                                  ],
                                                ),
                                              ),
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
                                                      // Text(entry.key),
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
                                                                () async {
                                                              stateSetter(() {
                                                                searchKeyword =
                                                                    "${entry.value[i].keyword}";
                                                              });
                                                              await getTest(
                                                                  context,
                                                                  TestCategory
                                                                      .NONE);
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    left: 20.0,
                                                                    right: 0.0,
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons
                                                                          .trending_up),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                appWidth(context) * 0.75,
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                sText("${properCase("${entry.value[i].keyword}")}", weight: FontWeight.bold),
                                                                                Expanded(child: Container()),
                                                                                if (i == 0) Text(entry.key),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          sText(
                                                                              "${entry.value[i].total} appearances",
                                                                              size: 12,
                                                                              color: kAdeoGray3),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
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
                                        : Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    sText("Search Result",
                                                        weight:
                                                            FontWeight.w600),
                                                    Column(children: [
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
                                                    ]),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                MaterialButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () async {
                                                    stateSetter(() {});
                                                    await getTest(context,
                                                        TestCategory.NONE);
                                                  },
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
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          sText(
                                                              searchKeyword
                                                                      .isNotEmpty
                                                                  ? "${searchKeyword.split('').first.toUpperCase()}"
                                                                  : "",
                                                              color:
                                                                  Colors.black)
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(
                              //     right: 20.0,
                              //
                              //   ),
                              //   child: Column(children: [
                              //     Expanded(
                              //       child: SingleChildScrollView(
                              //         child: Column(children: [
                              //           Icon(
                              //             Icons.trending_up,
                              //             size: 15,
                              //           ),
                              //           SizedBox(
                              //             height: 4,
                              //           ),
                              //           Icon(
                              //             Icons.numbers,
                              //             size: 15,
                              //           ),
                              //           SizedBox(
                              //             height: 4,
                              //           ),
                              //           sText(searchKeyword.isNotEmpty ? "${searchKeyword.split('').first}" : "")
                              //
                              //         ]),
                              //       ),
                              //     )
                              //   ]),
                              // )
                            ],
                          ),
                        )),
                      if (searchTap) Spacer(),
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
                                getTest(context, TestCategory.TOPIC);
                              },
                              padding: EdgeInsets.zero,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/courses/topic.png",
                                    height: 35.0,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  sText("Topic ",
                                      color: Colors.grey,
                                      align: TextAlign.center,
                                      size: 12),
                                ],
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                getTest(context, TestCategory.EXAM);
                              },
                              padding: EdgeInsets.zero,
                              child: Container(
                                child: Column(
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
                                        color: Colors.grey,
                                        align: TextAlign.center,
                                        size: 12),
                                  ],
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                getTest(context, TestCategory.BANK);
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
                                getTest(context, TestCategory.SAVED);
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
                                getTest(context, TestCategory.ESSAY);
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

  getKeywordTestTaken() async {
    keywordTestTaken = await TestTakenDB().getKeywordTestTaken();
    setState(() {
      print("am back");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKeywordTestTaken();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        MultiPurposeCourseCard(
          title: 'Speed',
          subTitle: 'Accuracy matters , don\'t let the clock run down',
          iconURL: 'assets/icons/courses/speed.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SpeedTestIntro(
                      user: widget.user,
                      course: widget.course,
                    );
                  },
                ),
              );
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Knowledge',
          subTitle: 'Standard test',
          iconURL: 'assets/icons/courses/knowledge.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              setState(() {});
              knowledgeTestModalBottomSheet(context);
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return TestChallengeList(
            //         testType: TestType.KNOWLEDGE,
            //         course: widget.course,
            //         user: widget.user,
            //       );
            //     },
            //   ),
            // );
          },
        ),
        MultiPurposeCourseCard(
          title: 'Marathon',
          subTitle: 'Race to complete all questions',
          iconURL: 'assets/icons/courses/marathon.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MarathonIntroit(widget.user, widget.course);
                  },
                ),
              );
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Autopilot',
          subTitle: 'Completing a course one topic at a time',
          iconURL: 'assets/icons/courses/autopilot.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AutopilotIntroit(widget.user, widget.course);
                  },
                ),
              );
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Treadmill',
          subTitle: 'Crank up the speed, how far can you go?',
          iconURL: 'assets/icons/courses/treadmill.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Treadmill? treadmill =
                  await TestController().getCurrentTreadmill(widget.course);
              if (treadmill == null) {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TreadmillWelcome(
                      user: widget.user,
                      course: widget.course,
                    ),
                  ),
                );
              } else {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TreadmillSaveResumptionMenu(
                      controller: TreadmillController(
                        widget.user,
                        widget.course,
                        name: widget.course.name!,
                        treadmill: treadmill,
                      ),
                    ),
                  ),
                );
              }
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Customised',
          subTitle: 'Create your own kind of quiz',
          iconURL: 'assets/icons/courses/customised.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CustomizedTestIntroit(
                      user: widget.user,
                      course: widget.course,
                    );
                  },
                ),
              );
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Timeless',
          subTitle: 'Practice mode, no pressure.',
          iconURL: 'assets/icons/courses/untimed.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TestChallengeList(
                      testType: TestType.UNTIMED,
                      course: widget.course,
                      user: widget.user,
                    );
                  },
                ),
              );
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Review',
          subTitle: 'Know the answer to every question',
          iconURL: 'assets/icons/courses/review.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              goTo(
                  context,
                  ReviewOnBoarding(
                    user: widget.user,
                    course: widget.course,
                    testType: TestType.NONE,
                  ));
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
        MultiPurposeCourseCard(
          title: 'Conquest',
          subTitle: 'Prepare for battle, attempt everything',
          iconURL: 'assets/icons/courses/conquest.png',
          onTap: () async {
            List<Question> questions =
                await QuestionDB().getQuestionsByCourseId(widget.course.id!);
            if (questions.isNotEmpty) {
              conquestModalBottomSheet(context);
            } else {
              showDialogYesNo(
                  context: context,
                  message: "Download questions for ${widget.course.name}",
                  target: BuyBundlePage(
                    widget.user,
                    controller: widget.controller,
                    bundle: widget.subscription,
                  ));
            }
          },
        ),
      ],
    );
  }
}

// class _AZItem extends ISuspensionBean {
//   final String title;
//   final String tag;
//   final List<Question> questions;

//   _AZItem({
//     required this.title,
//     required this.tag,
//     required this.questions,
//   });

//   @override
//   String getSuspensionTag() => tag;
// }

// class TrendsResultsList extends StatefulWidget {
//   const TrendsResultsList({
//     Key? key,
//     required this.items,
//     required this.questions,
//   }) : super(key: key);

//   final List<String> items;
//   final List<Question> questions;

//   @override
//   State<TrendsResultsList> createState() => _TrendsResultsListState();
// }

// class _TrendsResultsListState extends State<TrendsResultsList> {
//   List<_AZItem> items = [];

//   @override
//   void initState() {
//     super.initState();
//     initList(widget.items, widget.questions);
//   }

//   void initList(
//     List<String> items,
//     List<Question> questions,
//   ) {
//     this.items = items
//         .map((item) => _AZItem(
//               title: item,
//               tag: item[0].toString(),
//               questions: questions,
//             ))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AzListView(
//       data: items,
//       itemBuilder: (context, item) {
//         _AZItem _item = item as _AZItem;
//         return _buildListItem(_item);
//       },
//     );
//   }

//   Widget _buildListItem(_AZItem item) {
//     return MaterialButton(
//       padding: EdgeInsets.zero,
//       onPressed: () async {
//         setState(() {});
//         // await getTest(context,
//         //     TestCategory.NONE);
//       },
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Icon(Icons.trending_up),
//               SizedBox(
//                 width: 10,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   sText("${properCase("$item")}", weight: FontWeight.bold),
//                   sText("${item.questions.length} appearances",
//                       size: 12, color: kAdeoGray3),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
