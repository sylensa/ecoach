import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/pill.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:ecoach/widgets/analysis_app_bar.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/cards/stats_slider_card.dart';
import 'package:ecoach/widgets/dropdowns/adeo_dropdown_borderless.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:ecoach/widgets/tab_bar_views/analysis_all_tab_bar_view.dart';
import 'package:ecoach/widgets/tab_bar_views/exams_tab_bar_view.dart';
import 'package:ecoach/widgets/tab_bar_views/reporting_all_tab_page.dart';
import 'package:ecoach/widgets/tab_bar_views/reporting_exams_tab_page.dart';
import 'package:ecoach/widgets/tab_bar_views/reporting_topics_tab_page.dart';
import 'package:flutter/material.dart';

class AnalysisView extends StatefulWidget {
  static const String routeName = '/analysis';
  const AnalysisView({Key? key}) : super(key: key);

  @override
  _AnalysisViewState createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  List<SubscriptionItem> subscriptions = [];
  String selectedSubscription = '';

  @override
  void initState() {
    super.initState();
    SubscriptionItemDB().allSubscriptionItems().then((subscriptionItems) {
      setState(() {
        selectedSubscription = subscriptionItems[0].name!;
        subscriptionItems.forEach((item) {
          subscriptions.add(item);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              pageHeading: 'Track your progress',
              size: Sizes.small,
            ),
            AdeoDropdownBorderless(
              value: selectedSubscription,
              items: subscriptions.map((item) => item.name).toList(),
              onChanged: (item) {
                setState(() {
                  selectedSubscription = item;
                });
              },
            ),
            SizedBox(height: 12),
            StatsSliderCard(
              items: [
                Stat(
                  value: '67.8%',
                  statLabel: 'average score',
                  hasDeprecated: true,
                ),
                Stat(value: '2852', statLabel: 'points'),
                Stat(value: '50%', statLabel: 'exposure'),
                Stat(value: '1.5 q/m', statLabel: 'speed'),
              ],
            ),
            // Container(height: 1, color: Colors.white),
            SizedBox(height: 4),
            AdeoTabControl(
              variant: 'square',
              tabs: ['all', 'exams', 'topics', 'analyse'],
              tabPages: [
                AllTabPage(),
                ExamsTabPage(),
                TopicsTabPage(),
                Center(
                  child: Text(
                    'Feature coming soon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0x80000000),
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AnalysisCard extends StatelessWidget {
  AnalysisCard({
    required this.showInPercentage,
    required this.isSelected,
    required this.metaData,
    required this.activity,
    required this.activityType,
    this.onTap,
    this.variant = CardVariant.DARK,
    Key? key,
  }) : super(key: key);

  final bool showInPercentage;
  final bool isSelected;
  final ActivityMetaData metaData;
  final String activity;
  final String activityType;
  final onTap;
  final CardVariant variant;

  TextStyle metaDataStyle({CardVariant variant = CardVariant.DARK}) {
    return TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
      color:
          variant == CardVariant.DARK ? Color(0x99000000) : Color(0x99FFFFFF),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metaData.date,
                  style: metaDataStyle(variant: variant),
                ),
                Text(
                  metaData.time,
                  style: metaDataStyle(variant: variant),
                ),
                Text(
                  metaData.duration,
                  style: metaDataStyle(variant: variant),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          MultiPurposeCourseCard(
            title: activity,
            subTitle: activityType,
            hasSmallHeading: true,
            isActive: isSelected,
            rightWidget: showInPercentage
                ? PercentageSnippet(
                    correctlyAnswered: 6,
                    totalQuestions: 10,
                    isSelected: isSelected,
                  )
                : FractionSnippet(
                    correctlyAnswered: 6,
                    totalQuestions: 10,
                    isSelected: isSelected,
                  ),
          ),
        ],
      ),
    );
  }
}

class ActivityMetaData {
  final String date;
  final String time;
  final String duration;

  ActivityMetaData({
    required this.date,
    required this.time,
    required this.duration,
  });
}

// class _AnalysisViewState extends State<AnalysisView>
//     with TickerProviderStateMixin {
//   int currentPillIndex = 0;
//   List<Pill> coursePillList = [];
//   List<SubscriptionItem> items = [];

//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();

//     SubscriptionItemDB().allSubscriptionItems().then((subscriptionItems) {
//       setState(() {
//         subscriptionItems.forEach((item) {
//           items.add(item);
//           coursePillList.add(Pill(label: item.name!));
//         });
//       });
//     });

//     tabController = TabController(initialIndex: 0, length: 0, vsync: this);
//   }

//   @override
//   void setState(VoidCallback fn) {
//     if (mounted) super.setState(fn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         color: kAnalysisScreenBackground,
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             AnalysisAppBar(
//               coursePillList: coursePillList,
//               currentPillIndex: currentPillIndex,
//               tabController: tabController,
//               onPillTapped: (index) {
//                 setState(() {
//                   print("index=$index");
//                   currentPillIndex = index;
//                 });
//               },
//             ),
//             ValueListenableBuilder<int>(
//                 valueListenable: ValueNotifier(currentPillIndex),
//                 builder: (context, dynamic value, Widget? child) {
//                   print(value);
//                   return items.length > 0
//                       ? AllTabBarView(
//                           items[currentPillIndex],
//                           key: UniqueKey(),
//                         )
//                       : Center(
//                           child: Text("No data yet...."),
//                         );
//                   return Expanded(
//                     child: TabBarView(
//                       controller: tabController,
//                       children: [
//                         items.length > 0
//                             ? AllTabBarView(
//                                 items[currentPillIndex],
//                                 key: UniqueKey(),
//                               )
//                             : Center(
//                                 child: Text("No data yet...."),
//                               ),
//                         // ExamsTabBarView(),
//                         // TopicsTabBarView(),
//                         // Center(child: Text('Analysis')),
//                       ],
//                     ),
//                   );
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }
