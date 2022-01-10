import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/compare.dart';
import 'package:ecoach/widgets/buttons/adeo_gray_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/buttons/arrow_button.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:flutter/material.dart';

class MarathonCompleted extends StatefulWidget {
  const MarathonCompleted({
    Key? key,
  }) : super(key: key);

  @override
  State<MarathonCompleted> createState() => _MarathonCompletedState();
}

class _MarathonCompletedState extends State<MarathonCompleted> {
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
    return Scaffold(
      backgroundColor: kAdeoRoyalBlue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArrowButton(
                  arrow: 'assets/icons/arrows/chevron_left.png',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Text(
                    'Completed Marathons',
                    style: TextStyle(
                      color: kAdeoBlue,
                      fontSize: 28,
                      fontFamily: 'Hamelin',
                    ),
                  ),
                ),
                Container(),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
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
                              variant: CardVariant.LIGHT,
                              activity: 'Using The Internet To Communicate',
                              activityType: 'Exam',
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
                              variant: CardVariant.LIGHT,
                              activity: 'Using The Internet To Communicate',
                              activityType: 'Exam',
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
                              variant: CardVariant.LIGHT,
                              activity: 'Using The Internet To Communicate',
                              activityType: 'Exam',
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
                              variant: CardVariant.LIGHT,
                              activity: 'Using The Internet To Communicate',
                              activityType: 'Exam',
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
                              variant: CardVariant.LIGHT,
                              activity: 'Using The Internet To Communicate',
                              activityType: 'Exam',
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
                      child: AdeoTextButton(
                        label: 'Next',
                        fontSize: 20,
                        background: kAdeoBlue,
                        color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
