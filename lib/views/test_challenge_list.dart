import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/views/quiz_essay_page.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/views/test_type_list.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TestChallengeList extends StatelessWidget {
  TestChallengeList({
    required this.testType,
    required this.course,
    required this.user,
    Key? key,
  }) : super(key: key);

  final User user;
  final TestType testType;
  final Course course;
  TestCategory testCategory = TestCategory.NONE;

  getTest(BuildContext context) {
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
        futureList = TestController().getEssays(course, 5);
        break;
      case TestCategory.SAVED:
        futureList = TestController().getSavedTests(course);
        break;
      case TestCategory.BANK:
        futureList = TestController().getBankTest(course);
        break;
      default:
        futureList = TestController().getBankTest(course);
    }

    futureList.then(
      (data) {
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              Widget? widgetView;
              switch (testCategory) {
                case TestCategory.MOCK:
                  List<Question> questions = data as List<Question>;
                  widgetView = QuizCover(
                    user,
                    questions,
                    course: course,
                    type: testType,
                    theme: QuizTheme.BLUE,
                    category: testCategory,
                    time:
                        testType == TestType.SPEED ? 30 : questions.length * 60,
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
                  );
                  break;
                case TestCategory.ESSAY:
                  List<Question> questions = data as List<Question>;
                  widgetView = QuizCover(
                    user,
                    questions,
                    category: testCategory,
                    course: course,
                    type: testType,
                    theme: QuizTheme.BLUE,
                    time: questions.length * 60 * 15,
                    name: "Essays",
                  );
                  // widgetView = QuizEssayView(
                  //   user,
                  //   questions,
                  //   name: 'Essays',
                  //   course: course,
                  //   timeInSec: 300,
                  //   type: testType,
                  // );
                  break;
                case TestCategory.SAVED:
                  List<Question> questions = data as List<Question>;
                  widgetView = QuizCover(
                    user,
                    questions,
                    category: testCategory,
                    course: course,
                    theme: QuizTheme.BLUE,
                    time:
                        testType == TestType.SPEED ? 30 : questions.length * 60,
                    name: "Saved Test",
                  );
                  break;
                case TestCategory.BANK:
                  widgetView = TestTypeListView(user, course, data, testType,
                      title: "Bank");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PageHeader(
              pageHeading: "Choose Your Challenge",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MultiPurposeCourseCard(
                      title: 'Mock',
                      subTitle: 'Take a random test across topics',
                      iconURL: 'assets/icons/courses/mock.png',
                      onTap: () {
                        testCategory = TestCategory.MOCK;
                        getTest(context);
                      },
                    ),
                    MultiPurposeCourseCard(
                      title: 'Topic',
                      subTitle: 'Take a test on any topic',
                      iconURL: 'assets/icons/courses/topic.png',
                      onTap: () {
                        testCategory = TestCategory.TOPIC;
                        getTest(context);
                      },
                    ),
                    if (testType != TestType.CUSTOMIZED)
                      MultiPurposeCourseCard(
                        title: 'Exam',
                        subTitle: 'Try out sample exams ie. objectives',
                        iconURL: 'assets/icons/courses/exam.png',
                        onTap: () {
                          testCategory = TestCategory.EXAM;
                          getTest(context);
                        },
                      ),
                    MultiPurposeCourseCard(
                      title: 'Essay',
                      subTitle: 'Essay type questions',
                      iconURL: 'assets/icons/courses/essay.png',
                      onTap: () {
                        testCategory = TestCategory.ESSAY;
                        getTest(context);
                      },
                    ),
                    MultiPurposeCourseCard(
                      title: 'Bank',
                      subTitle: 'Curated Test banks',
                      iconURL: 'assets/icons/courses/bank.png',
                      onTap: () {
                        testCategory = TestCategory.BANK;
                        getTest(context);
                      },
                    ),
                    if (testType != TestType.CUSTOMIZED)
                      MultiPurposeCourseCard(
                        title: 'Saved',
                        subTitle: 'The questions that matter to you',
                        iconURL: 'assets/icons/courses/saved.png',
                        onTap: () {
                          testCategory = TestCategory.SAVED;
                          getTest(context);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// showTestCat(TestType testType) {
//   getTest(context) {
//     Future futureList;
//     switch (testCategory) {
//       case TestCategory.MOCK:
//         futureList = TestController().getMockTests(course);
//         break;
//       case TestCategory.EXAM:
//         futureList = TestController().getExamTests(course);
//         break;
//       case TestCategory.TOPIC:
//         print("future topic");
//         futureList = TestController().getTopics(course);
//         break;
//       case TestCategory.ESSAY:
//         futureList = TestController().getEssays(course, 5);
//         break;
//       case TestCategory.SAVED:
//         futureList = TestController().getSavedTests(course);
//         break;
//       case TestCategory.BANK:
//         futureList = TestController().getBankTest(course);
//         break;
//       default:
//         futureList = TestController().getBankTest(course);
//     }

//     futureList.then((data) {
//       Navigator.pop(context);
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         Widget? widgetView;
//         print("selecting test");
//         print(testCategory);
//         switch (testCategory) {
//           case TestCategory.MOCK:
//             List<Question> questions = data as List<Question>;
//             widgetView = QuizCover(
//               user,
//               questions,
//               course: course,
//               type: testType,
//               theme: QuizTheme.BLUE,
//               category: testCategory.toString().split(".")[1],
//               time: testType == TestType.SPEED ? 30 : questions.length * 60,
//               name: "Mock Test",
//             );
//             break;
//           case TestCategory.EXAM:
//             widgetView = TestTypeListView(
//               user,
//               course,
//               data,
//               testType,
//               title: "Exams",
//             );
//             break;
//           case TestCategory.TOPIC:
//             print("case topic");
//             widgetView = TestTypeListView(
//               user,
//               course,
//               data,
//               testType,
//               title: "Topic",
//               multiSelect: true,
//             );
//             break;
//           case TestCategory.ESSAY:
//             List<Question> questions = data as List<Question>;
//             widgetView = QuizCover(
//               user,
//               questions,
//               category: testCategory.toString().split(".")[1],
//               course: course,
//               type: testType,
//               theme: QuizTheme.BLUE,
//               time: questions.length * 60 * 15,
//               name: "Essays",
//             );
//             break;
//           case TestCategory.SAVED:
//             List<Question> questions = data as List<Question>;
//             widgetView = QuizCover(
//               user,
//               questions,
//               category: testCategory.toString().split(".")[1],
//               course: course,
//               theme: QuizTheme.BLUE,
//               time: testType == TestType.SPEED ? 30 : questions.length * 60,
//               name: "Saved Test",
//             );
//             break;
//           case TestCategory.BANK:
//             widgetView = TestTypeListView(
//                 user, course, data, testType,
//                 title: "Bank");
//             break;
//           default:
//             widgetView = null;
//         }
//         return widgetView!;
//       }));
//     });
//   }

//   showDialog(
//       context: context,
//       builder: (context) {
//         return Scaffold(
//           // appBar: AppBar(
//           //   backgroundColor: Colors.transparent,
//           //   shadowColor: Colors.transparent,
//           //   leading: GestureDetector(
//           //     child: Icon(Icons.arrow_back_ios),
//           //     onTap: () {
//           //       Navigator.pop(context);
//           //     },
//           //   ),
//           // ),
//           backgroundColor: kPageBackgroundGray,
//           body: Padding(
//             padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     Text(
//                 //       "Choose Your Challenge",
//                 //       style: kPageHeaderStyle,
//                 //       textAlign: TextAlign.center,
//                 //     ),
//                 //   ],
//                 // ),
//                 // SizedBox(height: 12),
//                 // Container(
//                 //   width: 280,
//                 //   child: Divider(
//                 //     thickness: 1.5,
//                 //     color: kDividerColor,
//                 //   ),
//                 // ),
//                 // SizedBox(height: 32),
//                 CoursesPageHeader(
//                   pageHeading: "Choose Your Challenge",
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         MultiPurposeCourseCard(
//                           title: 'Mock',
//                           subTitle: 'Take  a random test across topics',
//                           iconURL: 'assets/icons/courses/mock.png',
//                           onTap: () {
//                             testCategory = TestCategory.MOCK;
//                             getTest(context);
//                           },
//                         ),
//                         MultiPurposeCourseCard(
//                           title: 'Topic',
//                           subTitle: 'Take a test on any topic',
//                           iconURL: 'assets/icons/courses/topic.png',
//                           onTap: () {
//                             testCategory = TestCategory.TOPIC;
//                             getTest(context);
//                           },
//                         ),
//                         MultiPurposeCourseCard(
//                           title: 'Exam',
//                           subTitle: 'Try out sample exams ie. objectives',
//                           iconURL: 'assets/icons/courses/exam.png',
//                           onTap: () {
//                             testCategory = TestCategory.EXAM;
//                             getTest(context);
//                           },
//                         ),
//                         MultiPurposeCourseCard(
//                           title: 'Essay',
//                           subTitle: 'Essay type questions',
//                           iconURL: 'assets/icons/courses/essay.png',
//                           onTap: () {
//                             testCategory = TestCategory.ESSAY;
//                             getTest(context);
//                           },
//                         ),
//                         MultiPurposeCourseCard(
//                           title: 'Bank',
//                           subTitle: 'Curated Test banks',
//                           iconURL: 'assets/icons/courses/bank.png',
//                           onTap: () {
//                             testCategory = TestCategory.BANK;
//                             getTest(context);
//                           },
//                         ),
//                         MultiPurposeCourseCard(
//                           title: 'Saved',
//                           subTitle: 'The questions that matter to you',
//                           iconURL: 'assets/icons/courses/saved.png',
//                           onTap: () {
//                             testCategory = TestCategory.SAVED;
//                             getTest(context);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 //   children: [
//                 //     Column(
//                 //       children: [
//                 //         getTestCatButton("Mock", () {
//                 //           testCategory = TestCategory.MOCK;
//                 //           getTest(context);
//                 //         }),
//                 //         if (testType != TestType.UNTIMED)
//                 //           getTestCatButton("Exam", () {
//                 //             testCategory = TestCategory.EXAM;
//                 //             getTest(context);
//                 //           }),
//                 //       ],
//                 //     ),
//                 //     Column(
//                 //       children: [
//                 //         getTestCatButton("Topic", () {
//                 //           testCategory = TestCategory.TOPIC;
//                 //           getTest(context);
//                 //         }),
//                 //         if (testType != TestType.SPEED)
//                 //           getTestCatButton("Essay", () {
//                 //             testCategory = TestCategory.ESSAY;
//                 //             getTest(context);
//                 //           }),
//                 //       ],
//                 //     ),
//                 //     Column(
//                 //       children: [
//                 //         // getTestCatButton("Saved", () {
//                 //         //   testCategory = TestCategory.SAVED;

//                 //         //   getTest(context);
//                 //         // }),
//                 //         getTestCatButton("Bank", () {
//                 //           testCategory = TestCategory.BANK;

//                 //           getTest(context);
//                 //         }),
//                 //       ],
//                 //     )
//                 //   ],
//                 // ),
//                 // SizedBox(
//                 //   height: 60,
//                 // ),
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //         child: OutlinedButton(
//                 //             style: ButtonStyle(
//                 //                 backgroundColor: MaterialStateProperty.all(
//                 //                     Colors.white)),
//                 //             onPressed: () {},
//                 //             child: Padding(
//                 //               padding: const EdgeInsets.all(15.0),
//                 //               child: Text('View Analysis'),
//                 //             ))),
//                 //   ],
//                 // )
//               ],
//             ),
//           ),
//         );
//       }).then((value) {});
// }
