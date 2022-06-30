
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/questions/view/screens/quiz_questions.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StartAccessmentPage extends StatefulWidget {
  StartAccessmentPage(
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

  @override
  State<StartAccessmentPage> createState() => _StartAccessmentPageState();
}

class _StartAccessmentPageState extends State<StartAccessmentPage> {
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment'),

      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          print("object:${widget.questions.length}");

          goTo(context, QuizQuestion(
            controller: QuizController(
              widget.user,
              widget.course!,
              questions: widget.questions,
              name: widget.name,
              time: widget.time,
              type: widget.type,
              challengeType: widget.category,
            ),
            theme: widget.theme,
            diagnostic: widget.diagnostic,
          ),replace: true);
        },
        child: Container(
          color: kAccessmentButtonColor,
          padding: const EdgeInsets.all(15),
          child: const Text(
            'Begin Assessment',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            "assets/images/accessment_start_background.svg",
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Center(
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: const Text(
                    "This assessment helps us understand your weaknesses and strengths so as to help you prep better.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Image.asset(
                  'assets/images/analysis.png',
                  height: 239,
                  width: 239,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
