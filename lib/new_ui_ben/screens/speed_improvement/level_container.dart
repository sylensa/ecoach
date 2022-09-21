import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/new_ui_ben/providers/speed_enhancement_provider.dart';
import 'package:ecoach/new_ui_ben/screens/level_start_screen.dart';
import 'package:ecoach/new_ui_ben/screens/speed_improvement/utils/speed_enhancement_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeedImprovementLevelContainer extends StatefulWidget {
  // final SpeedEnhancementLevel enhancementLevel;
  final int level;
  final Function proceed; 
  const SpeedImprovementLevelContainer({required this.proceed, required this.level, Key? key}) : super(key: key);

  @override
  State<SpeedImprovementLevelContainer> createState() =>
      _SpeedImprovementLevelContainerState();
}

class _SpeedImprovementLevelContainerState
    extends State<SpeedImprovementLevelContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SpeedEnhancementProvider>(
        builder: (_, speed, __) {
          SpeedEnhancementLevel level = speedEnhancementLevels[speed.level - 1];
          return LevelStartScreen(
            bgImage: level.backgroundImage,
            levelImage: level.levelImage,
            label: level.label,
            level: level.level,
            timer: level.timer,
            onSwipe: (){
              widget.proceed();
            },
          );
        },
      ),
    );
  }
}
