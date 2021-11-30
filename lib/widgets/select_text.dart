import 'package:ecoach/models/question.dart';
import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
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
                                        contentColor:
                                            widget.imposedColor != null
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
                      )),
          )),
    );
  }
}

class SelectTex extends StatefulWidget {
  SelectTex(this.answers, this.selectedAnswer,
      {Key? key,
      required this.select,
      this.normalSize,
      this.selectedSize,
      this.correctSize,
      this.wrongSize,
      this.color = Colors.white,
      this.selectedColor = Colors.white,
      this.correctColor = Colors.green,
      this.wrongColor = Colors.red,
      this.enabled = true})
      : super(key: key);

  List<Answer> answers;
  Answer? selectedAnswer;
  Function(Answer answer) select;
  double? normalSize;
  double? selectedSize;
  double? correctSize;
  double? wrongSize;
  Color? color;
  Color? selectedColor;
  Color? correctColor;
  Color? wrongColor;
  bool enabled;

  @override
  _SelectTexState createState() => _SelectTexState();
}

class _SelectTexState extends State<SelectTex> {
  bool selected(Answer answer, int i) {
    print("answer = ${answer.text} i=$i, ${widget.selectedAnswer == answer}");
    return widget.selectedAnswer == answer;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
            child: Center(
                child: SizedBox(
          width: screenWidth(context),
          child: TeXView(
            child: TeXViewGroup(
                children: [
                  for (int i = 0; i < widget.answers.length; i++)
                    TeXViewGroupItem(
                      id: "$i",
                      child: TeXViewDocument(
                          parseHtmlString(widget.answers[i].text!),
                          style: widget.enabled
                              ? null
                              : TeXViewStyle(
                                  padding: TeXViewPadding.all(12),
                                  contentColor: widget.enabled
                                      ? widget.color
                                      : widget.answers[i].value! == 1
                                          ? widget.correctColor
                                          : selected(widget.answers[i], i)
                                              ? widget.wrongColor
                                              : widget.color,
                                  fontStyle: TeXViewFontStyle(
                                      fontSize: widget.enabled
                                          ? widget.normalSize!.floor()
                                          : widget.answers[i].value! == 1
                                              ? widget.correctSize!.floor()
                                              : selected(widget.answers[i], i)
                                                  ? widget.wrongSize!.floor()
                                                  : widget.normalSize!
                                                      .floor()))),
                    )
                ],
                selectedItemStyle: TeXViewStyle(
                    contentColor: widget.selectedColor,
                    fontStyle: TeXViewFontStyle(
                        fontSize: widget.selectedSize!.floor())),
                normalItemStyle: TeXViewStyle(
                    padding: TeXViewPadding.all(12),
                    contentColor: widget.color,
                    fontStyle:
                        TeXViewFontStyle(fontSize: widget.normalSize!.floor())),
                onTap: (String id) {
                  if (!widget.enabled) {
                    return;
                  }
                  print("id = $id");
                  Answer answer = widget.answers[int.parse(id)];
                  setState(() {
                    widget.selectedAnswer = answer;
                    print(widget.selectedAnswer == answer);
                  });
                  widget.select(answer);
                }),
            style: TeXViewStyle(
              backgroundColor: Color(0xFF595959),
            ),
          ),
        ))));
  }
}
