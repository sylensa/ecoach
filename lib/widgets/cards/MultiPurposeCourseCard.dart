import 'package:flutter/material.dart';

class MultiPurposeCourseCard extends StatelessWidget {
  const MultiPurposeCourseCard({
    required this.title,
    required this.subTitle,
    this.isActive: false,
    this.iconURL: null,
    this.progress: null,
    this.hasProgressed: false,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final bool isActive;
  final String? iconURL;
  final double? progress;
  final bool hasProgressed;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
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
                    title,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: isActive ? Colors.white : Color(0xAA000000),
                      fontSize: 12.0,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 40.0),
            iconURL != null
                ? Container(
                    width: 36.0,
                    height: 36.0,
                    child: Image.asset(iconURL!, fit: BoxFit.fill),
                  )
                : Row(
                    children: [
                      Container(
                        width: 16.0,
                        height: 12.0,
                        child: Image.asset(
                          hasProgressed
                              ? 'assets/icons/progress_up.png'
                              : 'assets/icons/progress_down.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        progress!.toString() + '%',
                        style: TextStyle(
                          color: isActive ? Colors.white : Color(0xFF2A9CEA),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
