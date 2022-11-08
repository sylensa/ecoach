import 'package:flutter/material.dart';

import 'rule_step.dart';

class StepRulesContainer extends StatelessWidget {
  final List<RuleStep> ruleSteps;
  const StepRulesContainer({Key? key, required this.ruleSteps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF005CA5),
        borderRadius: BorderRadius.circular(10),

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ruleSteps,
      ),
    );
  }
}
