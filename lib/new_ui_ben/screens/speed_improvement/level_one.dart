
import 'package:flutter/material.dart';

import '../level_start_screen.dart';

class LevelOne extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LevelStartScreen(
        bgImage: "assets/images/level1bg.png",
        label: "slow but sure ",
        level: "level 1",
        levelImage: "assets/images/tortoise.png",
        timer: "120",
      ),
    );
  }
}
