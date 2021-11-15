import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn_speed_enhancement_completion.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:flutter/material.dart';

class LearnSpeedEnhancementQuestionsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Center(
        child: AdeoOutlinedButton(
          color: kAdeoCoral,
          label: 'End Test',
          borderRadius: 0,
          onPressed: () {},
        ),
      ),
    ));
  }
}
