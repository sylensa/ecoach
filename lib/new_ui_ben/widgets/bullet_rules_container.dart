

import 'package:flutter/material.dart';

import 'bullet_rule.dart';

class BulletRulesContainer extends StatelessWidget {
  final List<BulletRule> rules;
  const BulletRulesContainer({Key? key, required this.rules}) : super(key: key);

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
        children: rules,
      ),
    );
  }
}