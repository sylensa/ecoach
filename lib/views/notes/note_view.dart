import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/quiz/quiz_cover.dart';
import 'package:ecoach/views/quiz/quiz_page.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class NoteView extends StatefulWidget {
  const NoteView(this.user, this.topic, {Key? key}) : super(key: key);
  final User user;
  final Topic topic;

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
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
                  shrinkWrap: true,
                  data: setTexTags(widget.topic.notes),
                  style: {
                    // tables will have the below background color
                    "body": Style(
                      fontSize: FontSize(17),
                      color: Colors.white,
                      backgroundColor: Color(0xFF009BCB),
                      padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 25),
                    ),
                    'td': Style(
                        textAlign: TextAlign.center,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4),
                        border: Border.all(color: Colors.white, width: 1)),
                    'th': Style(backgroundColor: Colors.blue),
                    'img': Style(
                        width: imageWidth,
                        height: imageHeight,
                        padding: EdgeInsets.all(0)),
                  },
                  customRenders: {
                    tableMatcher():
                        CustomRender.widget(widget: (context, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        // this calls the table CustomRender to render a table as normal (it uses a widget so we know widget is not null)
                        child: tableRender().widget!.call(context, child),
                      );
                    }),
                    networkSourceMatcher():
                        CustomRender.widget(widget: (context, element) {
                      String? link = context.tree.element!.attributes['src'];
                      if (link != null) {
                        String name = link.substring(link.lastIndexOf("/") + 1);
                        print("Image: $name");

                        var fileImage = FileImage(
                          widget.user.getImageFile(name),
                        );
                        return Image(image: fileImage);
                      }
                      return Text("No link");
                    }),
                    texMatcher(): CustomRender.widget(
                        widget: (RenderContext context, child) {
                      return Math.tex(
                        context.tree.element!.text,
                        textStyle: TextStyle(
                          fontSize: 16,
                        ),
                      );
                    }),
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
                              category: TestCategory.TOPIC,
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
