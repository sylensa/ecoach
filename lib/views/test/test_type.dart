import 'package:ecoach/database/conquest_test_taken_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/autopilot/autopilot_introit.dart';
import 'package:ecoach/views/conquest/conquest_onboarding.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/review/review_onboarding.dart';
import 'package:ecoach/views/review/review_questions.dart';
import 'package:ecoach/views/speed/SpeedTestIntro.dart';
import 'package:ecoach/views/customized_test/customized_test_introit.dart';
import 'package:ecoach/views/marathon/marathon_introit.dart';
import 'package:ecoach/views/test/test_challenge_list.dart';
import 'package:ecoach/views/treadmill/treadmill_introit.dart';
import 'package:ecoach/views/treadmill/treadmill_welcome.dart';
import 'package:ecoach/widgets/adeo_dialog.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

import '../../controllers/test_controller.dart';
import '../../controllers/treadmill_controller.dart';
import '../../models/treadmill.dart';
import '../treadmill/treadmill_save_resumption_menu.dart';

class TestTypeView extends StatefulWidget {
  static const String routeName = '/testtype';
  TestTypeView(
    this.user,
    this.course,
  );
  User user;
  Course course;

  @override
  _TestTypeViewState createState() => _TestTypeViewState();
}

class _TestTypeViewState extends State<TestTypeView> {
  TestType testType = TestType.NONE;
  TestCategory testCategory = TestCategory.NONE;
  String selectedConquestType = '';
  List<ListNames> conquestTypes = [ListNames(name: "Unseen",id: "1"),ListNames(name: "Unanswered",id: "2"),ListNames(name: "Wrong answered",id: "3"),];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SET THE BACK BUTTON TO MOVE BACK TO THE COURSE DETAILS PAGE,
    //BECAUSE WE ARE IN A TEST PAGE AND I AM PUSHING FROM NEW TEST PAGE
    //to choose test type and don't want it to pop back into the test
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(
            context, ModalRoute.withName(CoursesDetailsPage.routeName));
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(child: Icon(Icons.arrow_back_ios)),
                      ),
                      PageHeader(pageHeading: "Choose your test type"),
                      Container()
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      MultiPurposeCourseCard(
                        title: 'Speed',
                        subTitle:
                            'Accuracy matters , don\'t let the clock run down',
                        iconURL: 'assets/icons/courses/speed.png',
                        onTap: () {
                          // showTestCat(TestType.SPEED);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return TestChallengeList(
                          //         testType: TestType.SPEED,
                          //         course: widget.course,
                          //         user: widget.user,
                          //       );
                          //     },
                          //   ),
                          // );
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return SpeedTestIntroit(
                          //         user: widget.user,
                          //         course: widget.course,
                          //       );
                          //     },
                          //   ),
                          // );
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Knowledge',
                        subTitle: 'Standard test',
                        iconURL: 'assets/icons/courses/knowledge.png',
                        onTap: () {
                          // showTestCat(TestType.KNOWLEDGE);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TestChallengeList(
                                  testType: TestType.KNOWLEDGE,
                                  course: widget.course,
                                  user: widget.user,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Marathon',
                        subTitle: 'Race to complete all questions',
                        iconURL: 'assets/icons/courses/marathon.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return MarathonIntroit(
                                    widget.user, widget.course);
                              },
                            ),
                          );
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Autopilot',
                        subTitle: 'Completing a course one topic at a time',
                        iconURL: 'assets/icons/courses/autopilot.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AutopilotIntroit(
                                    widget.user, widget.course);
                              },
                            ),
                          );
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Treadmill',
                        subTitle: 'Crank up the speed, how far can you go?',
                        iconURL: 'assets/icons/courses/treadmill.png',
                        onTap: () async {
                          Treadmill? treadmill = await TestController()
                              .getCurrentTreadmill(widget.course);
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
                                builder: (context) =>
                                    TreadmillSaveResumptionMenu(
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

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return TreadmillIntroit(widget.user, widget.course);
                          //     },
                          //   ),
                          // );
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Customised',
                        subTitle: 'Create your own kind of quiz',
                        iconURL: 'assets/icons/courses/customised.png',
                        onTap: () {
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
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Timeless',
                        subTitle: 'Practice mode, no pressure.',
                        iconURL: 'assets/icons/courses/untimed.png',
                        onTap: () {
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
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Review',
                        subTitle: 'Know the answer to every question',
                        iconURL: 'assets/icons/courses/review.png',
                        onTap: () {
                          goTo(
                              context,
                              ReviewOnBoarding(
                                user: widget.user,
                                course: widget.course,
                                testType: testType,
                              ));
                          // return showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AdeoDialog(
                          //       title: 'Review',
                          //       content:
                          //           'Know the answer to every question. Feature coming soon.',
                          //       actions: [
                          //         AdeoDialogAction(
                          //           label: 'Dismiss',
                          //           onPressed: () {
                          //             Navigator.of(context).pop();
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                      ),
                      MultiPurposeCourseCard(
                        title: 'Conquest',
                        subTitle: 'Prepare for battle, attempt everything',
                        iconURL: 'assets/icons/courses/conquest.png',
                        onTap: () {
                          conquestModalBottomSheet(context);


                          // return showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AdeoDialog(
                          //       title: 'Conquest',
                          //       content:
                          //           'Prepare for battle, attempt everything. Feature coming soon.',
                          //       actions: [
                          //         AdeoDialogAction(
                          //           label: 'Dismiss',
                          //           onPressed: () {
                          //             Navigator.of(context).pop();
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  conquestModalBottomSheet(context,) {
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
                        child: Center(child:Image.asset("assets/images/flag.png")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Conquest",
                            color: kAdeoGray3,
                            weight: FontWeight.bold,
                            align: TextAlign.center,size: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: conquestTypes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MaterialButton(
                                  onPressed: () async{
                                    // await ConquestTestTakenDB().conquestDeleteAll();
                                    // await QuestionDB().deleteAllConquestTest();
                                    List<Question> listQuestions = [];
                                      if(conquestTypes[index].name.toUpperCase() == "UNSEEN"){
                                        testType = TestType.UNSEEN;
                                        listQuestions = await QuestionDB().getConquestQuestionByCorrectUnAttempted(widget.course.id!,confirm: 0,unseen: true);
                                        if(listQuestions.isEmpty){
                                          listQuestions = await QuestionDB().getQuestionsByCourseId(widget.course.id!);
                                          print("$testType:$listQuestions");
                                        }
                                      }else if(conquestTypes[index].name.toUpperCase() == "UNANSWERED"){
                                        testType = TestType.UNANSWERED;
                                        listQuestions = await QuestionDB().getConquestQuestionByCorrectUnAttempted(widget.course.id!,confirm: 0,);
                                        print("$testType:$listQuestions");
                                      }else{
                                        testType = TestType.WRONGLYANSWERED;
                                        listQuestions = await QuestionDB().getConquestQuestionByCorrectUnAttempted(widget.course.id!,confirm: 1);
                                        print("$testType:$listQuestions");

                                      }
                                    stateSetter(() {
                                     selectedConquestType = conquestTypes[index].name;
                                     });
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
                                        color: selectedConquestType == conquestTypes[index].name ? Color(0XFFFD6363) :  Colors.white,
                                        border: Border.all(color: selectedConquestType == conquestTypes[index].name ? Colors.transparent : Colors.black,width: 1),
                                        borderRadius: BorderRadius.circular(10)),

                                    child:sText("${conquestTypes[index].name}", color: selectedConquestType == conquestTypes[index].name ? Colors.white : Colors.black, weight: FontWeight.w500,align: TextAlign.center),
                                  ),
                                );
                              })),
                    ],
                  ));
            },
          );
        });
  }

}
