import 'package:flutter/material.dart';

class BulletRule extends StatelessWidget {
  final String rule;
  const BulletRule({Key? key, required this.rule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Icon(Icons.circle, color: Colors.white, size: 8,),
            ),
            const SizedBox(width: 10,),
            Flexible(child: Text(rule, style: const TextStyle(color: Colors.white70, fontSize: 15),))
          ],
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}
