import 'package:flutter/material.dart';

class AssessmentButton extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  const AssessmentButton({Key? key, required this.image, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 220,
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white70,)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
