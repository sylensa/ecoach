import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(26),
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/oval-pattern.png"),
          fit: BoxFit.cover,
        ),
        color: Color(0XFF0ff0364AE),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0364AE),
            Color(0xFF023760),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
