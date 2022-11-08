import 'package:flutter/material.dart';

import '../level_start_screen.dart';

class LevelTwo extends StatelessWidget {
  // const LevelTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: LevelStartScreen(
        bgImage: "assets/images/learn_mode2/level2bg.png",
        label: "natural pace",
        level: "level 2",
        levelImage: "assets/images/learn_mode2/level2img.png",
        timer: "90",
        onSwipe: (){},
      ),
    );
  }
}
