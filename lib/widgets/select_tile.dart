import 'dart:async';

import 'package:flutter/material.dart';

class SelectTile extends StatefulWidget {
  SelectTile({
    Key? key,
    this.selected = false,
    this.color,
    this.selectColor = Colors.transparent,
    this.child,
    this.callback,
  }) : super(key: key);
  bool selected;
  Color? color;
  Color? selectColor;
  Widget? child;
  Function(bool selected)? callback;

  @override
  _SelectTileState createState() => _SelectTileState();
}

class _SelectTileState extends State<SelectTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          print("old select = ${widget.selected}");
          widget.selected = !widget.selected;
        });
        if (widget.callback != null) {
          print("item ${widget.selected}");
          await widget.callback!(widget.selected);
        }
      },
      child: Container(
        decoration: widget.selected
            ? BoxDecoration(
                color: widget.selectColor,
                border: Border.all(width: 3, style: BorderStyle.solid))
            : null,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            color: widget.color,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
