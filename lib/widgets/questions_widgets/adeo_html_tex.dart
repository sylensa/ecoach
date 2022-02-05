import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:html/parser.dart' as htmlparser;

CustomRenderMatcher texMatcher() =>
    (context) => context.tree.element?.localName == 'tex';

class AdeoHtmlTex extends StatefulWidget {
  const AdeoHtmlTex(
    this.user,
    this.text, {
    Key? key,
    this.textColor = Colors.white,
    this.fontSize = 23,
    this.fontStyle = FontStyle.normal,
    this.removeTags = false,
  }) : super(key: key);

  final User user;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontStyle fontStyle;
  final bool removeTags;

  @override
  _AdeoHtmlTexState createState() => _AdeoHtmlTexState();
}

class _AdeoHtmlTexState extends State<AdeoHtmlTex> {
  @override
  Widget build(BuildContext context) {
    return Html(
      data: setTexTags(widget.text, removeTags: widget.removeTags),
      style: {
        "body": Style(
            color: widget.textColor,
            fontSize: FontSize(widget.fontSize),
            fontStyle: widget.fontStyle,
            textAlign: TextAlign.center),
      },
      customRenders: {
        networkSourceMatcher(): CustomRender.widget(widget: (context, element) {
          String? link = context.tree.element!.attributes['src'];
          if (link != null) {
            String name = link.substring(link.lastIndexOf("/") + 1);
            print("Image: $name");

            return Image.file(
              widget.user.getImageFile(name),
            );
          }
          return Text("No link");
        }),
        texMatcher():
            CustomRender.widget(widget: (RenderContext context, child) {
          return Math.tex(
            context.tree.element!.text,
            textStyle: TextStyle(
              fontSize: 16,
              fontStyle: widget.fontStyle,
            ),
          );
        }),
      },
      tagsList: Html.tags..addAll(["tex"]),
    );
  }
}

class AdeoAnswerTex extends StatefulWidget {
  AdeoAnswerTex(this.user, this.text, this.selected,
      {Key? key,
      this.normalSize,
      this.selectedSize,
      this.imposedSize,
      this.color = Colors.white,
      this.selectedColor = Colors.white,
      this.imposedColor,
      this.removeTags = false})
      : super(key: key);

  User user;
  String text;
  bool selected;
  bool removeTags;
  double? normalSize;
  double? selectedSize;
  double? imposedSize;
  Color? color;
  Color? selectedColor;
  Color? imposedColor;

  @override
  _AdeoAnswerTexState createState() => _AdeoAnswerTexState();
}

class _AdeoAnswerTexState extends State<AdeoAnswerTex> {
  @override
  Widget build(BuildContext context) {
    return Html(
      data: setTexTags(widget.text, removeTags: widget.removeTags),
      style: {
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
      },
      customRenders: {
        networkSourceMatcher(): CustomRender.widget(widget: (context, element) {
          String? link = context.tree.element!.attributes['src'];
          if (link != null) {
            String name = link.substring(link.lastIndexOf("/") + 1);
            print("Image: $name");

            return Image.file(
              widget.user.getImageFile(name),
            );
          }
          return Text("No link");
        }),
        texMatcher():
            CustomRender.widget(widget: (RenderContext context, child) {
          return Math.tex(
            context.tree.element!.text,
            textStyle: TextStyle(
              color: widget.imposedColor != null
                  ? widget.imposedColor
                  : widget.selected
                      ? widget.selectedColor
                      : widget.color,
              fontSize: widget.imposedSize != null
                  ? widget.imposedSize
                  : widget.selected
                      ? widget.selectedSize ?? 40
                      : widget.normalSize ?? 16,
            ),
          );
        }),
      },
      tagsList: Html.tags..addAll(["tex"]),
    );
  }
}

setTexTags(String? text, {bool removeTags = false}) {
  if (text == null) return "";

  if (removeTags) {
    text = parseHtmlString(text);
  }

  RegExp reg = RegExp(r'\\\((.+?)\\\)');
  Iterable<RegExpMatch> matches = reg.allMatches(text);
  print("matches count=${matches.length}");
  List<String> subTexts = [];
  matches.forEach((m) {
    String mathEquation = text!.substring(m.start, m.end);
    print("Match: ${mathEquation}");
    subTexts.add(mathEquation);
  });
  subTexts.forEach((equation) {
    text = text!.replaceAll(equation, "<tex> $equation </tex>");
  });

  text = text!
      .replaceAll("<tex><tex>", "<tex>")
      .replaceAll("</tex></tex>", "</tex>")
      .replaceAll('\\(', "")
      .replaceAll('\\)', "");

  print(text);
  return text;
}

String parseHtmlString(String htmlString) {
  final document = htmlparser.parse(htmlString);
  final String parsedString =
      htmlparser.parse(document.body!.text).documentElement!.text;

  return parsedString;
}
