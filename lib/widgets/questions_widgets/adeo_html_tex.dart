import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:html/parser.dart' as htmlparser;

CustomRenderMatcher texMatcher() =>
    (context) => context.tree.element?.localName == 'tex';

double imageWidth = 400;
double imageHeight = 400;

class AdeoHtmlTex extends StatefulWidget {
  const AdeoHtmlTex(
    this.user,
    this.text, {
    Key? key,
    this.textColor = Colors.white,
    this.fontSize = 23,
    this.fontStyle = FontStyle.normal,
    this.imageSize,
    this.useLocalImage = true,
    this.removeTags = false,
  }) : super(key: key);

  final User user;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontStyle fontStyle;
  final Size? imageSize;
  final bool useLocalImage;
  final bool removeTags;

  @override
  _AdeoHtmlTexState createState() => _AdeoHtmlTexState();
}

class _AdeoHtmlTexState extends State<AdeoHtmlTex> {
  @override
  void initState() {
    print(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 10),
      child: Html(
        data: setTexTags(widget.text,
            removeTags: widget.removeTags, removeBr: true),
        style: {
          "body": Style(
              color: widget.textColor,
              maxLines: 7,
              fontSize: FontSize(widget.fontSize),
              fontStyle: widget.fontStyle,
              padding: const EdgeInsets.only(right: 21, left: 10),
              textAlign: TextAlign.center),
          "p": Style(
            padding: EdgeInsets.all(0),
          ),
          "table": Style(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              width: 1,
              fontSize: FontSize(widget.fontSize),
              fontStyle: widget.fontStyle,
              textAlign: TextAlign.center),
          "tr": Style(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              width: 1,
              fontSize: FontSize(widget.fontSize),
              fontStyle: widget.fontStyle,
              textAlign: TextAlign.center),
          "td": Style(
              color: Colors.black,
              alignment: Alignment.center,
              padding: EdgeInsets.all(2),
              fontSize: FontSize(widget.fontSize),
              fontStyle: widget.fontStyle,
              textAlign: TextAlign.center),
          'img': Style(
              width: imageWidth,
              height: imageHeight,
              padding: EdgeInsets.all(0)),
        },
        customRenders: {
          if (widget.useLocalImage)
            networkSourceMatcher():
                CustomRender.widget(widget: (context, element) {
              String? link = context.tree.element!.attributes['src'];
              if (link != null) {
                String name = link.substring(link.lastIndexOf("/") + 1);
                print("Image: $name");
                print("link: $link");

                return Image.file(
                  widget.user.getImageFile(name),
                );
              }
              return Text("No link");
            }),
          texMatcher():
              CustomRender.widget(widget: (RenderContext context, child) {
            print(context.tree.element!.text);
            return Math.tex(
              context.tree.element!.text,
              textStyle: TextStyle(
                color: widget.textColor,
                fontSize: 16,
                fontStyle: widget.fontStyle,
              ),
            );
          }),
          tableMatcher(): CustomRender.widget(widget: (context, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: tableRender().widget!.call(context, child),
            );
          }),
        },
        tagsList: Html.tags..addAll(["tex"]),
      ),
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
      data: setTexTags(widget.text,
          removeTags: widget.removeTags, removeBr: true),
      style: {
        "body": Style(
          padding: const EdgeInsets.only(right: 21, left: 10),
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
          textAlign: TextAlign.center,
        ),
        'table': Style(
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 1)),
        'td': Style(
            textAlign: TextAlign.center,
            alignment: Alignment.center,
            padding: EdgeInsets.all(2),
            border: Border.all(color: Colors.white, width: 1)),
        'th': Style(backgroundColor: Colors.blue),
        'img': Style(
            width: imageWidth, height: imageHeight, padding: EdgeInsets.all(0)),
      },
      customRenders: {
        networkSourceMatcher(): CustomRender.widget(widget: (context, element) {
          String? link = context.tree.element!.attributes['src'];
          if (link != null) {
            String name = link.substring(link.lastIndexOf("/") + 1);
            print("Image: $name");

            return Container(
                decoration: widget.selected
                    ? BoxDecoration(
                        border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ))
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    widget.user.getImageFile(name),
                  ),
                ));
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
        tableMatcher(): CustomRender.widget(widget: (context, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: tableRender().widget!.call(context, child),
          );
        }),
      },
      tagsList: Html.tags..addAll(["tex"]),
    );
  }
}

setTexTags(String? text, {bool removeTags = false, bool removeBr = false}) {
  if (text == null) return "";

  if (removeTags) {
    text = parseHtmlString(text);
  }

  RegExp reg = RegExp(r'\\\((.+?)\\\)');
  Iterable<RegExpMatch> matches = reg.allMatches(text);
  List<String> subTexts = [];
  matches.forEach((m) {
    String mathEquation = text!.substring(m.start, m.end);

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

  if (removeBr) {
    text = text!
        .replaceAll("<br>", "")
        .replaceAll("<br/>", "")
        .replaceAll("<p>", "")
        .replaceAll("<p/>", "")
        .replaceAll("</p>", "");

    //print(text);
  }
  return text;
}

String parseHtmlString(String htmlString) {
  final document = htmlparser.parse(htmlString);
  final String parsedString =
      htmlparser.parse(document.body!.text).documentElement!.text;

  return parsedString;
}
