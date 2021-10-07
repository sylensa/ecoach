import 'package:ecoach/models/ui/pill.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/analysis_app_bar.dart';
import 'package:ecoach/widgets/tab_bar_views/analysis_all_tab_bar_view.dart';
import 'package:ecoach/widgets/tab_bar_views/exams_tab_bar_view.dart';
import 'package:flutter/material.dart';

class AnalysisView extends StatefulWidget {
  static const String routeName = '/analysis';
  const AnalysisView({Key? key}) : super(key: key);

  @override
  _AnalysisViewState createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> with TickerProviderStateMixin {
  int currentPillIndex = 0;
  List<Pill> coursePillList = [];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    coursePillList = [
      Pill(label: 'jhs1 math'),
      Pill(label: 'jhs1 ict'),
      Pill(label: 'jhs1 science'),
      Pill(label: 'jhs1 english'),
      Pill(label: 'jhs1 bdt'),
      Pill(label: 'jhs1 social studies'),
    ];

    tabController = TabController(initialIndex: 1, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: kAnalysisScreenBackground,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AnalysisAppBar(
              coursePillList: coursePillList,
              currentPillIndex: currentPillIndex,
              tabController: tabController,
              onPillTapped: (index) {
                setState(() {
                  currentPillIndex = index;
                });
              },
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  AllTabBarView(),
                  ExamsTabBarView(),
                  Center(child: Text('Topics')),
                  Center(child: Text('Analysis')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
