import 'dart:convert';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/grade.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/report.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/course_detail.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:ecoach/widgets/adeo_tab_control.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/cards/course_detail_card.dart';
import 'package:ecoach/widgets/cards/stats_slider_card.dart';
import 'package:ecoach/widgets/tab_bar_views/reporting_all_tab_page.dart';
import 'package:ecoach/widgets/tab_bar_views/reporting_exams_tab_page.dart';
import 'package:ecoach/widgets/tab_bar_views/reporting_others_tab_page.dart';
import 'package:ecoach/widgets/tab_bar_views/reporting_topics_tab_page.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {
  ProgressWidget({Key? key,required this.course,required this.user,required this.subscription, required this.controller,required this.stats}) : super(key: key);
  Course course;
  User user;
  Plan subscription;
  Future? stats;
  final MainController controller;
  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  List<SubscriptionItem> subscriptions = [];
  SubscriptionItem? subscription;
  Future? course;
  bool progressCode = true;
  bool onChangeStatus = false;

  String rightWidgetState = 'average';
  @override
  void initState() {
    print("hey");
    unSelectAnsweredQuestions.clear();
    selectAnsweredQuestions.clear();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCourseById(int id) {
    return CourseDB().getCourseById(id);
  }



  @override
  Widget build(BuildContext context) {

    return  Column(
      children: [
        SizedBox(height: 26),
        FutureBuilder(
            future: widget.stats,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  );
                default:
                  if (snapshot.hasError)
                    return Expanded(
                      child: Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: inlinePromptStyle.copyWith(
                              color: Colors.red),
                        ),
                      ),
                    );
                  else if (snapshot.data == null)
                    return Expanded(
                      child: Center(
                        child: Text(
                          'Course not found',
                          style: inlinePromptStyle,
                        ),
                      ),
                    );
                  else if (snapshot.data != null) {

                    return Expanded(
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: widget.stats,
                            builder: (context, snapshot) {
                              switch (
                              snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  if(snapshot.data == null){
                                    return StatsNonDataWidget(
                                      isLoading: true,
                                    );
                                  }else{
                                    Report stats = snapshot.data as Report;
                                    return getStatsBlock(stats, widget.course.packageCode, widget.course);
                                  }

                                case ConnectionState.done:
                                  if (snapshot.data != null) {
                                    Report stats = snapshot
                                        .data! as Report;
                                    // inspect(snapshot);
                                    if (stats.courseStats!.length == 0)
                                      return StatsNonDataWidget(
                                        message:
                                        'No statistics for this course yet.',
                                      );
                                    return getStatsBlock(stats, widget.course.packageCode, widget.course);
                                  } else if (snapshot
                                      .hasError) {
                                    return StatsNonDataWidget(
                                      message:
                                      'Could not fetch course stats',
                                      isError: true,
                                    );
                                  }
                                  return StatsNonDataWidget(
                                    message:
                                    'An error occured. \nCould not fetch course stats.',
                                  );
                              }
                            },
                          ),
                          SizedBox(height: 26),
                          Expanded(
                            child: AdeoTabControl(
                              variant: 'square',
                              tabs: [
                                'all',
                                'exams',
                                'topics',
                                'others'
                              ],
                              tabPages: [
                                AllTabPage(
                                  user: widget.user,
                                  course: widget.course,
                                  rightWidgetState: rightWidgetState,
                                  onChangeStatus: onChangeStatus,
                                ),
                                ExamsTabPage(
                                  user: widget.user,
                                  course: widget.course,
                                  rightWidgetState: rightWidgetState,
                                  onChangeStatus: onChangeStatus,
                                ),
                                TopicsTabPage(
                                  user: widget.user,
                                  course: widget.course,
                                  rightWidgetState: rightWidgetState,
                                  onChangeStatus: onChangeStatus,
                                ),
                                OthersTabPage(
                                  user: widget.user,
                                  course: widget.course,
                                  rightWidgetState: rightWidgetState,
                                  onChangeStatus: onChangeStatus,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else
                    return Expanded(
                      child: Center(
                        child: Text(
                          "Something isn't right",
                          style: inlinePromptStyle,
                        ),
                      ),
                    );
              }
            })
      ],
    );
  }
  getStatsBlock(Report stats, packageCode,Course course) {
    print("heyyy ${rightWidgetState}");
    CourseStat courseStat1 = stats.courseStats![0];
    dynamic courseStat2 =
    stats.courseStats!.length > 1 ? stats.courseStats![1] : null;

    String getPositionPostfix(int position) {
      List<String> stringifiedPosition = position.toString().split('');
      int len = stringifiedPosition.length;
      dynamic penultimateChar = len >= 2 ? stringifiedPosition[len - 2] : null;
      String lastChar = stringifiedPosition[len - 1];

      if (lastChar == '1') {
        if (len >= 2 && penultimateChar == '1')
          return 'th';
        else
          return 'st';
      } else if (lastChar == '2') {
        if (len >= 2 && penultimateChar == '1')
          return 'th';
        else
          return 'nd';
      } else if (lastChar == '3') {
        if (len >= 2 && penultimateChar == '1')
          return 'th';
        else
          return 'rd';
      }

      return 'th';
    }

    return  StatsSliderCard(
      items: [
        Stat(
          value: courseStat1.avgScore!,
          statLabel: 'average score',
          hasDeprecated: courseStat2 != null
              ? double.parse(courseStat1.avgScore!) <
              double.parse(courseStat2.avgScore!)
              : false,
          hasAppreciated: courseStat2 != null
              ? double.parse(courseStat1.avgScore!) >
              double.parse(courseStat2.avgScore!)
              : true,
        ),
        Stat(
          value: courseStat1.totalCorrectQuestions.toString(),
          statLabel: 'points',
        ),
        Stat(
          value: '${courseStat1.exposure}%',
          statLabel: 'exposure',
        ),
        Stat(
          value: '${courseStat1.speed}q/m',
          statLabel: 'speed',
        ),
        Stat(
          value: AdeoSignalStrengthIndicator(
            strength: double.parse(courseStat1.avgScore!),
          ),
          statLabel: 'strength',
          hasStandaloneWidgetAsValue: true,
        ),
        Stat(
          value: GradingSystem(
            score: double.parse(courseStat1.avgScore!),
            level: packageCode,
          ).grade,
          statLabel: 'grade',
        ),
        Stat(
          value: '${courseStat1.rank}${getPositionPostfix(courseStat1.rank!)}',
          statLabel: 'Rank',
        ),
      ],

      onChanged: (page) {
        print("page:$page");
        setState(() {
          switch (page) {
            case 0:
              rightWidgetState = 'average';
              setState((){
                onChangeStatus = true;
              });
              break;
            case 1:
              rightWidgetState = 'points';
              setState((){
                onChangeStatus = true;
              });
              break;
            case 2:
              rightWidgetState = 'exposure';
              break;
            case 3:
              rightWidgetState = 'speed';
              break;
            case 4:
              rightWidgetState = 'strength';
              break;
            case 5:
              rightWidgetState = 'grade';
              break;
            case 6:
              rightWidgetState = 'rank';
              break;
            default:
              rightWidgetState = '';
          }
        });
      },
      course: course,
    );
  }
}
class StatsNonDataWidget extends StatelessWidget {
  const StatsNonDataWidget({
    this.message,
    this.isError: false,
    this.isLoading: false,
    Key? key,
  }) : super(key: key);

  final String? message;
  final bool isError;
  final isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        // color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
            color: Colors.blue,
          )
              : Text(
            message!,
            textAlign: TextAlign.center,
            style: inlinePromptStyle.copyWith(
              color: isError ? Colors.red : kDefaultBlack,
            ),
          ),
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
    required this.correctlyAnswered,
    required this.totalQuestions,
    this.onTap,
    this.variant: CardVariant.DARK,
    this.selectedBackground: kAdeoBlue2,
    Key? key,
  }) : super(key: key);

  final bool showInPercentage;
  final bool isSelected;
  final ActivityMetaData metaData;
  final String activity;
  final String activityType;
  final int correctlyAnswered;
  final int totalQuestions;
  final onTap;
  final CardVariant variant;
  final Color selectedBackground;

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
    return Column(
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
          onTap: onTap,
          title: activity,
          subTitle: activityType,
          hasSmallHeading: true,
          isActive: isSelected,
          activeBackground: selectedBackground,
          rightWidget: showInPercentage
              ? PercentageSnippet(
            correctlyAnswered: correctlyAnswered,
            totalQuestions: totalQuestions,
            isSelected: isSelected,
          )
              : FractionSnippet(
            correctlyAnswered: correctlyAnswered,
            totalQuestions: totalQuestions,
            isSelected: isSelected,
          ),
        ),
      ],
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