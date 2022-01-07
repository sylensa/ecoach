import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/cards/stats_slider_card.dart';
import 'package:ecoach/widgets/page_header.dart';
import 'package:flutter/material.dart';

class CompareView extends StatefulWidget {
  static const String routeName = '/analysis';
  const CompareView({Key? key}) : super(key: key);

  @override
  _CompareViewState createState() => _CompareViewState();
}

class _CompareViewState extends State<CompareView> {
  late bool showInPercentage;
  int selected = 0;
  String rightWidgetState = '';
  String grade = 'B2';

  handleSelection(id) {
    setState(() {
      if (selected == id)
        selected = 0;
      else
        selected = id;
    });
  }

  @override
  void initState() {
    super.initState();
    showInPercentage = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              pageHeading: 'Comparing Exams',
              size: Sizes.small,
            ),
            StatsSliderCard(
              items: [
                Stat(value: '67.8%', statLabel: 'average score'),
                Stat(value: '+5.5%', statLabel: 'overall outlook'),
                Stat(value: '240/300', statLabel: 'total points'),
                Stat(
                  hasStandaloneWidgetAsValue: true,
                  statLabel: 'strength',
                  value: AdeoSignalStrengthIndicator(strength: 90),
                ),
                Stat(value: grade, statLabel: 'grade'),
              ],
              onChanged: (page) {
                setState(() {
                  switch (page) {
                    case 2:
                      rightWidgetState = 'total points';
                      break;
                    case 3:
                      rightWidgetState = 'strength';
                      break;
                    case 4:
                      rightWidgetState = 'grade';
                      break;
                    default:
                      rightWidgetState = '';
                  }
                });
              },
            ),
            SizedBox(height: 20),
            SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          MultiPurposeCourseCard(
                            hasSmallHeading: true,
                            title: 'Using The Internet To Communicate',
                            subTitle: 'Exam',
                            isActive: selected == 1,
                            rightWidget: (() {
                              switch (rightWidgetState.toUpperCase()) {
                                case 'TOTAL POINTS':
                                  return FractionSnippet(
                                    correctlyAnswered: 66,
                                    totalQuestions: 100,
                                    isSelected: selected == 1,
                                  );
                                case 'STRENGTH':
                                  return AdeoSignalStrengthIndicator(
                                    strength: 80,
                                    size: Sizes.small,
                                  );
                                case 'GRADE':
                                  return Text(
                                    grade,
                                    style: TextStyle(
                                      color: Color(0xFF2A9CEA),
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                default:
                                  return PercentageSnippet(
                                    correctlyAnswered: 66,
                                    totalQuestions: 100,
                                    isSelected: selected == 1,
                                  );
                              }
                            })(),
                            onTap: () {
                              handleSelection(1);
                            },
                          ),
                          MultiPurposeCourseCard(
                            hasSmallHeading: true,
                            title: 'Using The Internet To Communicate',
                            subTitle: 'Exam',
                            isActive: selected == 2,
                            rightWidget: (() {
                              switch (rightWidgetState.toUpperCase()) {
                                case 'TOTAL POINTS':
                                  return FractionSnippet(
                                    correctlyAnswered: 66,
                                    totalQuestions: 100,
                                    isSelected: selected == 1,
                                  );
                                case 'STRENGTH':
                                  return AdeoSignalStrengthIndicator(
                                    strength: 55,
                                    size: Sizes.small,
                                  );
                                case 'GRADE':
                                  return Text(
                                    grade,
                                    style: TextStyle(
                                      color: Color(0xFF2A9CEA),
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                default:
                                  return PercentageSnippet(
                                    correctlyAnswered: 66,
                                    totalQuestions: 100,
                                    isSelected: selected == 1,
                                  );
                              }
                            })(),
                            onTap: () {
                              handleSelection(2);
                            },
                          ),
                          MultiPurposeCourseCard(
                            hasSmallHeading: true,
                            title: 'Using The Internet To Communicate',
                            subTitle: 'Exam',
                            isActive: selected == 3,
                            rightWidget: (() {
                              switch (rightWidgetState.toUpperCase()) {
                                case 'TOTAL POINTS':
                                  return FractionSnippet(
                                    correctlyAnswered: 66,
                                    totalQuestions: 100,
                                    isSelected: selected == 1,
                                  );
                                case 'STRENGTH':
                                  return AdeoSignalStrengthIndicator(
                                    strength: 80,
                                    size: Sizes.small,
                                  );
                                case 'GRADE':
                                  return Text(
                                    grade,
                                    style: TextStyle(
                                      color: Color(0xFF2A9CEA),
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                default:
                                  return PercentageSnippet(
                                    correctlyAnswered: 66,
                                    totalQuestions: 100,
                                    isSelected: selected == 1,
                                  );
                              }
                            })(),
                            onTap: () {
                              handleSelection(3);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    if (rightWidgetState.toUpperCase() != 'GRADE')
                      Column(
                        children: [
                          Container(height: 3, color: Colors.white),
                          SizedBox(height: 40),
                          Text(
                            'Topics',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: kDefaultBlack,
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                MultiPurposeCourseCard(
                                  hasSmallHeading: true,
                                  title: 'Using The Internet To Communicate',
                                  subTitle: 'Topic',
                                  isActive: selected == 4,
                                  rightWidget: (() {
                                    switch (rightWidgetState.toUpperCase()) {
                                      case 'TOTAL POINTS':
                                        return FractionSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      case 'STRENGTH':
                                        return AdeoSignalStrengthIndicator(
                                          strength: 80,
                                          size: Sizes.small,
                                        );
                                      case 'GRADE':
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      default:
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                    }
                                  })(),
                                  onTap: () {
                                    handleSelection(4);
                                  },
                                ),
                                MultiPurposeCourseCard(
                                  hasSmallHeading: true,
                                  title: 'Using The Internet To Communicate',
                                  subTitle: 'Topic',
                                  isActive: selected == 5,
                                  rightWidget: (() {
                                    switch (rightWidgetState.toUpperCase()) {
                                      case 'TOTAL POINTS':
                                        return FractionSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      case 'STRENGTH':
                                        return AdeoSignalStrengthIndicator(
                                          strength: 80,
                                          size: Sizes.small,
                                        );
                                      case 'GRADE':
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      default:
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                    }
                                  })(),
                                  onTap: () {
                                    handleSelection(5);
                                  },
                                ),
                                MultiPurposeCourseCard(
                                  hasSmallHeading: true,
                                  title: 'Using The Internet To Communicate',
                                  subTitle: 'Topic',
                                  isActive: selected == 6,
                                  rightWidget: (() {
                                    switch (rightWidgetState.toUpperCase()) {
                                      case 'TOTAL POINTS':
                                        return FractionSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      case 'STRENGTH':
                                        return AdeoSignalStrengthIndicator(
                                          strength: 80,
                                          size: Sizes.small,
                                        );
                                      case 'GRADE':
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      default:
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                    }
                                  })(),
                                  onTap: () {
                                    handleSelection(6);
                                  },
                                ),
                                MultiPurposeCourseCard(
                                  hasSmallHeading: true,
                                  title: 'Using The Internet To Communicate',
                                  subTitle: 'Topic',
                                  isActive: selected == 7,
                                  rightWidget: (() {
                                    switch (rightWidgetState.toUpperCase()) {
                                      case 'TOTAL POINTS':
                                        return FractionSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      case 'STRENGTH':
                                        return AdeoSignalStrengthIndicator(
                                          strength: 80,
                                          size: Sizes.small,
                                        );
                                      case 'GRADE':
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                      default:
                                        return PercentageSnippet(
                                          correctlyAnswered: 66,
                                          totalQuestions: 100,
                                          isSelected: selected == 1,
                                        );
                                    }
                                  })(),
                                  onTap: () {
                                    handleSelection(7);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
            Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Color(0x26000000))],
              ),
              child: selected == 0
                  ? Expanded(
                      child: AdeoTextButton(
                        label: 'Return',
                        fontSize: 16,
                        color: kAdeoBlue2,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  : Expanded(
                      child: AdeoTextButton(
                        label: 'Revise',
                        fontSize: 16,
                        color: kAdeoBlue2,
                        onPressed: () {},
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
