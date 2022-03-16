import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

import 'adeo_html_tex.dart';

class SelectAnswerWidget extends StatefulWidget {
  SelectAnswerWidget(this.user, this.text, this.selected,
      {Key? key,
      this.id = "1",
      required this.select,
      this.normalSize,
      this.selectedSize,
      this.imposedSize,
      this.color = Colors.white,
      this.selectedColor = Colors.white,
      this.useTex = false,
      this.imposedColor})
      : super(key: key);

  User user;
  String id;
  String text;
  bool selected;
  bool useTex;
  Function select;
  double? normalSize;
  double? selectedSize;
  double? imposedSize;
  Color? color;
  Color? selectedColor;
  Color? imposedColor;

  @override
  _SelectAnswerWidgetState createState() => _SelectAnswerWidgetState();
}

class _SelectAnswerWidgetState extends State<SelectAnswerWidget> {
  @override
  void initState() {
    if (widget.useTex) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print("selecting answeer");
          widget.select();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
              child: Center(
                  child: AdeoAnswerTex(
            widget.user,
            widget.text,
            widget.selected,
            color: widget.color,
            imposedColor: widget.imposedColor,
            imposedSize: widget.imposedSize,
            normalSize: widget.normalSize,
            selectedColor: widget.selectedColor,
            selectedSize: widget.selectedSize,
          ))),
        ));
  }
}
