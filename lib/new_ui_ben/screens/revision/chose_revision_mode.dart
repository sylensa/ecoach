import "package:flutter/material.dart";
import 'package:get/get.dart';

import '../../widgets/learn_card.dart';
import 'ongoing_revision.dart';

class ChoseRevisionMode extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Revision',
          style: TextStyle(
            fontFamily: 'Cocon',
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
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
                "A quick way to prep for your exam",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(255, 255, 255, 0.5)),
              ),
              const SizedBox(
                height: 67,
              ),
              LearnCard(
                title: 'Ongoing',
                desc: 'Do a quick revision for an upcoming exam',
                value: 20,
                icon: 'assets/images/learn_mode2/hourglass.png',
                onTap: () {
                  Get.to(() => const OngoingRevision());
                },
              ),
              const SizedBox(
                height: 40,
              ),
              LearnCard(
                title: 'New',
                desc: 'Discard old revision and start a new one',
                value: 0,
                icon: 'assets/images/learn_mode2/stopwatch.png',
                onTap: () {
                  
                },
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
                icon: 'assets/images/learn_mode2/completed.png',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
