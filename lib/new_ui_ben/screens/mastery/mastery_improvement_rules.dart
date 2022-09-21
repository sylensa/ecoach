import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/rule_step.dart';
import '../../widgets/steps_rules_container.dart';
import 'mastery_improvement.dart';

class MasteryImprovementRules extends StatelessWidget {
  final Function onTap;
  const MasteryImprovementRules({ required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Mastery Improvement',
          style: TextStyle(
              fontFamily: 'Cocon', fontWeight: FontWeight.w700, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          // Get.to(() => const MasteryImprovement());
          onTap();
        },
        child: Container(
          color: const Color(0xFF00C9B9),
          height: 60,
          alignment: Alignment.center,
          child: const Text(
            'Start Assesment',
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
                "Spot weaknesses and improve upon them",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(255, 255, 255, 0.5)),
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
              const StepRulesContainer(
                ruleSteps: [
                  RuleStep(
                    step: 1,
                    desc: 'Test an assessment across all topics.',
                  ),
                  RuleStep(
                    step: 2,
                    desc:
                        'The topics with poor performance would be singled out',
                  ),
                  RuleStep(
                    step: 3,
                    desc:
                        'The singled-out topics will then be arranged in order of mastery',
                  ),
                  RuleStep(
                    step: 4,
                    desc:
                        'The singled-out topics will then be arranged in order of mastery',
                  ),
                  RuleStep(
                    step: 5,
                    desc:
                        'The singled-out topics will then be arranged in order of mastery',
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Image.asset('assets/images/learn_mode2/Archery-pana.png'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
