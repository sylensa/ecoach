import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:slider_button/slider_button.dart';


class LevelContainer extends StatelessWidget {
  final String level;
  final String label;
  final String time;
  final String image;
  final Function onSwipe;
  const LevelContainer(
      {Key? key,
      required this.level,
      required this.label,
      required this.time,
      required this.image,
      required this.onSwipe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicFlexContainer(
      flex: 3,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),
      borderRadius: 30,
      border: 0,
      blur: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              level,
              style: const TextStyle(
                  fontFamily: 'Alba', fontSize: 80, color: Colors.white),
            ),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(image),
            const SizedBox(
              height: 20,
            ),
            Text(
              time,
              style: const TextStyle(
                  fontFamily: 'Helvetica', color: Colors.black26, fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            SliderButton(
              action: onSwipe,
              shimmer: true,
              label: const Text(
                'Swipe to start',
                style: TextStyle(
                    color: Color(0xFF023F6E),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500),
              ),
              buttonColor: const Color(0xFF0367B4),
              icon: Image.asset('assets/images/learn_mode2/arrows.png'),
              backgroundColor: const Color.fromRGBO(232, 245, 255, 0.3),
              width: double.infinity,
              height: 60,
              dismissible: true,
              alignLabel: const Alignment(0, 0),
              buttonSize: 50,
              boxShadow: const BoxShadow(
                color: Color.fromRGBO(56, 63, 131, 0.4),
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(2, 5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
