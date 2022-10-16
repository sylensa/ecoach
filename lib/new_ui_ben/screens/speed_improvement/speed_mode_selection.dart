import 'package:ecoach/views/learn/learn_speed_enhancement.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../controllers/speed_study_controller.dart';
import '../../providers/welcome_screen_provider.dart';
import '../../widgets/learn_card.dart';

class ChooseSpeedMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Speed Completion',
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
        child: Consumer<WelcomeScreenProvider>(
          builder: (_, welcome, __) => SingleChildScrollView(
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
                Visibility(
                  visible: welcome.currentSpeedStudyProgress!.level != 0,
                  child: LearnCard(
                    title: 'Ongoing',
                    desc: 'Do a quick revision for an upcoming exam',
                    isLevel: true,
                    value: welcome.currentSpeedStudyProgress!.level!.toDouble(),
                    icon: 'assets/images/learn_mode2/hourglass.png',
                    onTap: () async {
                      Get.to(
                          () => SecondComponent(progress: welcome.progress!));
                    },
                  ),
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
                    SpeedStudyProgressController().restartCCLevel();
                    Get.to(() => SecondComponent(progress: welcome.progress!));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
