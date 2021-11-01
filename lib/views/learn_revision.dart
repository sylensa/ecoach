import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learning_widget.dart';
import 'package:flutter/material.dart';

class LearnRevision extends StatefulWidget {
  const LearnRevision(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnRevisionState createState() => _LearnRevisionState();
}

class _LearnRevisionState extends State<LearnRevision> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    "return",
                    style: TextStyle(color: Color(0xFF9C9C9C)),
                  )),
              SizedBox(
                width: 50,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Revision Mode",
            style: TextStyle(
                color: Color(0xFF00C664),
                fontSize: 29,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 232,
            child: Text(
              "We will take you through a series of questions. Whilst we do that we will help you revise topics you seem to struggle with.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFA39A9A)),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Image(
            image: AssetImage('assets/images/learning_revision.png'),
            width: 282,
            height: 282,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LearningWidget(widget.user, widget.course);
                }));
              },
              child: Text("Enter"),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(Size(150, 44)),
                foregroundColor: MaterialStateProperty.all(Color(0xFF00C664)),
                side: MaterialStateProperty.all(BorderSide(
                    color: Color(0xFF00C664),
                    width: 1,
                    style: BorderStyle.solid)),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
