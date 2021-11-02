import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/layouts/learn_peripheral_layout.dart';
import 'package:flutter/material.dart';

class LearnNextTopic extends StatelessWidget {
  const LearnNextTopic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LearnPeripheralWidget(
        heroText: 'Next Topic',
        subText: 'Pressure ',
        heroImageURL: 'assets/images/learn_module/next_topic.png',
        topActionLabel: 'exit',
        topActionOnPressed: () {},
        topActionColor: kAdeoCoral,
        mainActionLabel: 'let\'s go',
        mainActionColor: kAdeoCoral,
        mainActionOnPressed: () {},
      ),
    );
  }
}
