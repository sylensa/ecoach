import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EndQuestionWidget extends StatefulWidget {
  const EndQuestionWidget({Key? key}) : super(key: key);

  @override
  State<EndQuestionWidget> createState() => _EndQuestionWidgetState();
}

class _EndQuestionWidgetState extends State<EndQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: 20.w,
              child: const Divider(
                thickness: 3,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const SizedBox(
            height: 52,
          ),
          const Text(
            "Are you sure you want to quit the test",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF606C7A),
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 33),
          testButton(
              text: "Yes",
              color: const Color(0xFFFF6060),
              onPressed: () {
                Get.back();
                Get.back();
              }),
          SizedBox(height: 4.h),
          testButton(
              text: "No",
              color: const Color(0xFF00C664),
              onPressed: () {
                Get.back();
              }),
          const SizedBox(height: 82),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.h),
          topRight: Radius.circular(4.h),
        ),
      ),
    );
  }

  Container customButton(text) {
    return Container(
      height: 58,
      width: 285,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: const Color(
              0xFF707070,
            ),
          )),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  OutlinedButton testButton(
      {required String text,
      required Color color,
      required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
          vertical: 17,
        )),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),

        side: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            return states.contains(MaterialState.pressed)
                ? BorderSide.none
                : const BorderSide(
                    color: Color(0xFF707070),
                    width: 1,
                  );
          },
        ),
        // backgroundColor: MaterialStateProperty.resolveWith(
        //   (states) => states.contains(MaterialState.pressed)
        //       ? Colors.red
        //       : Colors.white,
        // ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed)
              ? Colors.white
              : Colors.black,
        ),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) =>
              states.contains(MaterialState.pressed) ? color : Colors.white,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
