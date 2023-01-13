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
import 'package:ecoach/revamp/features/knowledge_test/components/knowledge_test_bottom_sheet.dart';
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
  String _currentAlphabet = '';
  List<String> _scrollListAlphabets = [];
  List<Question> _listQuestions = [];

  bool get isShowAnalysisBox => _isShowAnalysisBox;
  String get currentAlphabet => _currentAlphabet;
  List<String> get scrollListAlphabets => _scrollListAlphabets;
  List<Question> get listQuestions => _listQuestions;

  set listQuestions(List<Question> value) {
    if (value != _listQuestions) {
      _listQuestions = value;
    }
    notifyListeners();
  }

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

  List<CourseKeywords> listCourseKeywordsData = [];
  bool isActiveAnyMenu = false;
  bool sheetHeightIncreased = false;
  late double sheetHeight;
  TestCategory activeMenu = TestCategory.NONE;
  TestCategory selectedMenu = TestCategory.NONE;
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
  List<TestTaken> allTestsTakenForAnalysis = [];

  late int testTakenIndex;
  late TestTaken? testTaken = null;
  late bool isTestTaken = false;
  late bool showKeywordTextField = false;

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
        // alphaSliderToStatisticsCardController.animateToPage(
        //   _selectedIndex,
        // );
      } else {
        // _selectedIndex = tests.indexOf(_selectedTest);
      }
    }
  }

  loadKeywordTest(BuildContext context,
      {required Course course,
      required String testName,
      required User user,
      bool smallHeightDevice = true}) async {
    // 1. check whether keyword test taken exists for the selected
    //    keyword.
    await filterAndSetKnowledgeTestsTaken(
      testCategory: TestCategory.NONE,
      course: course,
      testName: testName.toLowerCase(),
    );

    // 2. if yes, show stats card, else proceed to assesment page
    if (isTestTaken) {
      if (activeMenu != TestCategory.NONE) {
        activeMenu = TestCategory.NONE;
        isActiveAnyMenu = true;
      }
      openKnowledgeTestCard(
        context,
        smallHeightDevice,
        activeMenu,
      );
    } else {
      await getTest(
        context,
        TestCategory.NONE,
        course,
        user,
        searchKeyword: testName,
      );
    }
  }

  filterAndSetKnowledgeTestsTaken({
    required Course course,
    required TestCategory testCategory,
    int? testId = null,
    String? testName,
  }) async {
    isTestTaken = false;
    testsTaken = await TestController().keywordTestsTaken(course.id!);
    switch (testCategory) {
      case TestCategory.EXAM:
      case TestCategory.NONE:
      case TestCategory.TOPIC:
        typeSpecificTestsTaken = await testsTaken
            .where((e) =>
                e.challengeType == testCategory.toString() &&
                e.testType == testType.toString())
            .toList();
        allTestsTakenForAnalysis = typeSpecificTestsTaken;

        break;
      default:
    }

    if (testId != null) {
      if (typeSpecificTestsTaken.length > 0) {
        testTakenIndex = typeSpecificTestsTaken.indexWhere((takenTest) {
          return takenTest.topicId == testId;
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
    } else {
      if (typeSpecificTestsTaken.length > 0) {
        testTakenIndex = await typeSpecificTestsTaken.indexWhere((takenTest) {
          return takenTest.testname!.toLowerCase() == testName!.toLowerCase();
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
  }

  TestCategory openKnowledgeTestCard(
      BuildContext context, bool smallHeightDevice, TestCategory menu) {
    if (!isActiveAnyMenu || searchTap) {
      searchTap = false;
      showKeywordTextField = false;
      sheetHeight = appHeight(context) * 0.90;
      activeMenu = menu;
      if (sheetHeightIncreased) {
        isActiveAnyMenu = true;
      }
    }
    return activeMenu;
  }

  TestCategory closeKnowledgeTestCard(
      BuildContext context, bool smallHeightDevice, TestCategory menu) {
    sheetHeight = smallHeightDevice ? 510 : appHeight(context) * 0.56;
    activeMenu = TestCategory.NONE;
    sheetHeightIncreased = false;
    isActiveAnyMenu = false;
    isShowAlphaScroll = false;
    showKeywordTextField = false;
    return activeMenu;
  }

  Future<List<TestNameAndCount>> getTopics(Course course) async {
    List<TestNameAndCount> topics = await TestController().getTopics(course);

    return topics;
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
          searchKeyword.toLowerCase(),
          course.id!,
          currentQuestionCount: currentQuestionCount,
        );
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

                      // widgetView = KeywordAssessment(
                      //   quizCover: KeywordQuizCover(
                      //     user,
                      //     questions,
                      //     category: testCategory,
                      //     course: course,
                      //     type: testType,
                      //     theme: QuizTheme.BLUE,
                      //     time: questions.length * 60,
                      //     name: searchKeyword,
                      //   ),
                      //   questionCount: questions.length,
                      // );
                      widgetView = KeywordAssessment(
                        user: user,
                        course: course,
                        questions: questions,
                        name: searchKeyword,
                        testCategory: testCategory,
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

  goToInstructions(
    BuildContext context,
    dynamic test,
    TestCategory testCategory,
    User user,
    Course course, {
    String searchKeyword = '',
  }) async {
    // Navigator.pop(context);
    Widget? widgetView;
    List<Question> questions = [];

    switch (testCategory) {
      case TestCategory.EXAM:
        TestNameAndCount _test = test as TestNameAndCount;
        questions = await TestController().getQuizQuestions(
          _test.id!,
        );
        widgetView = KeywordAssessment(
          user: user,
          course: course,
          questions: questions,
          test: _test,
          testCategory: testCategory,
          questionCount: questions.length,
        );
        break;
      case TestCategory.TOPIC:
        TestNameAndCount _test = test as TestNameAndCount;
        questions = await TestController().getTopicQuestions(
          [_test.id!],
        );
        widgetView = KeywordAssessment(
          user: user,
          course: course,
          questions: questions,
          test: _test,
          testCategory: testCategory,
          questionCount: questions.length,
        );

        break;
      case TestCategory.MOCK:
        questions = await TestController().getMockQuestions(
          course.id!,
        );
        widgetView = KeywordAssessment(
          user: user,
          course: course,
          questions: questions,
          testCategory: testCategory,
          questionCount: questions.length,
          name: course.name,
        );
        break;
      case TestCategory.ESSAY:
        break;
      case TestCategory.SAVED:
        break;
      case TestCategory.BANK:
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

  getAllTestTakenByTopic(int topicId) async {
    await TestController().getAllTestTakenByTopic(topicId).then(
      (topicTestsTaken) {
        allTestsTakenForAnalysis = topicTestsTaken;
      },
    );
  }

  getExamTestsTaken({int? courseId, String? testName}) async {
    await TestController()
        .getAllTestTakenByChallengeType(TestCategory.EXAM, courseId: courseId)
        .then((examsTaken) async {
      if (testName != null) {
        allTestsTakenForAnalysis = await examsTaken.where((exam) {
          return exam.testname!.toLowerCase() == testName.toLowerCase();
        }).toList();
      } else {
        allTestsTakenForAnalysis = examsTaken;
      }
    });
  }

  openKnowledgeTestBottomSheet(
    context, {
    Course? course,
    User? user,
    List<CourseKeywords>? listCourseKeywordsData,
  }) async {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return KnowledgeTestBottomSheet(
          course: course!,
          user: user!,
          listCourseKeywordsData: listCourseKeywordsData!,
        );
      },
    );
  }
}
