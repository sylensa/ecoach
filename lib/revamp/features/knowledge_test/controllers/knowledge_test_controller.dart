import 'dart:convert';
import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/knowledge_test/components/alphabet_scroll_slider.dart';
import 'package:ecoach/revamp/features/knowledge_test/components/test_taken_statistics_card.dart';
import 'package:ecoach/revamp/features/knowledge_test/view/test_instruction_screen.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/keyword/keyword_assessment.dart';
import 'package:ecoach/views/keyword/keyword_question_view.dart';
import 'package:ecoach/views/keyword/keyword_quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/speed/speed_quiz_cover.dart';
import 'package:ecoach/views/test/test_type_list.dart';
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
  List<String> _scrollListAlphabets = [];
  String _currentAlphabet = '';

  bool get isShowAnalysisBox => _isShowAnalysisBox;
  List<String> get scrollListAlphabets => _scrollListAlphabets;
  String get currentAlphabet => _currentAlphabet;

  set isShowAnalysisBox(bool value) {
    if (value != _isShowAnalysisBox) {
      _isShowAnalysisBox = value;
    }
    notifyListeners();
  }

  set scrollListAlphabets(List<String> alphaList) {
    _scrollListAlphabets = alphaList;
    notifyListeners();
  }

  set currentAlphabet(String value) {
    _currentAlphabet = value;
    notifyListeners();
  }
}

class KnowledgeTestController extends ChangeNotifier {
  bool searchTap = false;
  bool showGraph = false;
  List<CourseKeywords> listCourseKeywordsData = [];
  List<Question> listQuestions = [];
  bool isActiveAnyMenu = false;
  bool sheetHeightIncreased = false;
  late double sheetHeight;
  late TestCategory activeMenu = TestCategory.NONE;
  bool isShowAlphaScroll = false;
  bool _emptyTestTakenList = true;

  bool get emptyTestList => _emptyTestTakenList;
  set emptyTestList(bool value) {
    _emptyTestTakenList = value;
  }

  TestType testType = TestType.KNOWLEDGE;

  List<TestTaken> tests = [];
  List<TestTaken> testsTaken = [];
  CarouselController alphaSliderToStatisticsCardController =
      CarouselController();
  String currentAlphabet = '';
  Map<String, List<CourseKeywords>> groupedCourseKeywordsMap = {
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
  List<TestTaken> typeSpecificTestsTaken = [];
  late int testTakenIndex;
  late TestTaken? testTaken = null;
  late bool isTestTaken = false;

  void slideToActiveAlphabet(List<dynamic> tests, int index,
      {String selectedAlphabet = ''}) {
    int _selectedIndex;
    List<dynamic> _selectedTests;
    if (selectedAlphabet.isNotEmpty) {
      _selectedTests = tests
          .where((test) => test.name.toUpperCase().startsWith(
                selectedAlphabet,
              ))
          .toList();
      if (_selectedTests.length == 1) {
        _selectedIndex = tests.indexOf(_selectedTests[0]);
        alphaSliderToStatisticsCardController.animateToPage(
          _selectedIndex,
        );
      } else {
        // _selectedIndex = tests.indexOf(_selectedTest);
      }
    }

    // print("Selected: $selectedAlphabet ");
  }

  filterAndSetKnowledgeTestsTaken({
    required Course course,
    required int topicId,
    required TestCategory testCategory,
  }) async {
    testsTaken = await TestController().keywordTestsTaken(course.id!, topicId: topicId);
    // testsTaken = await TestController().getTestTaken(course.id!.toString());
    typeSpecificTestsTaken = testsTaken
        .where((element) =>
            element.challengeType == testCategory.toString() &&
            element.testType == testType.toString())
        .toList();

    print("Tests taken: ${testsTaken.length}");
    if (typeSpecificTestsTaken.length > 0) {
      testTakenIndex = typeSpecificTestsTaken.indexWhere((takenTest) {
        // Find a better way to get the topicId for a testTaken //
        return jsonDecode(takenTest.responses)["Q1"]["topic_id"] == topicId;
      });

      if (testTakenIndex != -1) {
        isTestTaken = true;
        testTaken = typeSpecificTestsTaken[testTakenIndex];
      } else {
        isTestTaken = false;
      }
    } else {
      isTestTaken = false;
    }
  }

  toggleKnowledgeTestMenus(BuildContext context, bool smallHeightDevice) {
    if (!isActiveAnyMenu || searchTap) {
      searchTap = false;
      sheetHeight = appHeight(context) * 0.90;
      activeMenu = TestCategory.TOPIC;
      if (sheetHeightIncreased) {
        isActiveAnyMenu = true;
      }
    } else {
      sheetHeight = smallHeightDevice ? 510 : appHeight(context) * 0.56;
      activeMenu = TestCategory.NONE;
      sheetHeightIncreased = false;
      isActiveAnyMenu = false;
      isShowAlphaScroll = false;
    }
    return isActiveAnyMenu;
  }

  Future<List<TestNameAndCount>> getTopics(Course course) async {
    List<TestNameAndCount> topics = await TestController().getTopics(course);

    return topics;
  }

  goToInstructions(
    BuildContext context,
    dynamic test,
    TestCategory testCategory,
    User user,
    Course course, {
    String searchKeyword = '',
  }) async {
    Navigator.pop(context);
    Widget? widgetView;
    List<Question> questions = [];

    switch (testCategory) {
      case TestCategory.EXAM:
        widgetView = TestTypeListView(
          user,
          course,
          test,
          testType,
          title: "Exams",
          testCategory: TestCategory.EXAM,
        );
        break;
      case TestCategory.TOPIC:
        TestNameAndCount _test = test as TestNameAndCount;
        // print("topic id : ${_test.id}");

        questions = await TestController().getTopicQuestions(
          [_test.id!],
        );
        // return;
        widgetView = KeywordAssessment(
          questionView: KeywordQuestionView(
            controller: QuizController(
              user,
              course,
              questions: questions,
              topicId: _test.id,
              name: searchKeyword,
              time: questions.length * 60,
              type: TestType.KNOWLEDGE,
              challengeType: testCategory,
            ),
            theme: QuizTheme.BLUE,
            numberOfQuestionSelected: questions.length,
          ),
          questionCount: questions.length,
        );
        break;
      case TestCategory.ESSAY:
        widgetView = TestTypeListView(
          user,
          course,
          test,
          testType,
          title: "Essays",
          testCategory: TestCategory.ESSAY,
        );
        break;
      case TestCategory.SAVED:
        List<Question> questions = test as List<Question>;
        widgetView = QuizCover(
          user,
          questions,
          category: testCategory,
          course: course,
          theme: QuizTheme.BLUE,
          time: questions.length * 60,
          name: "Saved Test",
        );
        break;
      case TestCategory.BANK:
        widgetView = TestTypeListView(
          user,
          course,
          test,
          testType,
          title: "Bank",
          testCategory: TestCategory.BANK,
        );
        break;
      case TestCategory.NONE:
        var _test = test;
        List<Question> questions = test as List<Question>;
        widgetView = KeywordAssessment(
          quizCover: KeywordQuizCover(
            user,
            questions,
            category: testCategory,
            course: course,
            type: testType,
            topic: _test,
            theme: QuizTheme.BLUE,
            time: questions.length * 60,
            name: searchKeyword,
          ),
          questionCount: questions.length,
        );

        break;
      default:
        widgetView = null;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return widgetView!;
        },
      ),
    );
  }

  getTest(
    BuildContext context,
    TestCategory testCategory,
    Course course,
    User user, {
    int currentQuestionCount = 0,
    String searchKeyword = '',
  }) {
    Future futureList;
    switch (testCategory) {
      case TestCategory.MOCK:
        Question? q;
        futureList = TestController().getMockTests(course);
        break;
      case TestCategory.EXAM:
        futureList = TestController().getExamTests(course);
        break;
      case TestCategory.TOPIC:
        futureList = TestController().getTopics(course);

        break;
      case TestCategory.ESSAY:
        // futureList = TestController().getEssays(course, 5);
        futureList = TestController().getEssayTests(course);
        break;
      case TestCategory.SAVED:
        futureList = TestController().getSavedTests(course, limit: 10);
        break;
      case TestCategory.BANK:
        futureList = TestController().getBankTest(course);
        break;
      case TestCategory.NONE:
        for (int i = 0; i < keywordTestTaken.length; i++) {
          if (keywordTestTaken[i].testname!.toLowerCase() ==
              searchKeyword.toLowerCase()) {
            futureList = TestController().getKeywordQuestions(
                searchKeyword.toLowerCase(), course.id!,
                currentQuestionCount:
                    keywordTestTaken[i].correct! + keywordTestTaken[i].wrong!);
            futureList.then(
              (data) async {
                // Navigator.pop(context);
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
                                  user,
                                  testType,
                                  questions,
                                  course: course,
                                  theme: QuizTheme.ORANGE,
                                  category: testCategory,
                                  time: questions.length * 60,
                                  name: "Mock Test",
                                )
                              : QuizCover(
                                  user,
                                  questions,
                                  course: course,
                                  type: testType,
                                  theme: QuizTheme.BLUE,
                                  category: testCategory,
                                  time: questions.length * 60,
                                  name: "Mock Test",
                                );
                          break;
                        case TestCategory.EXAM:
                          widgetView = TestTypeListView(
                            user,
                            course,
                            data,
                            testType,
                            title: "Exams",
                            testCategory: TestCategory.EXAM,
                          );
                          break;
                        case TestCategory.TOPIC:
                          widgetView = TestTypeListView(
                            user,
                            course,
                            data,
                            testType,
                            title: "Topic",
                            multiSelect: true,
                            testCategory: TestCategory.TOPIC,
                          );
                          break;
                        case TestCategory.ESSAY:
                          widgetView = TestTypeListView(
                            user,
                            course,
                            data,
                            testType,
                            title: "Essays",
                            testCategory: TestCategory.ESSAY,
                          );

                          break;
                        case TestCategory.SAVED:
                          List<Question> questions = data as List<Question>;
                          widgetView = QuizCover(
                            user,
                            questions,
                            category: testCategory,
                            course: course,
                            theme: QuizTheme.BLUE,
                            time: questions.length * 60,
                            name: "Saved Test",
                          );
                          break;
                        case TestCategory.NONE:
                          List<Question> questions = data as List<Question>;

                          widgetView = KeywordAssessment(
                            quizCover: KeywordQuizCover(
                              user,
                              questions,
                              category: testCategory,
                              course: course,
                              theme: QuizTheme.BLUE,
                              time: questions.length * 60,
                              name: searchKeyword,
                            ),
                            questionCount: questions.length,
                          );
                          break;
                        case TestCategory.BANK:
                          widgetView = TestTypeListView(
                            user,
                            course,
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
            searchKeyword.toLowerCase(), course.id!,
            currentQuestionCount: currentQuestionCount);
        futureList.then(
          (data) async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  Widget? widgetView;
                  switch (testCategory) {
                    case TestCategory.NONE:
                      List<Question> questions = data as List<Question>;

                      widgetView = KeywordAssessment(
                        quizCover: KeywordQuizCover(
                          user,
                          questions,
                          category: testCategory,
                          course: course,
                          type: testType,
                          theme: QuizTheme.BLUE,
                          time: questions.length * 60,
                          name: searchKeyword,
                        ),
                        questionCount: questions.length,
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
        break;
      default:
        futureList = TestController().getBankTest(course);
    }

    return futureList;
  }

  knowledgeTestModalBottomSheet(context, {Course? course, User? user}) async {
    TextEditingController searchKeywordController = TextEditingController();
    String searchKeyword = '';

    if (listCourseKeywordsData.isNotEmpty) {
      groupedCourseKeywordsMap = {
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
      groupedCourseKeywordsMap.clear();
    }
    searchKeywordController.text = searchKeyword.trim();
    searchTap = false;
    bool smallHeightDevice = appHeight(context) < 890 ? true : false;
    sheetHeight = smallHeightDevice ? 500 : appHeight(context) * 0.56;
    bool isActiveTopicMenu = false;
    List<dynamic> tests = [];

    List<String> scrollListAlphabets = [];

    int _currentSlide = 0;
    late int? topicId;

    listCourseKeywordsData.forEach((courseKeyword) {
      if (groupedCourseKeywordsMap[
              '${courseKeyword.keyword![0]}'.toUpperCase()] ==
          null) {
        groupedCourseKeywordsMap['${courseKeyword.keyword![0]}'.toUpperCase()] =
            <CourseKeywords>[];
      }
      groupedCourseKeywordsMap['${courseKeyword.keyword![0]}'.toUpperCase()]!
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
              return ChangeNotifierProvider(
                create: (_) => KnowledgeTestControllerModel(),
                child: Consumer<KnowledgeTestControllerModel>(
                  builder: (context, model, child) {
                    return AnimatedContainer(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: sheetHeight,
                        onEnd: (() async {
                          testsTaken = await TestController()
                              .getTestTaken(course!.id!.toString());

                          if (!sheetHeightIncreased) {
                            switch (activeMenu) {
                              case TestCategory.TOPIC:
                                isActiveTopicMenu = true;
                                isActiveAnyMenu = true;
                                sheetHeightIncreased = true;
                                tests = await getTest(
                                  context,
                                  TestCategory.TOPIC,
                                  course,
                                  user!,
                                );
                                emptyTestList = tests.isEmpty;
                                currentAlphabet = tests.first.name[0];
                                topicId = tests[_currentSlide].id;

                                filterAndSetKnowledgeTestsTaken(
                                  testCategory: TestCategory.TOPIC,
                                  course: course,
                                  topicId: topicId!,
                                );

                                if (!emptyTestList) {
                                  scrollListAlphabets = tests
                                      .map((topic) {
                                        return topic.name[0]
                                            .toString()
                                            .toUpperCase();
                                      })
                                      .toSet()
                                      .toList();
                                  scrollListAlphabets.sort();
                                }

                                break;
                              case TestCategory.EXAM:
                                isActiveAnyMenu = true;
                                break;
                              case TestCategory.MOCK:
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SingleChildScrollView(
                                              physics: model.isShowAnalysisBox
                                                  ? BouncingScrollPhysics()
                                                  : NeverScrollableScrollPhysics(),
                                              child: CarouselSlider.builder(
                                                  carouselController:
                                                      alphaSliderToStatisticsCardController,
                                                  options: CarouselOptions(
                                                    height:
                                                        model.isShowAnalysisBox
                                                            ? 600
                                                            : 300,
                                                    autoPlay: false,
                                                    enableInfiniteScroll: false,
                                                    autoPlayAnimationDuration:
                                                        Duration(seconds: 1),
                                                    enlargeCenterPage: false,
                                                    viewportFraction: 1,
                                                    aspectRatio: 2.0,
                                                    pageSnapping: true,
                                                    initialPage: _currentSlide,
                                                    onPageChanged:
                                                        (index, reason) {
                                                      _currentSlide = index;
                                                      model.currentAlphabet =
                                                          tests[_currentSlide]
                                                              .name[0];

                                                      switch (activeMenu) {
                                                        case TestCategory.TOPIC:
                                                          topicId = tests[
                                                                  _currentSlide]
                                                              .id;
                                                          testTakenIndex =
                                                              typeSpecificTestsTaken
                                                                  .indexWhere(
                                                                      (takenTest) {
                                                            return jsonDecode(
                                                                        takenTest
                                                                            .responses)["Q1"]
                                                                    [
                                                                    "topic_id"] ==
                                                                topicId;
                                                          });
                                                          if (testTakenIndex !=
                                                              -1) {
                                                            isTestTaken = true;
                                                            testTaken =
                                                                typeSpecificTestsTaken[
                                                                    testTakenIndex];
                                                          } else {
                                                            isTestTaken = false;
                                                          }

                                                          break;
                                                        case TestCategory.EXAM:
                                                          break;
                                                        case TestCategory.MOCK:
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
                                                      ;

                                                      stateSetter(() {});
                                                    },
                                                  ),
                                                  itemCount: tests.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int indexReport,
                                                          int index2) {
                                                    return TestsStatisticCard(
                                                      test: tests[indexReport],
                                                      isTestTaken: isTestTaken,
                                                      testTaken: testTaken,
                                                      showGraph: showGraph,
                                                      activeMenu: activeMenu,
                                                      knowledgeTestControllerModel:
                                                          model,
                                                      getTest: (
                                                        BuildContext context,
                                                        TestCategory
                                                            testCategory,
                                                        TestNameAndCount
                                                            selectedTopic,
                                                      ) async {
                                                        goToInstructions(
                                                            context,
                                                            selectedTopic,
                                                            testCategory,
                                                            user!,
                                                            course!,
                                                            searchKeyword:
                                                                searchKeyword);
                                                      },
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                      if (!model.isShowAnalysisBox)
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isActiveAnyMenu &&
                                                  keywordTestTaken.isNotEmpty)
                                                Spacer(),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Dismissible(
                                                key: UniqueKey(),
                                                direction:
                                                    DismissDirection.horizontal,
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
                                                    isShowAlphaScroll &&
                                                            !emptyTestList
                                                        ? AlphabetScrollSlider(
                                                            alphabets:
                                                                scrollListAlphabets,
                                                            initialSelectedAlphabet: model
                                                                    .currentAlphabet
                                                                    .isEmpty
                                                                ? currentAlphabet
                                                                : model
                                                                    .currentAlphabet,
                                                            callback:
                                                                (selectedAlphabet,
                                                                    index) {
                                                              slideToActiveAlphabet(
                                                                tests,
                                                                index,
                                                                selectedAlphabet:
                                                                    selectedAlphabet,
                                                              );
                                                            },
                                                          )
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              top: 0,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  searchKeywordController,
                                                              onChanged: (String
                                                                  value) async {
                                                                stateSetter(() {
                                                                  searchKeyword =
                                                                      value
                                                                          .trim();
                                                                  listQuestions
                                                                      .clear();
                                                                });

                                                                if (searchKeyword
                                                                    .isNotEmpty) {
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          keywordTestTaken
                                                                              .length;
                                                                      i++) {
                                                                    if (keywordTestTaken[i]
                                                                            .testname!
                                                                            .toLowerCase() ==
                                                                        searchKeyword
                                                                            .toLowerCase()) {
                                                                      listQuestions = await TestController().getKeywordQuestions(
                                                                          searchKeyword
                                                                              .toLowerCase(),
                                                                          course!
                                                                              .id!,
                                                                          currentQuestionCount:
                                                                              keywordTestTaken[i].correct! + keywordTestTaken[i].wrong!);
                                                                      stateSetter(
                                                                          () {});
                                                                      return;
                                                                    }
                                                                  }
                                                                }
                                                                if (searchKeyword
                                                                    .isNotEmpty) {
                                                                  listQuestions = await TestController().getKeywordQuestions(
                                                                      searchKeyword
                                                                          .toLowerCase(),
                                                                      course!
                                                                          .id!,
                                                                      currentQuestionCount:
                                                                          0);
                                                                }
                                                                stateSetter(
                                                                    () {});
                                                              },
                                                              onTap: () {
                                                                stateSetter(() {
                                                                  sheetHeight =
                                                                      appHeight(
                                                                              context) *
                                                                          0.90;
                                                                  sheetHeightIncreased =
                                                                      true;
                                                                  searchTap =
                                                                      true;
                                                                  if (isActiveAnyMenu) {
                                                                    activeMenu =
                                                                        TestCategory
                                                                            .NONE;
                                                                    isActiveAnyMenu =
                                                                        false;
                                                                  }
                                                                });
                                                              },
                                                              decoration:
                                                                  textDecorSuffix(
                                                                fillColor: Color(
                                                                    0xFFEEEEEE),
                                                                showBorder:
                                                                    false,
                                                                size: 60,
                                                                icon:
                                                                    IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          // model.isShowAnalysisBox =
                                                                          //     !model.isShowAnalysisBox;

                                                                          await getTest(
                                                                            context,
                                                                            TestCategory.NONE,
                                                                            course!,
                                                                            user!,
                                                                            searchKeyword:
                                                                                searchKeyword,
                                                                          );
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .search,
                                                                          color:
                                                                              Colors.grey,
                                                                        )),
                                                                suffIcon: null,
                                                                label:
                                                                    "Search Keywords",
                                                                enabled: true,
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              if (!searchTap && !emptyTestList)
                                                Spacer(),
                                              if (searchTap)
                                                Expanded(
                                                  child: Container(
                                                      padding: EdgeInsets.only(
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
                                                              child:
                                                                  listQuestions
                                                                          .isEmpty
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
                                                                                in groupedCourseKeywordsMap.entries)
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
                                                                                          onPressed: () async {
                                                                                            await getTest(
                                                                                              context,
                                                                                              TestCategory.NONE,
                                                                                              course!,
                                                                                              user!,
                                                                                              searchKeyword: "${entry.value[i].keyword}",
                                                                                            );
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
                                                                            sText("Search Result",
                                                                                weight: FontWeight.w600),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            MaterialButton(
                                                                              padding: EdgeInsets.zero,
                                                                              onPressed: () async {
                                                                                stateSetter(() {});
                                                                                await getTest(
                                                                                  context,
                                                                                  TestCategory.NONE,
                                                                                  course!,
                                                                                  user!,
                                                                                );
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
                                                                      size: 15,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .numbers,
                                                                      size: 15,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    if (listQuestions
                                                                        .isEmpty)
                                                                      for (var entry
                                                                          in groupedCourseKeywordsMap
                                                                              .entries)
                                                                        if (entry
                                                                            .value
                                                                            .isNotEmpty)
                                                                          Text(entry
                                                                              .key),
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
                                                      BorderRadius.circular(12),
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
                                                            color: Colors.grey,
                                                            align: TextAlign
                                                                .center,
                                                            size: 12),
                                                      ],
                                                    ),
                                                    MaterialButton(
                                                      onPressed: () async {
                                                        activeMenu =
                                                            TestCategory.TOPIC;
                                                        tests = await getTest(
                                                          context,
                                                          activeMenu,
                                                          course!,
                                                          user!,
                                                        );

                                                        topicId = tests[0].id;

                                                        await filterAndSetKnowledgeTestsTaken(
                                                          testCategory:
                                                              TestCategory
                                                                  .TOPIC,
                                                          course: course,
                                                          topicId: topicId!,
                                                        );
                                                        stateSetter(() {});

                                                        if (sheetHeightIncreased) {
                                                          isActiveTopicMenu =
                                                              true;
                                                          isActiveAnyMenu =
                                                              true;

                                                          emptyTestList =
                                                              tests.isEmpty;
                                                          currentAlphabet =
                                                              tests.first
                                                                  .name[0];

                                                          if (!emptyTestList) {
                                                            scrollListAlphabets =
                                                                tests
                                                                    .map(
                                                                        (topic) {
                                                                      return topic
                                                                          .name[
                                                                              0]
                                                                          .toString()
                                                                          .toUpperCase();
                                                                    })
                                                                    .toSet()
                                                                    .toList();
                                                            scrollListAlphabets
                                                                .sort();
                                                          }
                                                        }

                                                        toggleKnowledgeTestMenus(
                                                          context,
                                                          smallHeightDevice,
                                                        );
                                                        stateSetter(() {});
                                                      },
                                                      padding: EdgeInsets.zero,
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
                                                              child: Container(
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
                                                      padding: EdgeInsets.zero,
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
                                                              TestCategory.EXAM)
                                                            Positioned(
                                                              bottom: 20,
                                                              left: 0,
                                                              right: 0,
                                                              child: Container(
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
                                                      padding: EdgeInsets.zero,
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
                                                      padding: EdgeInsets.zero,
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
                                                                color:
                                                                    Colors.grey,
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
                                                      padding: EdgeInsets.zero,
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
