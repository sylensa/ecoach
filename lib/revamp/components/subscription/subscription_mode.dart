import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class SubscriptionMode extends StatelessWidget {
  const SubscriptionMode({
    Key? key,
    required this.label,
    required this.imageUrl,
    required this.fxn,
    required this.bundleMode,
  }) : super(key: key);
  final String label;
  final String imageUrl;
  final VoidCallback fxn;
  final String bundleMode;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: fxn,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: bundleMode == label.toLowerCase()
                        ? Colors.blue
                        : Colors.transparent,
                    width: 3),
              ),
              padding: const EdgeInsets.all(3.0),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: bundleMode == label.toLowerCase()
                    ? Colors.blue
                    : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(imageUrl),
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PoppinsRegular',
                color: bundleMode == label.toLowerCase()
                    ? Colors.blue
                    : kDefaultBlack2SubtextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
