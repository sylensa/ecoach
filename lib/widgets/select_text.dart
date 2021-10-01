import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:html/parser.dart' as htmlparser;

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

class SelectHtml extends StatefulWidget {
  SelectHtml(this.text, this.selected,
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
  _SelectHtmlState createState() => _SelectHtmlState();
}

class _SelectHtmlState extends State<SelectHtml> {
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
          child: !widget.useTex
              ? Html(data: parseHtmlString(widget.text), style: {
                  // tables will have the below background color
                  "body": Style(
                    color: widget.imposedColor != null
                        ? widget.imposedColor
                        : widget.selected
                            ? widget.selectedColor
                            : widget.color,
                    fontSize: widget.imposedSize != null
                        ? FontSize(widget.imposedSize)
                        : widget.selected
                            ? FontSize(widget.selectedSize ?? 40)
                            : FontSize(widget.normalSize ?? 16),
                  ),
                })
              : SizedBox(
                  width: screenWidth(context),
                  child: TeXView(
                    child: TeXViewGroup(
                        children: [
                          TeXViewGroupItem(
                            id: widget.id,
                            child: TeXViewDocument(widget.text,
                                style: TeXViewStyle(
                                  backgroundColor: Color(0xFF595959),
                                  contentColor: widget.imposedColor != null
                                      ? widget.imposedColor
                                      : widget.selected
                                          ? widget.selectedColor
                                          : widget.color,
                                  fontStyle: TeXViewFontStyle(
                                    fontSize: widget.imposedSize != null
                                        ? widget.imposedSize!.floor()
                                        : widget.selected
                                            ? widget.selectedSize!.floor()
                                            : widget.normalSize!.floor(),
                                  ),
                                )),
                          )
                        ],
                        onTap: (String id) {
                          widget.select();
                        }),
                  ),
                ),
        )),
      ),
    );
  }

  String parseHtmlString(String htmlString) {
    final document = htmlparser.parse(htmlString);
    final String parsedString =
        htmlparser.parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
