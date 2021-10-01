import 'package:ecoach/models/ui/pill.dart';
import 'package:flutter/material.dart';

import '../tappable_pill.dart';

class CoursePillList extends StatelessWidget {
  CoursePillList({
    this.selectedPill = 0,
    required this.onPillTapped,
    required this.pills,
  });

  final int selectedPill;
  final Function onPillTapped;
  final List<Pill> pills;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: pills.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16.0 : 20.0,
              right: index == pills.length - 1 ? 16.0 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                onPillTapped(index);
              },
              child: TappablePill(
                pill: pills[index],
                isSelected: selectedPill == index,
              ),
            ),
          );
        },
      ),
    );
  }
}
