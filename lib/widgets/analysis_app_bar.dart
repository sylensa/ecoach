import 'package:ecoach/models/ui/pill.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

import 'list/course_pill_list.dart';

class AnalysisAppBar extends StatelessWidget {
  const AnalysisAppBar({
    required this.coursePillList,
    required this.currentPillIndex,
    required this.onPillTapped,
    required this.tabController,
  });

  final List<Pill> coursePillList;
  final int currentPillIndex;
  final Function onPillTapped;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAnalysisScreenActiveColor,
      height: 140.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 16.0,
          ),
          CoursePillList(
            pills: coursePillList,
            selectedPill: currentPillIndex,
            onPillTapped: (index) {
              onPillTapped(index);
            },
          ),
          TabBar(
            controller: tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            labelStyle: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Poppins',
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Color(0x85FFFFFF),
            tabs: const <Widget>[
              // Tab(text: 'all'),
              // Tab(text: 'exams'),
              // Tab(text: 'topics'),
              // Tab(text: 'analyses'),
            ],
          ),
        ],
      ),
    );
  }
}
