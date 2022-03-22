import 'package:flutter/material.dart';

int LENGTH = 0;

class OTPWidget extends StatefulWidget {
  int length;
  Function(int number)? onChange;
  OTPWidget({Key? key, this.length = 4, this.onChange}) : super(key: key) {
    LENGTH = length;
  }

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  getNumber() {
    String str =
        _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text;
    try {
      int number = int.parse(str);
      widget.onChange!(number);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OtpInput(_fieldOne, true, 0, () {
            getNumber();
          }),
          OtpInput(_fieldTwo, false, 1, () {
            getNumber();
          }),
          OtpInput(_fieldThree, false, 2, () {
            getNumber();
          }),
          OtpInput(_fieldFour, false, 3, () {
            getNumber();
          })
        ],
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final int position;
  final Function onChange;
  const OtpInput(this.controller, this.autoFocus, this.position, this.onChange,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Colors.orange,
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
            ),
            border: const OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.orange),
            ),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1 && position < LENGTH) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length == 0 && position > 0) {
            FocusScope.of(context).previousFocus();
          }
          onChange();
        },
      ),
    );
  }
}
