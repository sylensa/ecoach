import 'package:ecoach/utils/general_utils.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiPurposeCourseCard extends StatefulWidget {
  const MultiPurposeCourseCard({
    required this.title,
    required this.subTitle,
    this.isActive: false,
    this.iconURL: null,
    this.progress: null,
    this.subscription: null,
    this.hasProgressed: false,
    this.hasSmallHeading: false,
    this.rightWidget,
    this.activeBackground: kAdeoBlue2,
    this.darkenActiveBackgroundOnPress: false,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final bool isActive;
  final String? iconURL;
  final double? progress;
  final bool? hasProgressed;
  final String? subscription;
  final bool? hasSmallHeading;
  final Widget? rightWidget;
  final Color activeBackground;
  final bool darkenActiveBackgroundOnPress;
  final onTap;

  @override
  State<MultiPurposeCourseCard> createState() => _MultiPurposeCourseCardState();
}

class _MultiPurposeCourseCardState extends State<MultiPurposeCourseCard> {
  bool isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: Feedback.wrapForTap(() async {
            setState(() {
              isPressedDown = true;
            });
            await Future.delayed(Duration(milliseconds: 300));
            widget.onTap();
            setState(() {
              isPressedDown = false;
            });
          }, context),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: isPressedDown
                  ? widget.isActive
                      ? widget.darkenActiveBackgroundOnPress
                          ? darken(widget.activeBackground)
                          : Color(0xFF0573BA)
                      : Color(0x1A000000)
                  : widget.isActive
                      ? widget.activeBackground
                      : Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title.trim().toLowerCase().toTitleCase(),
                        style: TextStyle(
                          color:
                              widget.isActive ? Colors.white : Colors.black87,
                          fontSize: widget.hasSmallHeading! ? 11.0 : 16.0,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      if (widget.subTitle.length > 0)
                        Column(
                          children: [
                            SizedBox(height: 4),
                            Text(
                              widget.subTitle,
                              style: TextStyle(
                                color: widget.isActive
                                    ? Colors.white
                                    : Color(0xAA000000),
                                fontSize: 9.0,
                                fontStyle: FontStyle.italic,
                                height: 1.2,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                SizedBox(width: 24.0),
                if (widget.iconURL != null)
                  Container(
                    width: 35.0,
                    height: 35.0,
                    child: Image.asset(widget.iconURL!, fit: BoxFit.fill),
                  )
                else if (widget.subscription != null)
                  Text(
                    widget.subscription!,
                    style: TextStyle(
                      color: Color(0xFF2A9CEA),
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (widget.progress != null)
                  Row(
                    children: [
                      // Container(
                      //   width: 16.0,
                      //   height: 12.0,
                      //   child: Image.asset(
                      //     hasProgressed!
                      //         ? 'assets/icons/progress_up.png'
                      //         : 'assets/icons/progress_down.png',
                      //     fit: BoxFit.fill,
                      //   ),
                      // ),
                      // SizedBox(width: 4),
                      Text(
                        widget.progress!.toString() + '%',
                        style: TextStyle(
                          color: widget.isActive
                              ? Colors.white
                              : Color(0xFF2A9CEA),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                else if (widget.rightWidget != null)
                  widget.rightWidget!
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class FractionSnippet extends StatelessWidget {
  const FractionSnippet({
    Key? key,
    required this.correctlyAnswered,
    required this.totalQuestions,
    required this.isSelected,
  }) : super(key: key);

  final correctlyAnswered;
  final totalQuestions;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          correctlyAnswered.toString(),
          style: kRightWidgetStyle(isSelected).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '/',
          style: kRightWidgetStyle(isSelected),
        ),
        Text(
          totalQuestions.toString(),
          style: kRightWidgetStyle(isSelected),
        ),
      ],
    );
  }
}

class PercentageSnippet extends StatelessWidget {
  const PercentageSnippet({
    Key? key,
    required this.correctlyAnswered,
    required this.totalQuestions,
    required this.isSelected,
  }) : super(key: key);

  final correctlyAnswered;
  final totalQuestions;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Text(
      calculatePercentage(
        totalQuestions,
        correctlyAnswered,
      ),
      style: kRightWidgetStyle(isSelected).copyWith(
        fontWeight: FontWeight.w700,
        color: Color(0xFF2A9CEA)
      ),
    );
  }
}

class MultiPurposeCourseCardAnnex extends StatefulWidget {
  const MultiPurposeCourseCardAnnex({
    required this.title,
    required this.subTitle,
    this.isActive: false,
    this.iconURL: null,
    this.progress: null,
    this.subscription: null,
    this.hasProgressed: false,
    this.hasSmallHeading: false,
    this.rightWidget,
    this.activeBackground: kAdeoBlue2,
    this.darkenActiveBackgroundOnPress: false,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final bool isActive;
  final String? iconURL;
  final double? progress;
  final bool? hasProgressed;
  final String? subscription;
  final bool? hasSmallHeading;
  final Widget? rightWidget;
  final Color activeBackground;
  final bool darkenActiveBackgroundOnPress;
  final onTap;

  @override
  State<MultiPurposeCourseCardAnnex> createState() => _MultiPurposeCourseCardAnnexState();
}

class _MultiPurposeCourseCardAnnexState extends State<MultiPurposeCourseCardAnnex> {
  bool isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: Feedback.wrapForTap(() async {
            setState(() {
              isPressedDown = true;
            });
            await Future.delayed(Duration(milliseconds: 300));
            widget.onTap();
            setState(() {
              isPressedDown = false;
            });
          }, context),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: isPressedDown
                  ? widget.isActive
                  ? widget.darkenActiveBackgroundOnPress
                  ? darken(widget.activeBackground)
                  : Color(0xFF0573BA)
                  : Color(0x1A000000)
                  : widget.isActive
                  ? Colors.white
                  : Colors.blue[100],
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title.trim().toLowerCase().toTitleCase(),
                        style: TextStyle(
                          color:
                          widget.isActive ? Color(0xFF2A9CEA) : Color(0xFF2A9CEA),
                          fontSize: widget.hasSmallHeading! ? 11.0 : 16.0,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      if (widget.subTitle.length > 0)
                        Column(
                          children: [
                            SizedBox(height: 4),
                            Text(
                              widget.subTitle,
                              style: TextStyle(
                                color: widget.isActive
                                    ? Color(0xFF2A9CEA)
                                    : Color(0xFF2A9CEA),
                                fontSize: 9.0,
                                fontStyle: FontStyle.italic,
                                height: 1.2,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
                SizedBox(width: 24.0),
                if (widget.iconURL != null)
                  Container(
                    width: 35.0,
                    height: 35.0,
                    child: Image.asset(widget.iconURL!, fit: BoxFit.fill),
                  )
                else if (widget.subscription != null)
                  Text(
                    widget.subscription!,
                    style: TextStyle(
                      color: Color(0xFF2A9CEA),
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (widget.progress != null)
                    Row(
                      children: [
                        // Container(
                        //   width: 16.0,
                        //   height: 12.0,
                        //   child: Image.asset(
                        //     hasProgressed!
                        //         ? 'assets/icons/progress_up.png'
                        //         : 'assets/icons/progress_down.png',
                        //     fit: BoxFit.fill,
                        //   ),
                        // ),
                        // SizedBox(width: 4),
                        Text(
                          widget.progress!.toString() + '%',
                          style: TextStyle(
                            color: widget.isActive
                                ? Colors.white
                                : Color(0xFF2A9CEA),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )
                  else if (widget.rightWidget != null)
                      widget.rightWidget!
              ],
            ),
          ),
        ),
        SizedBox(height: 0),
      ],
    );
  }
}