import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/accessment/views/screens/choose_level.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FreeAssessmentWidget extends StatefulWidget {
  final User user;
  FreeAssessmentWidget(this.user);

  @override
  State<FreeAssessmentWidget> createState() => _FreeAccessmentWidgetState();
}

class _FreeAccessmentWidgetState extends State<FreeAssessmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: double.maxFinite,
          ),
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 44,
          ),
          decoration: BoxDecoration(
            color: kAdeoBlue,
            borderRadius: BorderRadius.circular(
              8,
            ),
            gradient: LinearGradient(
              // 104.04deg, #54B5FF 0%, #1182D8 100%,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF54B5FF),
                Color(0xFF1182D8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Free Assessment',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Take a free test today, and get to know your strengths and weakness',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFC2E5FF),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdeoFilledButton(
                    label: 'Try it Now',
                    size: Sizes.small,
                    background: Color(0xFF0AE0E4),
                    borderRadius: 14,
                    onPressed: () {
                      Get.to(() => ChooseAccessmentLevel(widget.user));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          right: 28,
          child: Image.asset(
            'assets/images/exam.png',
            width: 72,
            height: 72,
          ),
        ),
      ],
    );
  }
}
