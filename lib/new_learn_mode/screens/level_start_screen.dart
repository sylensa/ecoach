import 'package:flutter/material.dart';

import '../widgets/level_container.dart';

class LevelStartScreen extends StatelessWidget {
  final String bgImage;
  final String levelImage;
  final String level;
  final String timer;
  final String label;
  final Function onSwipe;

  const LevelStartScreen({
    Key? key,
    required this.onSwipe,
    required this.bgImage,
    required this.levelImage,
    required this.label,
    required this.level,
    required this.timer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(bgImage), fit: BoxFit.cover)),
      child: Column(
        children: [
          const Expanded(
              child: SizedBox(
            height: 10,
          )),
          LevelContainer(
            image: levelImage,
            label: label,
            level: level,
            time: "$timer seconds",
            onSwipe: () {
              onSwipe();
            },
          )
        ],
      ),
    );
  }
}
