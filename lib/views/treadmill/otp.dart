import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        maxLength: 1,
        cursorColor: Colors.white,
        decoration: const InputDecoration(
            hintText: '0',
            //labelText: "0",
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.white, fontSize: 75.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
