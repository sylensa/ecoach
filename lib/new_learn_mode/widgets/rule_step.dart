import 'package:flutter/material.dart';

class RuleStep extends StatelessWidget {
  final int step;
  final String desc;
  const RuleStep({Key? key, required this.step, required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step $step', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),),
        Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 13),),
        const SizedBox(height: 25,)
      ],
    );
  }
}
