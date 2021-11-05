import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_gray_outlined_button.dart';
import 'package:flutter/material.dart';

class LearnSpeedEnhancementCompletion extends StatelessWidget {
  const LearnSpeedEnhancementCompletion({
    required this.level,
  });

  final Map<String, dynamic> level;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AdeoGrayOutlinedButton(
                      label: 'return',
                      onPressed: () {},
                      size: Sizes.small,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      level['level'] > 1 ? 'Congratulations' : 'Aww',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kAdeoCoral,
                        fontWeight: FontWeight.w600,
                        fontSize: 28.0,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      'You moved up to level ${level['level'].toString()}, the ${level['name']} zone',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFACACAC),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      '${level['duration'].toString()} sec : ${level['questions'].toString()} question(s)',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: kAdeoBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 48.0),
                    Container(
                      width: 240.0,
                      child: Image.asset(
                        'assets/images/learn_module/${level['name']}.png',
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
              AdeoOutlinedButton(
                label: 'OK',
                onPressed: () {},
                color: kAdeoBlue,
                borderRadius: 0,
              ),
              SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}
