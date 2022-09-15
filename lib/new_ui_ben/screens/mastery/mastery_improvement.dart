import 'package:flutter/material.dart';

import '../../widgets/learn_card.dart';

class MasteryImprovement extends StatelessWidget {
  const MasteryImprovement({Key? key}) : super(key: key);

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
              LearnCard(
                title: 'Ongoing',
                desc: 'Do a quick revision for an upcoming exam',
                value: 20,
                icon: 'assets/images/hourglass.png',
                onTap: () {},
              ),
              const SizedBox(
                height: 40,
              ),
              LearnCard(
                title: 'New',
                desc: 'Discard old revision and start a new one',
                value: 0,
                icon: 'assets/images/stopwatch.png',
                onTap: () {},
              ),
              const SizedBox(
                height: 40,
              ),
              LearnCard(
                subTitle: 'view',
                secondarySubTitle: "10x",
                title: 'Completed',
                desc: 'View stats on completed revision rounds',
                value: 100,
                icon: 'assets/images/completed.png',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
