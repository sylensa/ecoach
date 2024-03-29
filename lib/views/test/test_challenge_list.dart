import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/speed/speed_quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_essay_page.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/views/test/test_type_list.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class TestChallengeList extends StatelessWidget {
  static const String routeName = '/courses/challenge';

  TestChallengeList({
    required this.testType,
    required this.course,
    required this.user,
     this.mode = "quiz",
    this.time,
    Key? key,
  }) : super(key: key);

  final User user;
  final TestType testType;
  final Course course;
  int? time;
  String mode;

  getTest(BuildContext context, TestCategory testCategory) {
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
        futureList = TestController().getSavedTests(course,limit: 10);
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
        Navigator.pushReplacement(
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
                          time: testType == TestType.SPEED
                              ? time!
                              : questions.length * 60,
                          name: "Mock Test",
                        )
                      : QuizCover(
                          user,
                          questions,
                          course: course,
                          type: testType,
                          theme: QuizTheme.BLUE,
                          category: testCategory,
                          time: testType == TestType.SPEED
                              ? 30
                              : questions.length * 60,
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
                    time: time,
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
                    time: time,
                    testCategory: TestCategory.TOPIC,
                  );
                  break;
                case TestCategory.ESSAY:
                  widgetView = TestTypeListView(
                    user,
                    course,
                    data,
                    testType,
                    time: time,
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
                      time: testType == TestType.SPEED ?  time! : questions.length * 60,
                      name: "Saved Test",
                    );


                  break;
                case TestCategory.BANK:
                  widgetView = TestTypeListView(
                    user,
                    course,
                    data,
                    testType,
                    time: time,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 20, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      child:  Icon(Icons.arrow_back_ios,color: Colors.black,),
                    ),
                  ),

                  PageHeader(
                    pageHeading: "Choose Your Challenge",
                  ),
                  Container()
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    MultiPurposeCourseCard(
                      title: 'Mock',
                      subTitle: 'Take a random test across topics',
                      iconURL: 'assets/icons/courses/mock.png',
                      onTap: () {
                        getTest(context, TestCategory.MOCK);
                      },
                    ),
                    MultiPurposeCourseCard(
                      title: 'Topic',
                      subTitle: 'Take a test on any topic',
                      iconURL: 'assets/icons/courses/topic.png',
                      onTap: () {
                        getTest(context, TestCategory.TOPIC);
                      },
                    ),
                    if (testType != TestType.CUSTOMIZED)
                      MultiPurposeCourseCard(
                        title: 'Exam',
                        subTitle: 'Try out sample exams ie. objectives',
                        iconURL: 'assets/icons/courses/exam.png',
                        onTap: () {
                          getTest(context, TestCategory.EXAM);
                        },
                      ),
                    MultiPurposeCourseCard(
                      title: 'Essay',
                      subTitle: 'Essay type questions',
                      iconURL: 'assets/icons/courses/essay.png',
                      onTap: () {
                        getTest(context, TestCategory.ESSAY);
                      },
                    ),
                    MultiPurposeCourseCard(
                      title: 'Bank',
                      subTitle: 'Curated Test banks',
                      iconURL: 'assets/icons/courses/bank.png',
                      onTap: () {
                        getTest(context, TestCategory.BANK);
                      },
                    ),
                    if (testType != TestType.CUSTOMIZED)
                      MultiPurposeCourseCard(
                        title: 'Saved',
                        subTitle: 'The questions that matter to you',
                        iconURL: 'assets/icons/courses/saved.png',
                        onTap: () {
                          getTest(context, TestCategory.SAVED);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
