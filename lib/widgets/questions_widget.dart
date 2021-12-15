import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/screen_size_reducers.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/widgets/select_text.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';

class QuestionWidget extends StatefulWidget {
  QuestionWidget(this.user, this.question,
      {Key? key,
      this.position,
      this.useTex = false,
      this.enabled = true,
      this.theme = QuizTheme.GREEN,
      this.callback})
      : super(key: key);
  User user;
  Question question;
  int? position;
  bool enabled;
  bool useTex;
  Function(Answer selectedAnswer)? callback;
  QuizTheme theme;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late List<Answer>? answers;
  Answer? selectedAnswer;
  Answer? correctAnswer;
  Color? backgroundColor;

  @override
  void initState() {
    if (widget.theme == QuizTheme.GREEN) {
      backgroundColor = const Color(0xFF00C664);
    } else {
      backgroundColor = const Color(0xFF5DA5EA);
    }
    answers = widget.question.answers;
    if (answers != null) {
      answers!.forEach((answer) {
        if (answer.value == 1) {
          correctAnswer = answer;
        }
      });
    }

    selectedAnswer = widget.question.selectedAnswer;
    print(widget.question.text);
    super.initState();
  }

  String getMathText(String? text) {
    if (text == null) return "";
    text = parseHtmlString(text);
    print(text);
    text = text.replaceAll('\(', "").replaceAll('\)', "");
    print(text);
    text = text.replaceAll(" ", "︎⁠​​\u1160");
    print("️|‍\u1160‌︎​|");
    print('_________________');
    text = String.fromCharCodes(new Runes(text));
    return r'' + '$text';
  }

  getTex(String? text) {
    if (text == null) return "";

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF595959),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFF444444),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Html(
                        data: getTex(widget.question.text),
                        style: {
                          "body": Style(
                            color: Colors.white,
                            fontSize: FontSize(23),
                          ),
                        },
                        customImageRenders: {
                          networkSourceMatcher():
                              (context, attributes, element) {
                            String? link = attributes['src'];
                            if (link != null) {
                              String name =
                                  link.substring(link.lastIndexOf("/") + 1);
                              print("Image: $name");

                              return Image.file(
                                widget.user.getImageFile(name),
                              );
                            }
                            return Text("No link");
                          },
                        },
                        customRender: {
                          'tex': (RenderContext context, child) {
                            return Math.tex(
                              context.tree.element!.text,
                              textStyle: TextStyle(
                                fontSize: 16,
                              ),
                            );
                          },
                        },
                        tagsList: Html.tags..addAll(["tex"]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: backgroundColor,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(80, 4, 80, 4),
                  child: widget.question.instructions != null &&
                          widget.question.instructions!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(40, 8.0, 40, 8),
                          child: Text(
                            widget.question.instructions!,
                            style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Container(
              color: Color(0xFF595959),
              child: widget.question.resource == ""
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Html(
                              data: getTex(widget.question.resource),
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: Colors.white,
                                  fontSize: FontSize(23),
                                ),
                              },
                              customImageRenders: {
                                networkSourceMatcher():
                                    (context, attributes, element) {
                                  String? link = attributes['src'];
                                  if (link != null) {
                                    String name = link
                                        .substring(link.lastIndexOf("/") + 1);
                                    print("Image: $name");

                                    return Image.file(
                                      widget.user.getImageFile(name),
                                    );
                                  }
                                  return Text("No link");
                                },
                              },
                              customRender: {
                                'tex': (RenderContext context, child) {
                                  return Math.tex(
                                    context.tree.element!.text,
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              },
                              tagsList: Html.tags..addAll(["tex"]),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Container(
              color: backgroundColor,
              height: 2,
            ),
            if (!widget.enabled &&
                selectedAnswer != null &&
                selectedAnswer!.solution != null &&
                selectedAnswer!.solution != "")
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: Container(
                        color: Colors.amber.shade200,
                        child: Center(
                          child: Text(
                            "Solution",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    if (selectedAnswer != null &&
                        selectedAnswer!.solution != null &&
                        selectedAnswer!.solution != "")
                      Container(
                        color: Colors.orange,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 8, 20, 8),
                            child: Html(
                              data: correctAnswer != null
                                  ? getTex(correctAnswer!.solution)
                                  : "----",
                              style: {
                                // tables will have the below background color
                                "body": Style(
                                  color: Colors.white,
                                ),
                              },
                              customImageRenders: {
                                networkSourceMatcher():
                                    (context, attributes, element) {
                                  String? link = attributes['src'];
                                  if (link != null) {
                                    String name = link
                                        .substring(link.lastIndexOf("/") + 1);
                                    print("Image: $name");

                                    return Image.file(
                                      widget.user.getImageFile(name),
                                    );
                                  }
                                  return Text("No link");
                                },
                              },
                              customRender: {
                                'tex': (RenderContext context, child) {
                                  return Math.tex(
                                    context.tree.element!.text,
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              },
                              tagsList: Html.tags..addAll(["tex"]),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            Container(
              color: Color(0xFF595959),
              child: widget.useTex
                  ? SelectTex(
                      answers!,
                      widget.question.selectedAnswer,
                      enabled: widget.enabled,
                      normalSize: 15,
                      selectedSize: widget.enabled ? 48 : 24,
                      correctSize: 48,
                      wrongSize: 24,
                      color: Colors.white,
                      selectedColor: Colors.white,
                      correctColor: Colors.green.shade600,
                      wrongColor: Colors.red.shade400,
                      select: (answer) {
                        if (!widget.enabled) {
                          return;
                        }
                        setState(() {
                          widget.question.selectedAnswer = answer;
                        });
                        widget.callback!(answer);
                      },
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < answers!.length; i++)
                          SelectHtml(widget.user, answers![i].text!,
                              widget.question.selectedAnswer == answers![i],
                              useTex: widget.useTex,
                              normalSize: 15,
                              selectedSize: widget.enabled ? 48 : 24,
                              imposedSize: widget.enabled ||
                                      (widget.enabled &&
                                          selectedAnswer == null) ||
                                      selectedAnswer != answers![i] &&
                                          answers![i].value == 0
                                  ? null
                                  : selectedAnswer == answers![i] &&
                                          selectedAnswer!.value == 0
                                      ? 24
                                      : 48,
                              imposedColor: widget.enabled ||
                                      (widget.enabled &&
                                          selectedAnswer == null) ||
                                      selectedAnswer != answers![i] &&
                                          answers![i].value == 0
                                  ? null
                                  : selectedAnswer == answers![i] &&
                                          selectedAnswer!.value == 0
                                      ? Colors.red.shade400
                                      : Colors.green.shade600, select: () {
                            if (!widget.enabled) {
                              return;
                            }
                            setState(() {
                              widget.question.selectedAnswer = answers![i];
                            });
                            widget.callback!(answers![i]);
                          })
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
