import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';

class NoteView extends StatefulWidget {
  const NoteView(this.user, this.topic, {Key? key}) : super(key: key);
  final User user;
  final Topic topic;

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  String getMathText(String? text) {
    if (text == null) return "";
    // text = parseHtmlString(text);
    print(text);
    text = text
        .replaceAll('\\(', "")
        .replaceAll('\\)', "")
        .replaceAll("\\\\", "\\");
    print(text);
    // text = text.replaceAll(" ", "︎⁠​​\u1160");
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            color: Color(0xFF009BCB),
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                Html(
                  data: getTex(widget.topic.notes),
                  style: {
                    // tables will have the below background color
                    "body": Style(
                      fontSize: FontSize(17),
                      color: Colors.white,
                      backgroundColor: Color(0xFF009BCB),
                      padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 25),
                    ),

                    'td': Style(
                        border: Border.all(color: Colors.white, width: 1)),
                    'th': Style(backgroundColor: Colors.blue),
                    'img': Style(
                        width: 200, height: 200, padding: EdgeInsets.all(10)),
                  },
                  customImageRenders: {
                    networkSourceMatcher(): (context, attributes, element) {
                      String? link = attributes['src'];
                      if (link != null) {
                        String name = link.substring(link.lastIndexOf("/") + 1);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          Course? course = await CourseDB()
                              .getCourseById(widget.topic.courseId!);

                          List<Question> questions = await TestController()
                              .getTopicQuestions([widget.topic.id!], limit: 10);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return QuizCover(
                              widget.user,
                              questions,
                              name: widget.topic.name!,
                              theme: QuizTheme.BLUE,
                              type: TestType.KNOWLEDGE,
                              category:
                                  TestCategory.TOPIC.toString().split(".")[1],
                              time: questions.length * 60,
                              course: course,
                            );
                          }));
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid)),
                        ),
                        child: Text(
                          "Take Test",
                          style: TextStyle(color: Colors.white),
                        )),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid)),
                        ),
                        child: Text(
                          "Finished",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
