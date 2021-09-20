import 'package:flutter/material.dart';

class VerticalCaptionedImage extends StatelessWidget {
  const VerticalCaptionedImage({
    required this.imageUrl,
    this.caption = '',
  });

  final String imageUrl;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset(
            imageUrl,
            width: 48.0,
          ),
          if (caption.trim() != '')
            Column(
              children: [
                SizedBox(height: 4.0),
                Text(
                  caption,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
