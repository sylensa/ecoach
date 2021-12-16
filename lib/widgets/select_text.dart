import 'package:flutter/material.dart';

class SelectText extends StatefulWidget {
  SelectText(this.text, this.selected,
      {Key? key,
      required this.select,
      this.normalSize,
      this.selectedSize,
      this.imposedSize,
      this.color = Colors.white,
      this.selectedColor = Colors.white,
      this.imposedColor,
      this.underlineSelected = false})
      : super(key: key);

  String text;
  bool selected;
  bool underlineSelected;
  Function select;
  double? normalSize;
  double? selectedSize;
  double? imposedSize;
  Color? color;
  Color? selectedColor;
  Color? imposedColor;

  @override
  _SelectTextState createState() => _SelectTextState();
}

class _SelectTextState extends State<SelectText> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.select();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
            child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
                color: widget.imposedColor != null
                    ? widget.imposedColor
                    : widget.selected
                        ? widget.selectedColor
                        : widget.color,
                fontSize: widget.imposedSize != null
                    ? widget.imposedSize
                    : widget.selected
                        ? (widget.selectedSize ?? 40)
                        : widget.normalSize ?? 16,
                decoration: widget.underlineSelected && widget.selected
                    ? TextDecoration.underline
                    : null),
          ),
        )),
      ),
    );
  }
}
