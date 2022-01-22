import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomizeInputField extends StatefulWidget {
  const CustomizeInputField({Key? key}) : super(key: key);

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
      numberText = "0";
    });
  }

  addTextField(String number) {
    TextField tf = TextField(
      style: TextStyle(color: Colors.black, fontSize: 60),
      decoration: InputDecoration(
          fillColor: Colors.transparent, focusColor: Colors.black),
      controller: TextEditingController(text: number),
      maxLength: 1,
      enabled: false,
      readOnly: true,
    );

    textField.add(SizedBox(width: 40, child: tf));
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
            Visibility(
              visible: false,
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              child: SizedBox(
                width: 100,
                height: 40,
                child: TextField(
                    autofocus: true,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (text) {
                      setState(() {
                        numberText = text;
                        if (numberText == "") {
                          numberText = "0";
                        }
                      });
                    }),
              ),
            ),
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getTextFields(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
