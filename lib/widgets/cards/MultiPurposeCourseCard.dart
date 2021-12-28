import 'package:ecoach/utils/manip.dart';
import 'package:flutter/material.dart';

class MultiPurposeCourseCard extends StatelessWidget {
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
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: Feedback.wrapForTap(onTap, context),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: isActive ? Color(0xFF2A9CEA) : Colors.white,
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
                        title.trim().toLowerCase().toTitleCase(),
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black87,
                          fontSize: hasSmallHeading! ? 11.0 : 16.0,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      if (subTitle.length > 0)
                        Column(
                          children: [
                            SizedBox(height: 4),
                            Text(
                              subTitle,
                              style: TextStyle(
                                color:
                                    isActive ? Colors.white : Color(0xAA000000),
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
                if (iconURL != null)
                  Container(
                    width: 35.0,
                    height: 35.0,
                    child: Image.asset(iconURL!, fit: BoxFit.fill),
                  )
                else if (subscription != null)
                  Text(
                    subscription!,
                    style: TextStyle(
                      color: Color(0xFF2A9CEA),
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (progress != null)
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
                        progress!.toString() + '%',
                        style: TextStyle(
                          color: isActive ? Colors.white : Color(0xFF2A9CEA),
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                else if (rightWidget != null)
                  rightWidget!
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
