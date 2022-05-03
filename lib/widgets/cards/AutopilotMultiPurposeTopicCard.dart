import 'package:ecoach/utils/general_utils.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class AutopilotMultiPurposeTopicCard extends StatefulWidget {
  const AutopilotMultiPurposeTopicCard({
    required this.title,
    required this.subTitle,
    this.isActive: false,
    this.iconURL: null,
    this.progress: null,
    this.subscription: null,
    this.hasProgressed: false,
    this.hasSmallHeading: false,
    this.rightWidget,
    this.onTap,
    this.isSelected: false,
    this.showInPercentage: false,
    required this.numberOfQuestions,
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
  final bool isSelected;
  final bool showInPercentage;
  final numberOfQuestions;
  final onTap;

  @override
  State<AutopilotMultiPurposeTopicCard> createState() =>
      _AutopilotMultiPurposeTopicCardState();
}

class _AutopilotMultiPurposeTopicCardState
    extends State<AutopilotMultiPurposeTopicCard> {
  bool isPressedDown = false;
  late bool isSelected = false;
  late bool showInPercentage = false;
  late dynamic numberOfQuestions;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
    showInPercentage = widget.showInPercentage;
    numberOfQuestions = widget.numberOfQuestions;
    print(widget.rightWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding:
                EdgeInsets.only(left: 7, top: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
              color: isPressedDown
                  ? widget.isActive
                      ? Color(0xFF0573BA)
                      : Color.fromARGB(26, 5, 4, 4)
                  : widget.isActive
                      ? Color(0xFF2A9CEA)
                      : Colors.white,
              borderRadius: BorderRadius.circular(0.0),
              border: isSelected
                  ? Border.all(
                      color: Colors.red,
                      width: 1,
                    )
                  : Border.all(
                      color: Colors.white,
                      width: 0,
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isSelected)
                  Container(
                    width: 35.0,
                    height: 35.0,
                    child: Image.asset(widget.iconURL!, fit: BoxFit.fill),
                  ),
                SizedBox(width: 14.0),
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
                if (isSelected)
                  Text(
                    "${numberOfQuestions}Q",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica Rounded',
                      color: Colors.black.withOpacity(0.6),
                    ),
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
                else if (widget.rightWidget != null && !isSelected)
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
      ),
    );
  }
}
