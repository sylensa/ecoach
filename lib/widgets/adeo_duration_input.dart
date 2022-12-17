import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdeoDurationInput extends StatefulWidget {
  const AdeoDurationInput({Key? key, required this.onDurationChange})
      : super(key: key);

  final Function(Duration duration) onDurationChange;

  @override
  State<AdeoDurationInput> createState() => _AdeoDurationInputState();
}

class _AdeoDurationInputState extends State<AdeoDurationInput> {
  late Widget textField1, textField2, textField3, textField4;
  List<TextField> textFields = [];
  List<LogicalKeyboardKey> keys = [];
  List<FocusNode> nodes = [];
  List<int> digits = [0, 0, 0, 0];

  @override
  void initState() {
    super.initState();

    textField1 = createTextField();
    textField2 = createTextField();
    textField3 = createTextField();
    textField4 = createTextField();
  }

  Widget createTextField() {
    final node = FocusNode();
    nodes.add(node);

    TextField tf = new TextField(
      focusNode: node,
      style: TextStyle(fontSize: 25),
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 25),
        hintStyle: TextStyle(fontSize: 25, color: Colors.black),
        hintText: '0',
      ),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      textInputAction: TextInputAction.next,
      onChanged: (text) {
        int index = nodes.indexOf(node);
        if (text.isNotEmpty) {
          setState(() {
            digits[index] = int.parse(text);
            if (index < 3) {
              FocusScope.of(context).requestFocus(nodes[index + 1]);
            }
          });
        } else {
          setState(() {
            digits[index] = 0;
            if (index > 0) {
              FocusScope.of(context).requestFocus(nodes[index - 1]);
            }
          });
        }

        String mins = digits[0].toString() + digits[1].toString();
        String secs = digits[2].toString() + digits[3].toString();

        widget.onDurationChange(Duration(minutes: int.parse(mins), seconds: int.parse(secs)));
      },
    );

    textFields.add(tf);
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: 30,
      child: FocusableActionDetector(
          autofocus: true,
          focusNode: FocusNode(),
          onFocusChange: (focus) {},
          child: tf),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textField1,
            textField2,
            Text(
              ":",
              style: TextStyle(fontSize: 25),
            ),
            textField3,
            textField4
          ]),
    );
  }
}
