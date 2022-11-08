import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_questions.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/quiz/quiz_essay_page.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizCover extends StatelessWidget {
  QuizCover(
    this.user,
    this.questions, {
    Key? key,
    this.level,
    required this.name,
    this.type = TestType.NONE,
    this.category = TestCategory.NONE,
    this.theme = QuizTheme.GREEN,
    this.course,
    this.time = 300,
    this.diagnostic = false,
  }) : super(key: key);

  User user;
  Level? level;
  Course? course;
  List<Question> questions;
  bool diagnostic;
  String name;
  final TestCategory category;
  final TestType type;
  int time;
  QuizTheme theme;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (questions.length == 0) {
      backgroundColor = Colors.white;
    } else if (theme == QuizTheme.GREEN) {
      backgroundColor = const Color(0xFF00C664);
    } else {
      backgroundColor = const Color(0xFFAAD4FA);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        elevation: 0,
      ),
      body: Container(
        color: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: -100,
              right: -140,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: questions.length == 0
                      ? AssetImage('assets/images/deep_pool_gray_raw.png')
                      : theme == QuizTheme.GREEN
                          ? AssetImage('assets/images/deep_pool_green.png')
                          : AssetImage('assets/images/deep_pool_blue.png'),
                )),
              ),
            ),
            Positioned(
              child: Container(
                child: questions.length == 0
                    ? Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  SizedBox(height: 180, width: double.infinity),
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
                                    TestCategory.SAVED == category ?"Ensure you have save questions for this the course package" : "Ensure you have downloaded the course package",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (questions.length == 0)

                            AdeoFilledButton(
                              label: TestCategory.SAVED == category ? "You haven't saved any questions yet" : 'Download Package',
                              fontSize: 16,
                              size: Sizes.large,

                              onPressed: () {
                                if(TestCategory.SAVED == category ){
                                  Navigator.pop(context);
                                }else{
                                  Navigator.pushAndRemoveUntil(

                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainHomePage(
                                        user,
                                        index: 2,
                                      ),
                                    ),
                                        (Route<dynamic> route) => true,
                                  );
                                }

                              },
                            )
                          else if (theme == QuizTheme.GREEN)
                            AdeoOutlinedButton(
                              label: 'Back',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          else if (theme == QuizTheme.BLUE)
                            AdeoFilledButton(
                              label: 'Back',
                              background: kAdeoBlue2,
                              size: Sizes.large,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          SizedBox(height: 56),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 120,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text("Test Type",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  ":${category.toString().split(".")[1]}",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text(
                                  "Questions",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  type != TestType.SPEED
                                      ? ":${questions.length}"
                                      : "---",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130,
                                child: Text("Time",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 160,
                                child: type != TestType.UNTIMED
                                    ? Text(
                                        ":${NumberFormat('00').format(Duration(seconds: time).inMinutes)}:${NumberFormat('00').format(Duration(seconds: time).inSeconds % 60)}",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))
                                    : Text("Untimed",
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            "answer all questions",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(
                            height: 170,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                   goTo(context,
                                       category == TestCategory.ESSAY ?
                                    QuizEssayView(
                                     user,
                                     questions,
                                     name: name,
                                     course: course,
                                     timeInSec: time,
                                     type: type,
                                     level: level,
                                   ) :
                                    QuizQuestion(
                                     controller: QuizController(
                                       user,
                                       course!,
                                       questions: questions,
                                       level: level,
                                       name: name,
                                       time: time,
                                       type: type,
                                       challengeType: category,
                                     ),
                                     theme: theme,
                                     diagnostic: diagnostic,
                                   ),
                                     replace: true
                                   );
                                  },
                                  child: Text(
                                    "Let's go",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.fromLTRB(35, 10, 35, 10)),
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
