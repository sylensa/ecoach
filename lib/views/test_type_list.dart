import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:ecoach/widgets/CoursesPageHeader.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

class TestTypeListView extends StatefulWidget {
  TestTypeListView(this.user, this.course, this.tests, this.type,
      {Key? key,
      this.title,
      this.multiSelect = false,
      this.testCategory = TestCategory.NONE,
      this.questionLimit = 40,
      this.time})
      : super(key: key);

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
    print(widget.tests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   leading: GestureDetector(
      //     child: Icon(Icons.arrow_back_ios),
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      backgroundColor: Color(0xFFF6F6F6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "Select Your ${widget.title ?? 'Test'}",
          //       style: kPageHeaderStyle,
          //       textAlign: TextAlign.center,
          //     ),
          //   ],
          // ),
          // SizedBox(height: 12),
          // Container(
          //   width: 270,
          //   child: Divider(
          //     thickness: 1.5,
          //     color: kDividerColor,
          //   ),
          // ),
          // SizedBox(height: 32),
          CoursesPageHeader(
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
                    return MultiPurposeCourseCard(
                      title: test.name,
                      subTitle: '',
                      progress: test.category == TestCategory.TOPIC
                          ? double.parse(
                              (test.progress * 100).toStringAsFixed(2))
                          : double.parse(test.totalCount.toStringAsFixed(2)),
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
                    // return Padding(
                    //   padding: const EdgeInsets.fromLTRB(40, 14.0, 40, 14),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(10),
                    //     child: InkWell(
                    //       onTap: () {
                    //         if (isSelected(test)) {
                    //           testsSelected.remove(test);
                    //         } else {
                    //           if (!widget.multiSelect) {
                    //             testsSelected.clear();
                    //           }
                    //           testsSelected.add(test);
                    //         }
                    //         setState(() {});
                    //       },
                    //       child: LinearPercentIndicator(
                    //         lineHeight: 49,
                    //         animation: true,
                    //         padding:
                    //             const EdgeInsets.symmetric(horizontal: 0.0),
                    //         percent: widget.tests[index].progress,
                    //         backgroundColor: isSelected(test)
                    //             ? selectedColor
                    //             : Colors.white,
                    //         progressColor: isSelected(test)
                    //             ? selectedProgressColor
                    //             : Color(0xFFE5E5E5),
                    //         linearStrokeCap: LinearStrokeCap.butt,
                    //         center: Row(
                    //           children: [
                    //             Expanded(
                    //               child: SizedBox(
                    //                 height: 49,
                    //                 child: Stack(
                    //                   children: [
                    //                     Align(
                    //                       alignment: Alignment.center,
                    //                       child: Text(
                    //                         widget.tests[index].name,
                    //                         style: TextStyle(
                    //                             color: isSelected(test)
                    //                                 ? Colors.white
                    //                                 : Color(0xFF5D5D5D),
                    //                             fontSize: 17),
                    //                       ),
                    //                     ),
                    //                     Positioned(
                    //                       right: -20,
                    //                       child: Container(
                    //                         width: 50,
                    //                         height: 50,
                    //                         decoration: BoxDecoration(
                    //                             color: Colors.green,
                    //                             borderRadius:
                    //                                 BorderRadius.circular(
                    //                                     50)),
                    //                         child: Row(
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.center,
                    //                           children: [
                    //                             SizedBox(
                    //                               width: 5,
                    //                             ),
                    //                             Text(
                    //                               widget.tests[index]
                    //                                           .category ==
                    //                                       TestCategory.TOPIC
                    //                                   ? "${(widget.tests[index].progress * 100).floor()}%"
                    //                                   : "${widget.tests[index].totalCount}x",
                    //                               textAlign:
                    //                                   TextAlign.center,
                    //                               style: TextStyle(
                    //                                   color: Colors.white,
                    //                                   fontSize: 12),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );
                  }),
            ),
          ),
          if (testsSelected.length > 0)
            AdeoTextButton(
              onPressed: () async {
                List<Question> questions = [];
                print(testsSelected[0].category);
                switch (testsSelected[0].category) {
                  case TestCategory.BANK:
                  case TestCategory.EXAM:
                    print("exam and bank");
                    questions = await TestController().getQuizQuestions(
                        testsSelected[0].id!,
                        limit: widget.questionLimit);
                    break;
                  case TestCategory.TOPIC:
                    print("topic list");
                    List<int> topicIds = [];
                    testsSelected.forEach((element) {
                      print(element);
                      topicIds.add(element.id!);
                    });
                    questions = await TestController()
                        .getTopicQuestions(topicIds, limit: () {
                      if (widget.type == TestType.CUSTOMIZED)
                        return widget.questionLimit;
                      return widget.type != TestType.SPEED ? 10 : 1000;
                    }());
                    break;
                  default:
                    questions = await TestController().getMockQuestions(0);
                }
                print(questions.toString());
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return QuizCover(
                    widget.user,
                    questions,
                    name: testsSelected[0].name,
                    type: widget.type,
                    theme: QuizTheme.BLUE,
                    category:
                        testsSelected[0].category.toString().split(".")[1],
                    time: widget.time != null
                        ? widget.time!
                        : widget.type == TestType.SPEED
                            ? 30
                            : questions.length * 60,
                    course: widget.course,
                  );
                }));
              },
              label: "Take Test",
              color: kAdeoBlue,
            )
        ],
      ),
    );
  }
}
