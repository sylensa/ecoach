import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:just_audio/just_audio.dart';
import 'package:slider_button/slider_button.dart';

import 'customer_button_swipe.dart';

class LevelContainer extends StatefulWidget {
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
  State<LevelContainer> createState() => _LevelContainerState();
}

class _LevelContainerState extends State<LevelContainer> {
  AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    player.setAsset("assets/sound/level_sound.mp3");
    player.play();
  }

  @override
  void dispose() {
   player.dispose();
    super.dispose();
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeInLeft(
                duration: Duration(milliseconds: 1000),
                child: Text(
                  widget.level,
                  style: const TextStyle(
                      fontFamily: 'Alba', fontSize: 80, color: Colors.white),
                ),
              ),
              FadeInRight(
                duration: Duration(milliseconds: 1000),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BounceInUp(child: Image.asset(widget.image)),
              const SizedBox(
                height: 20,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.time,
                    textStyle: const TextStyle(
                        fontFamily: 'Helvetica',
                        color: Colors.black26,
                        fontSize: 25),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 10),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              // Animated(
              //   child: Text(
              //     time,
              //     style: const TextStyle(
              //         fontFamily: 'Helvetica',
              //         color: Colors.black26,
              //         fontSize: 25),
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: CustomSwipeableButtonView(
                  // indicatorColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  buttonWidget: CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.blue,
                      child:
                          Image.asset('assets/images/learn_mode2/arrows.png')),
                  buttonText: 'Swipe to start',
                  activeColor: Colors.white.withOpacity(0.4),
                  buttontextstyle: TextStyle(
                      color: Color(0xFF023F6E),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500),
                  onWaitingProcess: () {
                    Future.delayed(Duration(seconds: 2), () {
                      widget.onSwipe();
                    });
                  },
                  onFinish: () async {},

                  buttonColor: const Color(0xFF0367B4),

                  // backgroundColor: const Color.fromRGBO(232, 245, 255, 0.3),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
