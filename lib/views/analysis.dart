import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/pill.dart';
import 'package:ecoach/providers/subscription_item_db.dart';
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
  List<SubscriptionItem> items = [];

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    SubscriptionItemDB().allSubscriptionItems().then((subscriptionItems) {
      setState(() {
        subscriptionItems.forEach((item) {
          items.add(item);
          coursePillList.add(Pill(label: item.name!));
        });
      });
    });

    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
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
                  print("index=$index");
                  currentPillIndex = index;
                });
              },
            ),
            ValueListenableBuilder<int>(
                valueListenable: ValueNotifier(currentPillIndex),
                builder: (context, dynamic value, Widget? child) {
                  print(value);
                  return Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        items.length > 0
                            ? AllTabBarView(
                                items[currentPillIndex],
                                key: UniqueKey(),
                              )
                            : Center(
                                child: Text("No data yet...."),
                              ),
                        ExamsTabBarView(),
                        Center(child: Text('Topics')),
                        Center(child: Text('Analysis')),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
