import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/compare.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:flutter/material.dart';

class TopicsTabPage extends StatefulWidget {
  const TopicsTabPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TopicsTabPage> createState() => _TopicsTabPageState();
}

class _TopicsTabPageState extends State<TopicsTabPage> {
  late bool showInPercentage;
  List selected = [];

  handleSelection(id) {
    setState(() {
      if (selected.contains(id))
        selected = selected.where((item) => item != id).toList();
      else
        selected = [...selected, id];
    });
  }

  @override
  void initState() {
    showInPercentage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(height: 16),
              PercentageSwitch(
                showInPercentage: showInPercentage,
                onChanged: (val) {
                  setState(() {
                    showInPercentage = val;
                  });
                },
              ),
              SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnalysisCard(
                          activity: 'Using The Internet To Communicate',
                          activityType: 'Topic',
                          showInPercentage: showInPercentage,
                          isSelected: selected.contains(1),
                          metaData: ActivityMetaData(
                            date: '07.09.21',
                            time: '16:04',
                            duration: '05min:20sec',
                          ),
                          onTap: () {
                            handleSelection(1);
                          },
                        ),
                        AnalysisCard(
                          activity: 'Using The Internet To Communicate',
                          activityType: 'Topic',
                          showInPercentage: showInPercentage,
                          isSelected: selected.contains(2),
                          metaData: ActivityMetaData(
                            date: '07.09.21',
                            time: '16:04',
                            duration: '05min:20sec',
                          ),
                          onTap: () {
                            handleSelection(2);
                          },
                        ),
                        AnalysisCard(
                          activity: 'Using The Internet To Communicate',
                          activityType: 'Topic',
                          showInPercentage: showInPercentage,
                          isSelected: selected.contains(3),
                          metaData: ActivityMetaData(
                            date: '07.09.21',
                            time: '16:04',
                            duration: '05min:20sec',
                          ),
                          onTap: () {
                            handleSelection(3);
                          },
                        ),
                        AnalysisCard(
                          activity: 'Using The Internet To Communicate',
                          activityType: 'Topic',
                          showInPercentage: showInPercentage,
                          isSelected: selected.contains(4),
                          metaData: ActivityMetaData(
                            date: '07.09.21',
                            time: '16:04',
                            duration: '05min:20sec',
                          ),
                          onTap: () {
                            handleSelection(4);
                          },
                        ),
                        AnalysisCard(
                          activity: 'Using The Internet To Communicate',
                          activityType: 'Topic',
                          showInPercentage: showInPercentage,
                          isSelected: selected.contains(5),
                          metaData: ActivityMetaData(
                            date: '07.09.21',
                            time: '16:04',
                            duration: '05min:20sec',
                          ),
                          onTap: () {
                            handleSelection(5);
                          },
                        ),
                        AnalysisCard(
                          activity: 'Using The Internet To Communicate',
                          activityType: 'Topic',
                          showInPercentage: showInPercentage,
                          isSelected: selected.contains(6),
                          metaData: ActivityMetaData(
                            date: '07.09.21',
                            time: '16:04',
                            duration: '05min:20sec',
                          ),
                          onTap: () {
                            handleSelection(6);
                          },
                        ),
                        AnalysisCard(
                          activity: 'Using The Internet To Communicate',
                          activityType: 'Topic',
                          showInPercentage: showInPercentage,
                          isSelected: selected == 7,
                          metaData: ActivityMetaData(
                            date: '07.09.21',
                            time: '16:04',
                            duration: '05min:20sec',
                          ),
                          onTap: () {
                            handleSelection(7);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (selected.length > 0)
                Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Color(0x26000000))
                    ],
                  ),
                  child: selected.length > 1
                      ? Expanded(
                          child: AdeoTextButton(
                            label: 'analyse',
                            fontSize: 16,
                            color: kAdeoBlue2,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CompareView();
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AdeoTextButton(
                                      label: 'review',
                                      fontSize: 16,
                                      color: kAdeoBlue2,
                                      onPressed: () {},
                                    ),
                                  ),
                                  Container(
                                    width: 1.0,
                                    color: kPageBackgroundGray,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AdeoTextButton(
                                      label: 'result',
                                      fontSize: 16,
                                      color: kAdeoBlue2,
                                      onPressed: () async {},
                                    ),
                                  ),
                                  Container(
                                    width: 1.0,
                                    color: kPageBackgroundGray,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: AdeoTextButton(
                                label: 'retake',
                                fontSize: 16,
                                color: kAdeoBlue2,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
