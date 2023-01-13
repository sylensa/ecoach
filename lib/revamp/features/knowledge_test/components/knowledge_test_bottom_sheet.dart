import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/knowledge_test/components/alphabet_scroll_slider.dart';
import 'package:ecoach/revamp/features/knowledge_test/components/test_taken_statistics_card.dart';
import 'package:ecoach/revamp/features/knowledge_test/controllers/knowledge_test_controller.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KnowledgeTestBottomSheet extends StatefulWidget {
  const KnowledgeTestBottomSheet({
    Key? key,
    required this.course,
    required this.user,
    required this.listCourseKeywordsData,
  }) : super(key: key);

  final Course course;
  final User user;
  final List<CourseKeywords> listCourseKeywordsData;

  @override
  State<KnowledgeTestBottomSheet> createState() =>
      _KnowledgeTestBottomSheetState();
}

class _KnowledgeTestBottomSheetState extends State<KnowledgeTestBottomSheet> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late Course _course;
  late User _user;
  late bool smallHeightDevice;
  late int? topicId;
  late FocusNode focusNodeKeywordSearchField;

  TextEditingController searchKeywordController = TextEditingController();
  KnowledgeTestController _knowledgeTestController = KnowledgeTestController();
  int _currentSlide = 0;
  String searchKeyword = '';
  bool isActiveTopicMenu = false;
  bool isShowAlphaScroll = false;
  bool showGraph = false;
  dynamic test;
  List<String> scrollListAlphabets = [];
  List<dynamic> tests = [];
  List<CourseKeywords> _listCourseKeywordsData = [];
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

  @override
  void initState() {
    _course = widget.course;
    _user = widget.user;
    _knowledgeTestController.searchTap = false;
    _listCourseKeywordsData = widget.listCourseKeywordsData;

    if (_listCourseKeywordsData.isNotEmpty) {
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
    setState(() {});

    _listCourseKeywordsData.forEach((courseKeyword) {
      if (groupedCourseKeywordsMap[
              '${courseKeyword.keyword![0]}'.toUpperCase()] ==
          null) {
        groupedCourseKeywordsMap['${courseKeyword.keyword![0]}'.toUpperCase()] =
            <CourseKeywords>[];
      }
      groupedCourseKeywordsMap['${courseKeyword.keyword![0]}'.toUpperCase()]!
          .add(courseKeyword);
    });
    focusNodeKeywordSearchField = FocusNode();
    super.initState();
  }

  runKeywordSearch(String keyword, KnowledgeTestControllerModel model) async {
    if (keyword.isNotEmpty) {
      for (int i = 0; i < keywordTestTaken.length; i++) {
        if (keywordTestTaken[i].testname!.toLowerCase() ==
            keyword.toLowerCase()) {
          model.listQuestions = await TestController().getKeywordQuestions(
              keyword.toLowerCase(), _course.id!,
              currentQuestionCount:
                  keywordTestTaken[i].correct! + keywordTestTaken[i].wrong!);
          setState(() {});
          return;
        }
      }
    }
    if (keyword.isNotEmpty) {
      model.listQuestions = await TestController().getKeywordQuestions(
          keyword.toLowerCase(), _course.id!,
          currentQuestionCount: 0);
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    smallHeightDevice = appHeight(context) < 890 ? true : false;
    _knowledgeTestController.sheetHeight =
        smallHeightDevice ? 500 : appHeight(context) * 0.56;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchKeywordController.dispose();
    focusNodeKeywordSearchField.dispose();

    super.dispose();
  }

  initTests() async {
    _knowledgeTestController.isActiveAnyMenu = true;
    _knowledgeTestController.sheetHeightIncreased = true;
    tests = await _knowledgeTestController.getTest(
      context,
      _knowledgeTestController.activeMenu,
      _course,
      _user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KnowledgeTestControllerModel(),
      child: Consumer<KnowledgeTestControllerModel>(
        builder: (context, model, child) {
          return AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: _knowledgeTestController.sheetHeight,
            onEnd: (() async {
              setState(() {
                _currentSlide = 0;
              });

              if (!_knowledgeTestController.sheetHeightIncreased) {
                switch (_knowledgeTestController.activeMenu) {
                  case TestCategory.TOPIC:
                    isActiveTopicMenu = true;
                    await initTests();

                    _knowledgeTestController.emptyTestList = tests.isEmpty;
                    _knowledgeTestController.currentAlphabet =
                        tests.first.name[0];
                    topicId = tests[_currentSlide].id;

                    await _knowledgeTestController.filterAndSetKnowledgeTestsTaken(
                      testCategory: TestCategory.TOPIC,
                      course: _course,
                      testId: topicId!,
                    );

                    if (!_knowledgeTestController.emptyTestList) {
                      scrollListAlphabets = tests
                          .map((topic) {
                            return topic.name[0].toString().toUpperCase();
                          })
                          .toSet()
                          .toList();
                      scrollListAlphabets.sort();
                    }
                    isShowAlphaScroll = true;
                    break;
                  case TestCategory.EXAM:
                    await initTests();

                    if (tests.isNotEmpty) {
                      _knowledgeTestController.emptyTestList = tests.isEmpty;
                      _knowledgeTestController.currentAlphabet =
                          tests.first.name[0];

                      await _knowledgeTestController
                          .filterAndSetKnowledgeTestsTaken(
                        testCategory: TestCategory.EXAM,
                        course: _course,
                        testId: null,
                        testName:
                            (tests[_currentSlide] as TestNameAndCount).name,
                      );
                    }
                    break;
                  case TestCategory.MOCK:
                    _knowledgeTestController.isActiveAnyMenu = true;
                    break;
                  case TestCategory.ESSAY:
                    _knowledgeTestController.isActiveAnyMenu = true;
                    break;
                  case TestCategory.SAVED:
                    _knowledgeTestController.isActiveAnyMenu = true;
                    break;
                  case TestCategory.BANK:
                    _knowledgeTestController.isActiveAnyMenu = true;
                    break;
                  case TestCategory.NONE:
                    break;
                  default:
                    // sheetHeightIncreased = false;
                    break;
                }
                setState(() {});
              }
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        maxHeight: smallHeightDevice &&
                                _knowledgeTestController.searchTap
                            ? 600
                            : _knowledgeTestController.isActiveAnyMenu
                                ? 674
                                : !smallHeightDevice &&
                                        _knowledgeTestController.searchTap
                                    ? 660
                                    : 346,
                      ),
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          if (_knowledgeTestController.isActiveAnyMenu)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                _knowledgeTestController.activeMenu ==
                                        TestCategory.NONE
                                    ? Container(
                                        height:
                                            model.isShowAnalysisBox ? 600 : 300,
                                        child: TestsStatisticCard(
                                          user: _user,
                                          course: _course,
                                          test: null,
                                          isTestTaken: true,
                                          testTaken: _knowledgeTestController
                                              .testTaken,
                                          allTestsTakenForAnalysis:
                                              _knowledgeTestController
                                                  .allTestsTakenForAnalysis,
                                          showGraph: showGraph,
                                          activeMenu: _knowledgeTestController
                                              .activeMenu,
                                          knowledgeTestControllerModel: model,
                                          getTest: (
                                            BuildContext context,
                                            TestCategory testCategory,
                                            TestNameAndCount? selectedTopic,
                                          ) async {
                                            await _knowledgeTestController
                                                .getTest(
                                              context,
                                              TestCategory.NONE,
                                              _course,
                                              _user,
                                              searchKeyword:
                                                  _knowledgeTestController
                                                      .testTaken!.testname!,
                                            );
                                          },
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        physics: model.isShowAnalysisBox
                                            ? BouncingScrollPhysics()
                                            : NeverScrollableScrollPhysics(),
                                        child: tests.isNotEmpty
                                            ? CarouselSlider.builder(
                                                carouselController:
                                                    _knowledgeTestController
                                                        .alphaSliderToStatisticsCardController,
                                                options: CarouselOptions(
                                                  height:
                                                      model.isShowAnalysisBox
                                                          ? 600
                                                          : 300,
                                                  autoPlay: false,
                                                  enableInfiniteScroll: false,
                                                  autoPlayAnimationDuration:
                                                      Duration(seconds: 1),
                                                  enlargeCenterPage: true,
                                                  viewportFraction: 1,
                                                  aspectRatio: 2.0,
                                                  pageSnapping: true,
                                                  initialPage: _currentSlide,
                                                  onPageChanged:
                                                      (index, reason) async {
                                                    if (model
                                                        .isShowAnalysisBox) {
                                                      model.isShowAnalysisBox =
                                                          false;
                                                    }
                                                    if (isShowAlphaScroll) {
                                                      model.currentAlphabet =
                                                          tests[_currentSlide]
                                                              .name[0];
                                                    }
                                                  },
                                                ),
                                                itemCount: tests.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int itemIndex,
                                                        int pageViewIndex) {
                                                          
                                                  _currentSlide = itemIndex;

                                                  test = tests[_currentSlide];

                                                  switch (
                                                      _knowledgeTestController
                                                          .activeMenu) {
                                                    case TestCategory.TOPIC:
                                                      topicId =
                                                          tests[_currentSlide]
                                                              .id;
                                                      _knowledgeTestController
                                                          .getAllTestTakenByTopic(
                                                              topicId!);

                                                      _knowledgeTestController
                                                              .testTakenIndex =
                                                          _knowledgeTestController
                                                              .typeSpecificTestsTaken
                                                              .indexWhere(
                                                        (takenTest) {
                                                          return takenTest
                                                                  .topicId ==
                                                              topicId;
                                                        },
                                                      );

                                                      if (_knowledgeTestController
                                                              .testTakenIndex !=
                                                          -1) {
                                                        _knowledgeTestController
                                                            .isTestTaken = true;
                                                        _knowledgeTestController
                                                                .testTaken =
                                                            _knowledgeTestController
                                                                    .typeSpecificTestsTaken[
                                                                _knowledgeTestController
                                                                    .testTakenIndex];
                                                      } else {
                                                        _knowledgeTestController
                                                                .isTestTaken =
                                                            false;
                                                      }

                                                      break;
                                                    case TestCategory.EXAM:
                                                      _knowledgeTestController
                                                          .getExamTestsTaken(
                                                        courseId: _course.id,
                                                        testName: (test
                                                                as TestNameAndCount)
                                                            .name,
                                                      );

                                                      _knowledgeTestController
                                                              .testTakenIndex =
                                                          _knowledgeTestController
                                                              .typeSpecificTestsTaken
                                                              .indexWhere(
                                                                  (examTaken) {
                                                        // ? would be better to check condtion with examId instead of the name of exam taken
                                                        return examTaken
                                                                .testname!
                                                                .toLowerCase() ==
                                                            (test as TestNameAndCount)
                                                                .name
                                                                .toLowerCase();
                                                      });

                                                      if (_knowledgeTestController
                                                              .testTakenIndex !=
                                                          -1) {
                                                        _knowledgeTestController
                                                            .isTestTaken = true;
                                                        _knowledgeTestController
                                                                .testTaken =
                                                            _knowledgeTestController
                                                                    .typeSpecificTestsTaken[
                                                                _knowledgeTestController
                                                                    .testTakenIndex];
                                                      } else {
                                                        _knowledgeTestController
                                                                .isTestTaken =
                                                            false;
                                                      }
                                                      break;
                                                    case TestCategory.MOCK:
                                                      break;
                                                    case TestCategory.ESSAY:
                                                      break;
                                                    case TestCategory.SAVED:
                                                      break;
                                                    case TestCategory.BANK:
                                                      break;
                                                    default:
                                                      break;
                                                  }

                                                  return TestsStatisticCard(
                                                    user: _user,
                                                    course: _course,
                                                    test: test,
                                                    isTestTaken:
                                                        _knowledgeTestController
                                                            .isTestTaken,
                                                    testTaken:
                                                        _knowledgeTestController
                                                            .testTaken,
                                                    allTestsTakenForAnalysis:
                                                        _knowledgeTestController
                                                            .allTestsTakenForAnalysis,
                                                    showGraph: showGraph,
                                                    activeMenu:
                                                        _knowledgeTestController
                                                            .activeMenu,
                                                    knowledgeTestControllerModel:
                                                        model,
                                                    getTest: (
                                                      BuildContext context,
                                                      TestCategory testCategory,
                                                      TestNameAndCount?
                                                          selectedTopic,
                                                    ) async {
                                                      _knowledgeTestController
                                                          .goToInstructions(
                                                        context,
                                                        selectedTopic,
                                                        testCategory,
                                                        _user,
                                                        _course,
                                                        searchKeyword:
                                                            searchKeyword,
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : SizedBox(
                                                height: 300,
                                                child: Center(
                                                  child: Text(
                                                    "No ${_knowledgeTestController.activeMenu.name} found for\n${_course.name}",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                      ),
                              ],
                            ),
                          if (!model.isShowAnalysisBox)
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_knowledgeTestController
                                          .isActiveAnyMenu &&
                                      keywordTestTaken.isNotEmpty)
                                    Spacer(),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: _knowledgeTestController
                                                .activeMenu !=
                                            TestCategory.EXAM
                                        ? Dismissible(
                                            key: UniqueKey(),
                                            direction:
                                                DismissDirection.horizontal,
                                            confirmDismiss: (direction) {
                                              if (_knowledgeTestController
                                                  .isActiveAnyMenu) {
                                                if (direction ==
                                                        DismissDirection
                                                            .endToStart ||
                                                    direction ==
                                                        DismissDirection
                                                            .startToEnd) {
                                                  setState(
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
                                                        !_knowledgeTestController
                                                            .emptyTestList
                                                    ? AlphabetScrollSlider(
                                                        alphabets:
                                                            scrollListAlphabets,
                                                        initialSelectedAlphabet: model
                                                                .currentAlphabet
                                                                .isEmpty
                                                            ? _knowledgeTestController
                                                                .currentAlphabet
                                                            : model
                                                                .currentAlphabet,
                                                        callback:
                                                            (selectedAlphabet,
                                                                index) {
                                                          _knowledgeTestController
                                                              .slideToActiveAlphabet(
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
                                                        child: Form(
                                                          key: _formKey,
                                                          child: TextField(
                                                            focusNode:
                                                                focusNodeKeywordSearchField,
                                                            controller:
                                                                searchKeywordController,
                                                            onChanged: (String
                                                                value) async {
                                                              searchKeyword =
                                                                  value.trim();
                                                              model
                                                                  .listQuestions
                                                                  .clear();
                                                              await runKeywordSearch(
                                                                searchKeyword,
                                                                model,
                                                              );
                                                            },
                                                            onTap: (() {
                                                              if (_knowledgeTestController
                                                                      .searchTap ==
                                                                  false) {
                                                                setState(() {
                                                                  _knowledgeTestController
                                                                          .sheetHeight =
                                                                      appHeight(
                                                                              context) *
                                                                          0.90;
                                                                  _knowledgeTestController
                                                                          .showKeywordTextField =
                                                                      true;
                                                                  _knowledgeTestController
                                                                          .sheetHeightIncreased =
                                                                      true;
                                                                  if (_knowledgeTestController
                                                                      .isActiveAnyMenu) {
                                                                    _knowledgeTestController
                                                                            .activeMenu =
                                                                        TestCategory
                                                                            .NONE;
                                                                    _knowledgeTestController
                                                                            .isActiveAnyMenu =
                                                                        false;
                                                                  }
                                                                  _knowledgeTestController
                                                                          .searchTap =
                                                                      true;
                                                                });
                                                              }
                                                            }),
                                                            decoration:
                                                                textDecorSuffix(
                                                              fillColor: Color(
                                                                  0xFFEEEEEE),
                                                              showBorder: false,
                                                              size: 60,
                                                              icon: IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await _knowledgeTestController
                                                                        .getTest(
                                                                      context,
                                                                      TestCategory
                                                                          .NONE,
                                                                      _course,
                                                                      _user,
                                                                      searchKeyword:
                                                                          searchKeyword,
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .search,
                                                                    color: Colors
                                                                        .grey,
                                                                  )),
                                                              suffIcon: null,
                                                              label:
                                                                  "Search Keywords",
                                                              enabled: true,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: tests.map((exam) {
                                                  TestNameAndCount _exam =
                                                      exam as TestNameAndCount;
                                                  int _index =
                                                      tests.indexOf(exam);
                                                  bool _selectedExam =
                                                      _currentSlide == _index;

                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        left: _index != 0
                                                            ? 14.0
                                                            : 0),
                                                    child: GestureDetector(
                                                      onTap: (() {
                                                        if (_currentSlide !=
                                                            _index) {
                                                          setState(() {
                                                            _currentSlide =
                                                                _index;
                                                          });
                                                          _knowledgeTestController
                                                              .alphaSliderToStatisticsCardController
                                                              .animateToPage(
                                                                  _index);
                                                        }
                                                      }),
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: 8,
                                                          horizontal: 16,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _selectedExam
                                                              ? Color(
                                                                  0xFF0760A5)
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          border: Border.all(
                                                            color: _selectedExam
                                                                ? Color(
                                                                    0xFF0760A5)
                                                                : Color(
                                                                    0xFF9AA9BB),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          _exam.name,
                                                          style: TextStyle(
                                                            color: _selectedExam
                                                                ? Colors.white
                                                                : Color(
                                                                    0xFF9AA9BB),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );

                                                  // return Container();
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                  ),
                                  if (!_knowledgeTestController.searchTap &&
                                      !_knowledgeTestController.emptyTestList)
                                    Spacer(),
                                  if (_knowledgeTestController.searchTap)
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
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SingleChildScrollView(
                                                child: Container(
                                                  child:
                                                      model.listQuestions
                                                              .isEmpty
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                sText(
                                                                    "Most Popular",
                                                                    weight:
                                                                        FontWeight
                                                                            .w600),
                                                                SizedBox(
                                                                  height: 14,
                                                                ),
                                                                for (var entry
                                                                    in groupedCourseKeywordsMap
                                                                        .entries)
                                                                  if (entry
                                                                      .value
                                                                      .isNotEmpty)
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(entry
                                                                            .key),
                                                                        for (int i =
                                                                                0;
                                                                            i < entry.value.length;
                                                                            i++)
                                                                          if (properCase("${entry.value[i].keyword}").isNotEmpty)
                                                                            MaterialButton(
                                                                              padding: EdgeInsets.zero,
                                                                              onPressed: () async {
                                                                                await _knowledgeTestController.loadKeywordTest(
                                                                                  context,
                                                                                  course: _course,
                                                                                  testName: entry.value[i].keyword!,
                                                                                  user: _user,
                                                                                );
                                                                                if (_knowledgeTestController.isTestTaken) {
                                                                                  focusNodeKeywordSearchField.unfocus();
                                                                                  setState(() {});
                                                                                }
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
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                sText(
                                                                    "Search Result",
                                                                    weight:
                                                                        FontWeight
                                                                            .w600),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                MaterialButton(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  onPressed:
                                                                      () async {
                                                                    await _knowledgeTestController
                                                                        .loadKeywordTest(
                                                                      context,
                                                                      course:
                                                                          _course,
                                                                      testName:
                                                                          searchKeyword,
                                                                      user:
                                                                          _user,
                                                                    );
                                                                    if (_knowledgeTestController
                                                                        .isTestTaken) {
                                                                      // searchKeywordController
                                                                      //     .clear();
                                                                      focusNodeKeywordSearchField
                                                                          .unfocus();
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
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
                                                                              sText("${properCase("$searchKeyword")}", weight: FontWeight.bold),
                                                                              sText("${model.listQuestions.length} appearances", size: 12, color: kAdeoGray3),
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
                                                    if (model
                                                        .listQuestions.isEmpty)
                                                      for (var entry
                                                          in groupedCourseKeywordsMap
                                                              .entries)
                                                        if (entry
                                                            .value.isNotEmpty)
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
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 240,
                                    child: GridView.count(
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 3,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          onPressed: () async {
                                            // model.isShowAnalysisBox = false;
                                            if (_knowledgeTestController
                                                    .activeMenu !=
                                                TestCategory.TOPIC) {
                                              _knowledgeTestController
                                                      .activeMenu =
                                                  TestCategory.TOPIC;

                                              if (_currentSlide != 0) {
                                                _knowledgeTestController
                                                    .alphaSliderToStatisticsCardController
                                                    .animateToPage(0);
                                              }
                                              tests =
                                                  await _knowledgeTestController
                                                      .getTest(
                                                context,
                                                _knowledgeTestController
                                                    .activeMenu,
                                                _course,
                                                _user,
                                              );

                                              if (tests.isNotEmpty) {
                                                topicId = tests.first.id;
                                                test = tests.first;

                                                await _knowledgeTestController
                                                    .filterAndSetKnowledgeTestsTaken(
                                                  testCategory:
                                                      _knowledgeTestController
                                                          .activeMenu,
                                                  course: _course,
                                                  testId: topicId!,
                                                );
                                              }

                                              _knowledgeTestController
                                                      .emptyTestList =
                                                  tests.isEmpty;
                                              _knowledgeTestController
                                                      .currentAlphabet =
                                                  tests.first.name[0];

                                              if (!_knowledgeTestController
                                                  .emptyTestList) {
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

                                              _knowledgeTestController
                                                  .openKnowledgeTestCard(
                                                context,
                                                smallHeightDevice,
                                                _knowledgeTestController
                                                    .activeMenu,
                                              );

                                              searchKeywordController.clear();
                                              focusNodeKeywordSearchField
                                                  .unfocus();
                                              isShowAlphaScroll = true;
                                              setState(() {});
                                            } else {
                                              _knowledgeTestController
                                                  .closeKnowledgeTestCard(
                                                context,
                                                smallHeightDevice,
                                                _knowledgeTestController
                                                    .activeMenu,
                                              );
                                              isShowAlphaScroll = false;
                                              setState(() {});
                                            }
                                          },
                                          padding: EdgeInsets.zero,
                                          child: Stack(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/courses/topic.png",
                                                    height: 35.0,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  sText(
                                                    "Topic",
                                                    color:
                                                        _knowledgeTestController
                                                                    .activeMenu ==
                                                                TestCategory
                                                                    .TOPIC
                                                            ? Color(0xFF003D6C)
                                                            : Colors.grey,
                                                    align: TextAlign.center,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                              if (_knowledgeTestController
                                                      .activeMenu ==
                                                  TestCategory.TOPIC)
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
                                          onPressed: () async {
                                            isShowAlphaScroll = false;
                                            if (_knowledgeTestController
                                                    .activeMenu !=
                                                TestCategory.EXAM) {
                                              _knowledgeTestController
                                                      .activeMenu =
                                                  TestCategory.EXAM;
                                              if (_knowledgeTestController
                                                  .sheetHeightIncreased) {
                                                if (_currentSlide != 0) {
                                                  _knowledgeTestController
                                                      .alphaSliderToStatisticsCardController
                                                      .animateToPage(0);
                                                }
                                                tests =
                                                    await _knowledgeTestController
                                                        .getTest(
                                                  context,
                                                  _knowledgeTestController
                                                      .activeMenu,
                                                  _course,
                                                  _user,
                                                );

                                                if (tests.isNotEmpty) {
                                                  await _knowledgeTestController
                                                      .filterAndSetKnowledgeTestsTaken(
                                                    testCategory:
                                                        _knowledgeTestController
                                                            .activeMenu,
                                                    course: _course,
                                                    testName: (tests[0]
                                                            as TestNameAndCount)
                                                        .name,
                                                  );
                                                }
                                                setState(() {});

                                                _knowledgeTestController
                                                    .isActiveAnyMenu = true;

                                                _knowledgeTestController
                                                        .emptyTestList =
                                                    tests.isEmpty;
                                                // _knowledgeTestController
                                                //         .currentAlphabet =
                                                //     tests.first.name[0];
                                              }

                                              _knowledgeTestController
                                                  .openKnowledgeTestCard(
                                                context,
                                                smallHeightDevice,
                                                _knowledgeTestController
                                                    .activeMenu,
                                              );

                                              setState(() {});
                                            } else {
                                              _knowledgeTestController
                                                  .closeKnowledgeTestCard(
                                                context,
                                                smallHeightDevice,
                                                _knowledgeTestController
                                                    .activeMenu,
                                              );
                                              setState(() {});
                                            }
                                          },
                                          padding: EdgeInsets.zero,
                                          child: Stack(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/courses/exam.png",
                                                    height: 35.0,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  sText("Exam ",
                                                      color: _knowledgeTestController
                                                                  .activeMenu ==
                                                              TestCategory.EXAM
                                                          ? Color(0xFF003D6C)
                                                          : Colors.grey,
                                                      align: TextAlign.center,
                                                      size: 12),
                                                ],
                                              ),
                                              if (_knowledgeTestController
                                                      .activeMenu ==
                                                  TestCategory.EXAM)
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                          onPressed: () {},
                                          padding: EdgeInsets.zero,
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
