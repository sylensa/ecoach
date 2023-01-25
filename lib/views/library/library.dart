import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/library-illus.png"),
          SizedBox(
            height: 12,
          ),
          sText(
            "Personalized Library",
            weight: FontWeight.bold,
            size: 16,
            color: kAdeoDark,
          ),
          SizedBox(
            height: 8,
          ),
          sText(
            "coming soon...",
            size: 14,
            color: kAdeoDark,
          ),
        ],
      ),
    );
  }
}
