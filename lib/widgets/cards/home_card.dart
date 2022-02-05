import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({
    required this.timeAgo,
    required this.activityTypeIconURL,
    required this.vendoLogoURL,
    required this.footerCenterText,
    required this.footerRightText,
    required this.centralWidget,
    required this.centerRightWidget,
    this.colors,
  });

  final String timeAgo;
  final String activityTypeIconURL;
  final String vendoLogoURL;
  final String footerCenterText;
  final String footerRightText;
  final Widget centralWidget;
  final Widget centerRightWidget;
  final List<Color>? colors;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  bool expanded = false;
  BoxDecoration gradient = BoxDecoration();

  @override
  void initState() {
    super.initState();
    gradient = BoxDecoration(
      gradient: LinearGradient(
        colors: widget.colors ?? [Color(0xFF393FC8), Color(0xFF282D9A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Column(
        children: [
          Container(
            decoration: gradient,
            padding: EdgeInsets.only(
              top: 4.0,
              bottom: 8.0,
              left: 12.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.timeAgo + ' ago',
                          style: TextStyle(fontSize: 11.0),
                        ),
                        Image.asset(
                          widget.activityTypeIconURL,
                          width: 16.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       expanded = !expanded;
                    //     });
                    //   },
                    //   icon: Icon(
                    //     Icons.more_vert,
                    //     color: Colors.white,
                    //     size: 20.0,
                    //   ),
                    // )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 60.0),
                      widget.centralWidget,
                      widget.centerRightWidget,
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                    bottom: 12.0,
                    left: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 20.0,
                        child: Image.asset(
                          widget.vendoLogoURL,
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.footerCenterText,
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        widget.footerRightText,
                        style: TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // if (expanded)
          //   Container(
          //     width: double.infinity,
          //     decoration: gradient,
          //     padding: EdgeInsets.only(
          //       top: 32.0,
          //       bottom: 20.0,
          //       left: 16.0,
          //       right: 16.0,
          //     ),
          //     child: Column(
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           child: Expanded(
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Column(
          //                   children: [
          //                     PerformanceDetailSnippetVertical(
          //                       label: 'Rank',
          //                       content: SuperScriptedDenominatorFractionHorizontal(
          //                         numerator: 18,
          //                         denomenator: 305,
          //                         numeratorColor: Color(0x44FFFFFF),
          //                       ),
          //                     ),
          //                     Row(
          //                       children: [
          //                         Image.asset(
          //                           'assets/icons/progress_up.png',
          //                           fit: BoxFit.fill,
          //                         ),
          //                         Text(
          //                           '3',
          //                           style: TextStyle(
          //                             color: Color(0x88FFFFFF),
          //                             fontSize: 12.0,
          //                             fontWeight: FontWeight.w600,
          //                           ),
          //                         ),
          //                       ],
          //                     )
          //                   ],
          //                 ),
          //                 SizedBox(width: 12),
          //                 Column(
          //                   children: [
          //                     PerformanceDetailSnippetVertical(
          //                       label: 'Points',
          //                       content: SuperScriptedDenominatorFractionHorizontal(
          //                         numerator: 205,
          //                         denomenator: 505,
          //                         numeratorColor: Color(0x44FFFFFF),
          //                       ),
          //                     ),
          //                     Text(
          //                       '+3pts',
          //                       style: TextStyle(
          //                         color: Color(0x88FFFFFF),
          //                         fontSize: 12.0,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //                 SizedBox(width: 12),
          //                 PerformanceDetailSnippetVertical(
          //                   label: 'Strength',
          //                   content: Column(
          //                     children: [
          //                       SignalStrengthIndicator.bars(
          //                         value: 0.8,
          //                         size: 44,
          //                         barCount: 5,
          //                         radius: Radius.circular(4.0),
          //                         levels: <num, Color>{
          //                           0.25: Colors.red,
          //                           0.50: Colors.yellow,
          //                           0.75: Colors.green,
          //                         },
          //                         inactiveColor: Colors.black26,
          //                         activeColor: Colors.white,
          //                       ),
          //                       SizedBox(height: 4),
          //                       Text(
          //                         '+2.5% gained',
          //                         style: TextStyle(
          //                           color: Color(0x88FFFFFF),
          //                           fontSize: 12.0,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         SizedBox(height: 20),
          //         Container(
          //           width: double.infinity,
          //           child: Expanded(
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Column(
          //                   children: [
          //                     PerformanceDetailSnippetVertical(
          //                       label: 'Exposure',
          //                       verticalSpacing: 12.0,
          //                       content: CircularProgressIndicatorWrapper(
          //                         progress: 65,
          //                         subCenterText: 'complete',
          //                         size: ProgressIndicatorSize.large,
          //                         progressColor: kProgressColors[3],
          //                       ),
          //                     ),
          //                     SizedBox(height: 4),
          //                     Text(
          //                       '+2.5% covered',
          //                       style: TextStyle(
          //                         color: Color(0x88FFFFFF),
          //                         fontSize: 12.0,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //                 SizedBox(width: 12),
          //                 Column(
          //                   children: [
          //                     PerformanceDetailSnippetVertical(
          //                       label: 'Mastery',
          //                       verticalSpacing: 12.0,
          //                       content: CircularProgressIndicatorWrapper(
          //                         progress: 85,
          //                         size: ProgressIndicatorSize.large,
          //                         progressColor: kProgressColors[4],
          //                         subCenterText: 'avg. score',
          //                       ),
          //                     ),
          //                     SizedBox(height: 4),
          //                     Text(
          //                       '+2.5% gained',
          //                       style: TextStyle(
          //                         color: Color(0x88FFFFFF),
          //                         fontSize: 12.0,
          //                         fontWeight: FontWeight.w600,
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //                 SizedBox(width: 12),
          //                 PerformanceDetailSnippetVertical(
          //                   label: 'Speed',
          //                   verticalSpacing: 12.0,
          //                   content: Column(
          //                     children: [
          //                       SpeedArc(speed: 2.5),
          //                       SizedBox(height: 4),
          //                       Text(
          //                         '+0.5 q/m',
          //                         style: TextStyle(
          //                           color: Color(0x88FFFFFF),
          //                           fontSize: 12.0,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         )
          //       ],
          //     ),
          //   )
        ],
      ),
    );
  }
}
