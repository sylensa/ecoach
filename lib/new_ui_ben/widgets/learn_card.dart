
import 'package:ecoach/new_ui_ben/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class LearnCard extends StatelessWidget {
  final String title;
  final String desc;
  final double value;
  final String icon;
  final bool isLevel;
  final String? subTitle;
  final String? secondarySubTitle;
  final Function onTap;
  const LearnCard(
      {Key? key,
      required this.title,
      required this.desc,
      required this.value,
      required this.icon,
      required this.onTap,
       this.subTitle,
       this.secondarySubTitle,
      this.isLevel = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       onTap();
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
        decoration: BoxDecoration(
          color: const Color(0xFF005CA5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      )
                    ],
                  ),
                ),
                Image.asset(icon)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ProgressBar(
              value: value,
              isLevel: isLevel,
              subTitle: subTitle,
              secondarySubTitle: secondarySubTitle,
            ),
          ],
        ),
      ),
    );
  }
}
