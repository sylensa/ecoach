// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomizeInputField extends StatefulWidget {
  CustomizeInputField(
      {Key? key,
      this.number = 0,
      this.digitNumber = 3,
      this.numberFocus,
      this.onChange})
      : super(key: key);

  final int? digitNumber;
  final int? number;
  FocusNode? numberFocus;
  final Function(int number)? onChange;

  @override
  _CustomizeInputFieldState createState() => _CustomizeInputFieldState();
}

class _CustomizeInputFieldState extends State<CustomizeInputField> {
  List<Widget> textField = [];
  String numberText = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.number == 0)
        numberText = "0";
      else
        numberText = widget.number.toString();
    });
  }

  addTextField(String number) {
    TextField tf = TextField(
      style: TextStyle(color: Colors.black, fontSize: 100),
      decoration: InputDecoration(
          fillColor: Colors.transparent, focusColor: Colors.black),
      controller: TextEditingController(text: number),
      maxLength: 1,
      enabled: false,
      readOnly: true,
    );

    textField.add(SizedBox(width: 60, child: tf));
  }

  getTextFields() {
    textField.clear();
    for (int i = 0; i < numberText.length; i++) {
      addTextField(numberText.substring(i, i + 1));
    }

    return textField;
  }

  submitText(String text) {
    numberText += text;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getTextFields(),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              child: SizedBox(
                width: 100,
                height: 30,
                child: ClipRect(
                  child: TextField(
                      focusNode: widget.numberFocus,
                      maxLength: widget.digitNumber,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (text) {
                        setState(() {
                          numberText = text;
                          if (numberText == "") {
                            numberText = "0";
                          }
                          widget.onChange!(int.parse(numberText));
                        });
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
