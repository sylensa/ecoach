import 'package:flutter/material.dart';

import '../utils/text_styles.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: ListTile(
        leading: Image.asset(
          'assets/images/google_logo.png',
          height: 35,
          width: 34,
        ),
        title: Text("Continue with Google",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 17,
            )),
      ),
    );
  }
}
