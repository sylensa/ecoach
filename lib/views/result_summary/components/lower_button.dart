import 'package:flutter/material.dart';

class LowerButtons extends StatelessWidget {
  const LowerButtons({
    Key? key,
    required this.height,
    required this.width,
    required this.text,
    required this.orientation,
    required this.image,
    required this.onpress,
  }) : super(key: key);

  final double height;
  final double width;
  final String text, image;
  final Orientation orientation;
  final Function onpress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onpress(),
      child: Container(
        height: orientation == Orientation.portrait
            ? height * 0.065
            : height * 0.11,
        width: orientation == Orientation.portrait ? width * 0.3 : width * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            orientation == Orientation.portrait ? height * 0.022 : width * 0.02,
          ),
          color: const Color(0XFF1F2E41),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              color: Colors.white,
              height: orientation == Orientation.portrait
                  ? height * 0.025
                  : width * 0.04,
              width: orientation == Orientation.portrait
                  ? height * 0.025
                  : width * 0.025,
            ),
            SizedBox(width: width * 0.025),
            Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: height * 0.02,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
