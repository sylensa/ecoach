import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/layouts/test_introit_layout.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class TestTypeListView extends StatefulWidget {
  TestTypeListView(
    this.user,
    this.course,
    this.tests,
    this.type, {
    Key? key,
    this.title,
    this.multiSelect = false,
    this.testCategory = TestCategory.NONE,
    this.questionLimit = 40,
    this.time,
  }) : super(key: key);

  final User user;
  final Course course;
  final List<TestNameAndCount> tests;
  final TestType type;
  final TestCategory testCategory;
  String? title;
  bool multiSelect;
  int? questionLimit;
  int? time;

  @override
  _MockListViewState createState() => _MockListViewState();
}

class _MockListViewState extends State<TestTypeListView> {
  List<TestNameAndCount> testsSelected = [];
  Color selectedProgressColor = Color(0xFF2D3E50);
  Color selectedColor = Color(0xFF2D3E50);

  bool isSelected(TestNameAndCount test) {
    return testsSelected.contains(test);
  }

  @override
  void initState() {
    super.initState();
    // print(widget.tests);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tests.length == 0) {
      return TestIntroitLayout(
        background: Colors.white,
        backgroundImageURL: 'assets/images/deep_pool_gray.png',
        pages: [
          TestIntroitLayoutPage(
            foregroundColor: Colors.black,
            middlePiece: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100, width: double.infinity),
                  Text(
                    "There are no questions\nfor your selection",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Ensure you have downloaded the course package",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            footer: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AdeoFilledButton(
                  label: 'Download Package',
                  fontSize: 16,
                  size: Sizes.large,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainHomePage(
                                  widget.user,
                                  index: 4,
                                )),
                        (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PageHeader(
              pageHeading: "Select Your ${widget.title ?? 'Test'}",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 24.0,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.tests.length,
                  itemBuilder: (context, index) {
                    TestNameAndCount test = widget.tests[index];
                    if (test.name.trim() != '') {
                      return MultiPurposeCourseCard(
                        title: test.name,
                        subTitle: '',
                        progress: test.category == TestCategory.TOPIC
                            ? double.parse(
                                test.averageScore!.toStringAsFixed(2))
                            : null,
                        isActive: isSelected(test),
                        hasSmallHeading: true,
                        onTap: () {
                          if (isSelected(test)) {
                            testsSelected.remove(test);
                          } else {
                            if (!widget.multiSelect) {
                              testsSelected.clear();
                            }
                            testsSelected.add(test);
                          }
                          setState(() {});
                        },
                      );
                    } else
                      return SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: testsSelected.length > 0
          ? AdeoTextButton(
              onPressed: () async {
                List<Question> questions = [];
                switch (testsSelected[0].category) {
                  case TestCategory.BANK:
                  case TestCategory.EXAM:
                  case TestCategory.ESSAY:
                    questions = await TestController().getQuizQuestions(
                      testsSelected[0].id!,
                      limit: widget.questionLimit,
                    );
                    break;
                  case TestCategory.TOPIC:
                    List<int> topicIds = [];
                    testsSelected.forEach((element) {
                      topicIds.add(element.id!);
                    });
                    questions = await TestController().getTopicQuestions(
                      topicIds,
                      limit: () {
                        if (widget.type == TestType.CUSTOMIZED)
                          return widget.questionLimit;
                        return widget.type != TestType.SPEED ? 10 : 1000;
                      }(),
                    );
                    break;
                  default:
                    questions = await TestController().getMockQuestions(0);
                }
                // print(questions.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return QuizCover(
                        widget.user,
                        questions,
                        name: testsSelected[0].name,
                        type: widget.type,
                        theme: QuizTheme.BLUE,
                        category: testsSelected[0].category!,
                        time: widget.time != null
                            ? widget.time!
                            : widget.type == TestType.SPEED
                                ? 30
                                : questions.length * 60,
                        course: widget.course,
                      );
                    },
                  ),
                );
              },
              label: "Take Test",
              color: kAdeoBlue,
            )
          : SizedBox(),
    );
  }
}
