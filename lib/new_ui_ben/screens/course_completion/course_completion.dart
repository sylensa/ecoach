import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/course_completion_utils.dart';
import '../../utils/revision_utils.dart';
import '../../widgets/bullet_rules_container.dart';
import '../revision/chose_revision_mode.dart';

class CourseCompletion extends StatelessWidget {
  final Function proceed;
  const CourseCompletion({required this.proceed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Course Completion',
          style: TextStyle(
              fontFamily: 'Cocon', fontWeight: FontWeight.w700, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          // Get.to(() =>  ChoseRevisionMode());
          proceed();
        },
        child: Container(
          color: const Color(0xFF00C9B9),
          height: 60,
          alignment: Alignment.center,
          child: const Text(
            'Start Studies',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Go through the entire course one topic at a time",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(
                    255,
                    255,
                    255,
                    0.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  const Text(
                    '10',
                    style: TextStyle(
                      fontFamily: 'Cocon',
                      fontSize: 95,
                      color: Color(0xFF00C9B9),
                    ),
                  ),
                  Image.asset('assets/images/learn_mode2/shadow.png')
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "topics to be revised",
                style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Color.fromRGBO(255, 255, 255, 0.5)),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Rules',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              BulletRulesContainer(
                rules: courseCompletionRulesList,
              )
            ],
          ),
        ),
      ),
    );
  }
}
