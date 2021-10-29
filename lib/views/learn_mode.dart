import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

enum Selection {
  REVISION,
  COURSE_COMPLETION,
  SPEED_ENHANCEMENT,
  MASTERY_IMPROVEMENT,
  NONE
}

class LearnMode extends StatefulWidget {
  const LearnMode(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _LearnModeState createState() => _LearnModeState();
}

class _LearnModeState extends State<LearnMode> {
  Selection selection = Selection.NONE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          color: Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'exit',
                        style:
                            TextStyle(color: Color(0xFFFB7B76), fontSize: 11),
                      )),
                  SizedBox(
                    width: 30,
                  )
                ],
              ),
              Text(
                "Welcome to the Learn Mode",
                style: TextStyle(color: Color(0xFFACACAC), fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "What is your current goal ?",
                style: TextStyle(
                    color: Color(0xFFD3D3D3),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 20,
              ),
              IntrinsicHeight(
                child: Column(
                  children: [
                    getSelectButton(
                        Selection.REVISION, "Revision", Color(0xFF00C664)),
                    getSelectButton(Selection.COURSE_COMPLETION,
                        "Course Completion", Color(0xFF00ABE0)),
                    getSelectButton(Selection.SPEED_ENHANCEMENT,
                        "Speed Enhancement", Color(0xFFFB7B76)),
                    getSelectButton(Selection.MASTERY_IMPROVEMENT,
                        "Mastery Improvement", Color(0xFFFFB444)),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              if (selection != Selection.NONE)
                SizedBox(
                    width: 150,
                    height: 44,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              getButtonColor(selection)),
                          side: MaterialStateProperty.all(BorderSide(
                              color: getButtonColor(selection),
                              width: 1,
                              style: BorderStyle.solid)),
                        ),
                        onPressed: () {
                          Widget? widget = null;
                          switch (selection) {
                            case Selection.REVISION:
                              // TODO: Handle this case.
                              break;
                            case Selection.COURSE_COMPLETION:
                              // TODO: Handle this case.
                              break;
                            case Selection.SPEED_ENHANCEMENT:
                              // TODO: Handle this case.
                              break;
                            case Selection.MASTERY_IMPROVEMENT:
                              // TODO: Handle this case.
                              break;
                            case Selection.NONE:
                              // TODO: Handle this case.
                              break;
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return widget!;
                          }));
                        },
                        child: Text(
                          "Let's go",
                        ))),
            ],
          ),
        ),
      ),
    );
  }

  Color getButtonColor(Selection selected) {
    Color? color;
    switch (selected) {
      case Selection.REVISION:
        color = Color(0xFF00C664);
        break;
      case Selection.COURSE_COMPLETION:
        color = Color(0xFF00ABE0);
        break;
      case Selection.SPEED_ENHANCEMENT:
        color = Color(0xFFFB7B76);
        break;
      case Selection.MASTERY_IMPROVEMENT:
        color = Color(0xFFFFB444);
        break;
      case Selection.NONE:
        break;
    }

    return color!;
  }

  Widget getSelectButton(
    Selection selected,
    String selectionText,
    Color selectedColor,
  ) {
    return Expanded(
        child: TextButton(
            style: ButtonStyle(
                fixedSize: selection == selected
                    ? MaterialStateProperty.all(Size(310, 102))
                    : MaterialStateProperty.all(Size(267, 88)),
                backgroundColor: MaterialStateProperty.all(
                    selection == selected ? selectedColor : Color(0xFFFAFAFA)),
                foregroundColor: MaterialStateProperty.all(
                    selection == selected ? Colors.white : Color(0xFFBEC7DB))),
            onPressed: () {
              setState(() {
                selection = selected;
              });
            },
            child: Text(
              selectionText,
              style: TextStyle(fontSize: selection == selected ? 25 : 20),
            )));
  }
}
