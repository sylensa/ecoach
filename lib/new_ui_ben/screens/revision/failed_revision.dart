import 'package:ecoach/new_ui_ben/screens/revision/widget/score_header.dart';
import 'package:flutter/material.dart';

class FailedRevision extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Color(0xFFF6F6F6),
        height: 47,
        child: Row(children: [
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'review',
                style: TextStyle(fontSize: 20, color: Color(0xFFA2A2A2)),
              ),
            ),
          ),
          const VerticalDivider(
            color: Color(0xFF707070),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'revise',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFA2A2A2),
                ),
              ),
            ),
          ),
        ]),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
             SizedBox(
              height: 112,
              child: ScoreHeader(),
            ),
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              "assets/images/revisioned_failed.png",
              height: 309,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            const Text(
              'Aww',
              style: TextStyle(color: Color(0xFF323232), fontSize: 30),
            ),
            const Text(
              "You scored below the pass mark. \nLet's try one more time\n Together we can",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA2A2A2), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
