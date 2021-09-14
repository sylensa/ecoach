import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;

class SelectText extends StatefulWidget {
  SelectText(this.text, this.selected,
      {Key? key,
      required this.select,
      this.normalSize,
      this.selectedSize,
      this.imposedSize})
      : super(key: key);

  String text;
  bool selected;
  Function select;
  double? normalSize;
  double? selectedSize;
  double? imposedSize;

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
                color: Colors.white,
                fontSize: widget.imposedSize != null
                    ? widget.imposedSize
                    : widget.selected
                        ? (widget.selectedSize ?? 40)
                        : widget.normalSize ?? 16),
          ),
        )),
      ),
    );
  }
}

class SelectHtml extends StatefulWidget {
  SelectHtml(this.text, this.selected,
      {Key? key,
      required this.select,
      this.normalSize,
      this.selectedSize,
      this.imposedSize})
      : super(key: key);

  String text;
  bool selected;
  Function select;
  double? normalSize;
  double? selectedSize;
  double? imposedSize;

  @override
  _SelectHtmlState createState() => _SelectHtmlState();
}

class _SelectHtmlState extends State<SelectHtml> {
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
          child: Html(data: parseHtmlString(widget.text), style: {
            // tables will have the below background color
            "body": Style(
              color: Colors.white,
              fontSize: widget.imposedSize != null
                  ? FontSize(widget.imposedSize)
                  : widget.selected
                      ? FontSize(widget.selectedSize ?? 40)
                      : FontSize(widget.normalSize ?? 16),
            ),
          }),
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
