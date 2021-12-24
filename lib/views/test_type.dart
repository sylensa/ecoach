import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/customize.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/views/test_type_list.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/widgets/CoursesPageHeader.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

enum TestType { SPEED, KNOWLEDGE, UNTIMED, CUSTOMIZED, DIAGNOSTIC, NONE }
enum TestCategory { MOCK, EXAM, TOPIC, ESSAY, SAVED, BANK, NONE }

class TestTypeView extends StatefulWidget {
  static const String routeName = '/testtype';
  TestTypeView(this.user, this.course, {Key? key}) : super(key: key);
  User user;
  Course course;

  @override
  _TestTypeViewState createState() => _TestTypeViewState();
}

class _TestTypeViewState extends State<TestTypeView> {
  TestType testType = TestType.NONE;
  TestCategory testCategory = TestCategory.NONE;

  @override
  void initState() {
    super.initState();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "Choose your test type",
              //       style: kPageHeaderStyle,
              //       textAlign: TextAlign.center,
              //     ),
              //   ],
              // ),
              // SizedBox(height: 12),
              // Container(
              //   width: 280,
              //   child: Divider(
              //     thickness: 1.5,
              //     color: kDividerColor,
              //   ),
              // ),
              // SizedBox(height: 32),
              CoursesPageHeader(
                pageHeading: "Choose your test type",
              ),
              MultiPurposeCourseCard(
                title: 'Speed',
                subTitle: 'Accuracy matters , don\'t let the clock run down',
                iconURL: 'assets/icons/courses/speed.png',
                onTap: () {
                  showTestCat(TestType.SPEED);
                },
              ),
              MultiPurposeCourseCard(
                title: 'Knowledge',
                subTitle: 'Standard test',
                iconURL: 'assets/icons/courses/knowledge.png',
                onTap: () {
                  showTestCat(TestType.KNOWLEDGE);
                },
              ),
              MultiPurposeCourseCard(
                title: 'Marathon',
                subTitle: 'Race to complete all questions ',
                iconURL: 'assets/icons/courses/marathon.png',
                onTap: () {},
              ),
              MultiPurposeCourseCard(
                title: 'Autopilot',
                subTitle: 'Completing a course one topic at a time',
                iconURL: 'assets/icons/courses/autopilot.png',
                onTap: () {},
              ),
              MultiPurposeCourseCard(
                title: 'Customised',
                subTitle: 'Create your own kind of quiz',
                iconURL: 'assets/icons/courses/customised.png',
                onTap: () {
                  showTestCat(TestType.CUSTOMIZED);
                },
              ),
              MultiPurposeCourseCard(
                title: 'Untimed',
                subTitle: 'Practice mode , no pressure',
                iconURL: 'assets/icons/courses/untimed.png',
                onTap: () {
                  showTestCat(TestType.UNTIMED);
                },
              ),
              // GridView(
              //   shrinkWrap: true,
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2),
              //   children: [
              //     getTypeButton(
              //         AssetImage("assets/images/speedometer.png"), "Speed", () {
              //       showTestCat(TestType.SPEED);
              //     }),
              //     getTypeButton(
              //         AssetImage("assets/images/brain.png"), "Knowledge", () {
              //       showTestCat(TestType.KNOWLEDGE);
              //     }),
              //     getTypeButton(
              //         AssetImage("assets/images/infinite.png"), "Untimed", () {
              //       showTestCat(TestType.UNTIMED);
              //     }),
              //     getTypeButton(
              //         AssetImage("assets/images/customize.png"), "Customized",
              //         () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) {
              //         return Customize(widget.user, widget.course);
              //       }));
              //     }),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //         child: OutlinedButton(
              //             style: ButtonStyle(
              //                 backgroundColor:
              //                     MaterialStateProperty.all(Colors.white)),
              //             onPressed: () {},
              //             child: Padding(
              //               padding: const EdgeInsets.all(15.0),
              //               child: Text('View Analysis'),
              //             ))),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  getTypeButton(ImageProvider image, String name, Function()? callback) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 12),
      child: OutlinedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(134, 157)),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
          onPressed: callback != null ? callback : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: image,
              ),
              Text(name),
            ],
          )),
    );
  }

  showTestCat(TestType testType) {
    getTest() {
      Future futureList;
      switch (testCategory) {
        case TestCategory.MOCK:
          futureList = TestController().getMockTests(widget.course);
          break;
        case TestCategory.EXAM:
          futureList = TestController().getExamTests(widget.course);
          break;
        case TestCategory.TOPIC:
          print("future topic");
          futureList = TestController().getTopics(widget.course);
          break;
        case TestCategory.ESSAY:
          futureList = TestController().getEssays(widget.course, 5);
          break;
        case TestCategory.SAVED:
          futureList = TestController().getSavedTests(widget.course);
          break;
        case TestCategory.BANK:
          futureList = TestController().getBankTest(widget.course);
          break;
        default:
          futureList = TestController().getBankTest(widget.course);
      }

      futureList.then((data) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          Widget? widgetView;
          print("selecting test");
          print(testCategory);
          switch (testCategory) {
            case TestCategory.MOCK:
              List<Question> questions = data as List<Question>;
              widgetView = QuizCover(
                widget.user,
                questions,
                course: widget.course,
                type: testType,
                theme: QuizTheme.BLUE,
                category: testCategory.toString().split(".")[1],
                time: testType == TestType.SPEED ? 30 : questions.length * 60,
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
              );
              break;
            case TestCategory.TOPIC:
              print("case topic");
              widgetView = TestTypeListView(
                widget.user,
                widget.course,
                data,
                testType,
                title: "Topic",
                multiSelect: true,
              );
              break;
            case TestCategory.ESSAY:
              List<Question> questions = data as List<Question>;
              widgetView = QuizCover(
                widget.user,
                questions,
                category: testCategory.toString().split(".")[1],
                course: widget.course,
                type: testType,
                theme: QuizTheme.BLUE,
                time: questions.length * 60 * 15,
                name: "Essays",
              );
              break;
            case TestCategory.SAVED:
              List<Question> questions = data as List<Question>;
              widgetView = QuizCover(
                widget.user,
                questions,
                category: testCategory.toString().split(".")[1],
                course: widget.course,
                theme: QuizTheme.BLUE,
                time: testType == TestType.SPEED ? 30 : questions.length * 60,
                name: "Saved Test",
              );
              break;
            case TestCategory.BANK:
              widgetView = TestTypeListView(
                  widget.user, widget.course, data, testType,
                  title: "Bank");
              break;
            default:
              widgetView = null;
          }
          return widgetView!;
        }));
      });
    }

    showDialog(
        context: context,
        builder: (context) {
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
            backgroundColor: kPageBackgroundGray,
            body: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Choose Your Challenge",
                  //       style: kPageHeaderStyle,
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 12),
                  // Container(
                  //   width: 280,
                  //   child: Divider(
                  //     thickness: 1.5,
                  //     color: kDividerColor,
                  //   ),
                  // ),
                  // SizedBox(height: 32),
                  CoursesPageHeader(
                    pageHeading: "Choose Your Challenge",
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MultiPurposeCourseCard(
                            title: 'Mock',
                            subTitle: 'Take  a random test across topics',
                            iconURL: 'assets/icons/courses/mock.png',
                            onTap: () {
                              testCategory = TestCategory.MOCK;
                              getTest();
                            },
                          ),
                          MultiPurposeCourseCard(
                            title: 'Topic',
                            subTitle: 'Take a test on any topic',
                            iconURL: 'assets/icons/courses/topic.png',
                            onTap: () {
                              testCategory = TestCategory.TOPIC;
                              getTest();
                            },
                          ),
                          MultiPurposeCourseCard(
                            title: 'Exam',
                            subTitle: 'Try out sample exams ie. objectives',
                            iconURL: 'assets/icons/courses/exam.png',
                            onTap: () {
                              testCategory = TestCategory.EXAM;
                              getTest();
                            },
                          ),
                          MultiPurposeCourseCard(
                            title: 'Essay',
                            subTitle: 'Essay type questions',
                            iconURL: 'assets/icons/courses/essay.png',
                            onTap: () {
                              testCategory = TestCategory.ESSAY;
                              getTest();
                            },
                          ),
                          MultiPurposeCourseCard(
                            title: 'Bank',
                            subTitle: 'Curated Test banks',
                            iconURL: 'assets/icons/courses/bank.png',
                            onTap: () {
                              testCategory = TestCategory.BANK;
                              getTest();
                            },
                          ),
                          MultiPurposeCourseCard(
                            title: 'Saved',
                            subTitle: 'The questions that matter to you',
                            iconURL: 'assets/icons/courses/saved.png',
                            onTap: () {
                              testCategory = TestCategory.SAVED;
                              getTest();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     Column(
                  //       children: [
                  //         getTestCatButton("Mock", () {
                  //           testCategory = TestCategory.MOCK;
                  //           getTest();
                  //         }),
                  //         if (testType != TestType.UNTIMED)
                  //           getTestCatButton("Exam", () {
                  //             testCategory = TestCategory.EXAM;
                  //             getTest();
                  //           }),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         getTestCatButton("Topic", () {
                  //           testCategory = TestCategory.TOPIC;
                  //           getTest();
                  //         }),
                  //         if (testType != TestType.SPEED)
                  //           getTestCatButton("Essay", () {
                  //             testCategory = TestCategory.ESSAY;
                  //             getTest();
                  //           }),
                  //       ],
                  //     ),
                  //     Column(
                  //       children: [
                  //         // getTestCatButton("Saved", () {
                  //         //   testCategory = TestCategory.SAVED;

                  //         //   getTest();
                  //         // }),
                  //         getTestCatButton("Bank", () {
                  //           testCategory = TestCategory.BANK;

                  //           getTest();
                  //         }),
                  //       ],
                  //     )
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 60,
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: OutlinedButton(
                  //             style: ButtonStyle(
                  //                 backgroundColor: MaterialStateProperty.all(
                  //                     Colors.white)),
                  //             onPressed: () {},
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(15.0),
                  //               child: Text('View Analysis'),
                  //             ))),
                  //   ],
                  // )
                ],
              ),
            ),
          );
        }).then((value) {});
  }

  getTestCatButton(String name, Function()? callback) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 12),
      child: OutlinedButton(
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(Size(100, 132)),
            backgroundColor: MaterialStateProperty.all(Colors.white)),
        onPressed: callback != null ? callback : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}

class TestNameAndCount {
  String name;
  int? id;
  int count;
  int totalCount;
  TestCategory? category;

  TestNameAndCount(this.name, this.count, this.totalCount,
      {this.id, this.category});

  double get progress {
    return count / totalCount;
  }
}
