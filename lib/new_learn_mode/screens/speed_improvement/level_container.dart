import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/speed_enhancement_progress_model.dart';
import 'package:ecoach/new_learn_mode/providers/learn_mode_provider.dart';
import 'package:ecoach/new_learn_mode/screens/level_start_screen.dart';
import 'package:ecoach/new_learn_mode/screens/speed_improvement/utils/speed_enhancement_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeedImprovementLevelContainer extends StatefulWidget {
  // final SpeedEnhancementLevel enhancementLevel;
  final int level;
  final Function proceed;
  const SpeedImprovementLevelContainer(
      {required this.proceed, required this.level, Key? key})
      : super(key: key);

  @override
  State<SpeedImprovementLevelContainer> createState() =>
      _SpeedImprovementLevelContainerState();
}

class _SpeedImprovementLevelContainerState
    extends State<SpeedImprovementLevelContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LearnModeProvider>(
        builder: (_, welcome, __) {
          return FutureBuilder<SpeedStudyProgress?>(
              future: StudyDB().getCurrentSpeedProgressLevelByCourse(
                  welcome.currentCourse!.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.data == null) {
                  return Center(child: Text("No Value Found"));
                }

                SpeedEnhancementLevel level =
                    speedEnhancementLevels[snapshot.data!.level! - 1];

                return LevelStartScreen(
                  bgImage: level.backgroundImage,
                  levelImage: level.levelImage,
                  label: level.label,
                  level: level.level,
                  timer: level.timer,
                  onSwipe: () {
                    widget.proceed();
                  },
                );
              });
        },
      ),
    );
  }
}
