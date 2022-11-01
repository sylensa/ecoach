import 'package:flutter/material.dart';

class GreenPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const GreenPillButton({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 250,
        decoration: BoxDecoration(
            color: const Color(0xFF00C9B9),
            borderRadius: BorderRadius.circular(100)
        ),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500),),
      ),
    );
  }
}
