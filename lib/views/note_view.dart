import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
                Html(data: widget.topic.notes, style: {
                  // tables will have the below background color
                  "body": Style(
                    fontSize: FontSize(17),
                    color: Colors.white,
                    backgroundColor: Color(0xFF009BCB),
                    padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 25),
                  ),

                  'td':
                      Style(border: Border.all(color: Colors.white, width: 1)),
                  'th': Style(backgroundColor: Colors.blue),
                  'img': Style(
                      width: 200, height: 200, padding: EdgeInsets.all(10)),
                }, customImageRenders: {
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
                }),
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
