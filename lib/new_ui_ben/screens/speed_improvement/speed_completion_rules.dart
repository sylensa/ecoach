
import 'package:ecoach/new_ui_ben/screens/speed_improvement/level_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/revision_utils.dart';
import '../../utils/speed_completion_utils.dart';
import '../../widgets/bullet_rules_container.dart';
import '../level_start_screen.dart';

class SpeedCompletionRules extends StatelessWidget {
  const SpeedCompletionRules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Speed Completion',
          style: TextStyle(
              fontFamily: 'Cocon', fontWeight: FontWeight.w700, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Get.to(() =>  LevelTwo());
        },
        child: Container(
          color: const Color(0xFF00C9B9),
          height: 60,
          alignment: Alignment.center,
          child: const Text(
            "Let's go",
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
                "A quick way to prep for your exam",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(255, 255, 255, 0.5)),
              ),
              const SizedBox(
                height: 40,
              ),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  const Text(
                    '6',
                    style: TextStyle(
                      fontFamily: 'Cocon',
                      fontSize: 95,
                      color: Color(0xFF00C9B9),
                    ),
                  ),
                  Image.asset('assets/images/shadow.png')
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              const Text(
                "levels",
                style: TextStyle(
                    fontSize: 29,
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
                
                rules: speedCompletionRulesList,
              )
            ],
          ),
        ),
      ),
    );
  }
}
