import 'dart:async';

import 'package:ecoach/controllers/questions_controller.dart';
import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/level_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WelcomeAdeo extends StatefulWidget {
  const WelcomeAdeo(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _WelcomeAdeoState createState() => _WelcomeAdeoState();
}

class _WelcomeAdeoState extends State<WelcomeAdeo> {
  var futureData;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      showLoaderDialog(context, message: "Loading initial data ...");
      getInitialData().then((data) {
        LevelDB().insertAll(data.data!.levels!);
        CourseDB().insertAll(data.data!.courses!);
        Navigator.pop(context);
      });
    });
  }

  Future<NewUserData> getInitialData() async {
    final response = await http.get(
      Uri.parse(AppUrl.new_user_data),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': widget.user.token!
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      return NewUserData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF00C664)),
        child: Stack(
          children: [
            Positioned(
                top: -100,
                right: -80,
                child: Image(
                  image: AssetImage('assets/images/white_leave.png'),
                )),
            Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainHomePage(widget.user);
                    }));
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(color: Color(0xFF00C664), fontSize: 24),
                  ),
                )),
            Positioned(
              top: 180,
              right: 40,
              left: 40,
              bottom: 100,
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'Welcome to the\nAdeo Experience',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "You currently have\n",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: "NO",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Poppins'),
                          ),
                          TextSpan(
                              text: " Subscriptions.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Poppins',
                              ))
                        ])),
                    SizedBox(
                      height: 40,
                    ),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                            text: "First take a",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                              text: " DIAGNOSTIC TEST\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Poppins',
                              )),
                          TextSpan(
                            text: "  to determine the right course for you.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ])),
                    SizedBox(
                      height: 60,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return SelectLevel(widget.user);
                        }), (route) => false);
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(60, 10, 60, 10)),
                        side: MaterialStateProperty.all(BorderSide(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectLevel extends StatefulWidget {
  const SelectLevel(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _SelectLevelState createState() => _SelectLevelState();
}

class _SelectLevelState extends State<SelectLevel> {
  var futureLevels;
  String? selectedLevel;

  @override
  void initState() {
    futureLevels = LevelDB().levelGroups();

    super.initState();
  }

  getLevels() async {
    print(widget.user.token!);
    http.Response response = await http.get(
      Uri.parse(AppUrl.levelGroups),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'api-token': widget.user.token!
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      if (responseData["status"] == true) {
        print("messages returned");
        print(response.body);

        return ApiResponse<String>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          return dataItem['group'];
        });
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF28BFDF)),
        child: Stack(children: [
          Positioned(
              top: -100,
              right: -80,
              child: Image(
                image: AssetImage('assets/images/white_leave.png'),
              )),
          Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainHomePage(widget.user);
                  }));
                },
                child: Text(
                  "Skip",
                  style: TextStyle(color: Color(0xFF00C664), fontSize: 24),
                ),
              )),
          Positioned(
            top: 100,
            right: -120,
            left: -100,
            bottom: 150,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/deep_pool.png'),
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Text(
                    "Select your level",
                    style: TextStyle(fontSize: 38),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                      future: futureLevels,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError)
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: 400,
                                    child: Text('Error: ${snapshot.error}')),
                              );
                            else if (snapshot.data != null) {
                              List<String> levels =
                                  snapshot.data as List<String>;
                              print(levels);
                              return Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: levels.length,
                                    itemBuilder: (context, index) {
                                      String name = levels[index];
                                      print(name);
                                      return selectText(
                                          name, levels[index] == selectedLevel,
                                          select: () {
                                        setState(() {
                                          selectedLevel = levels[index];
                                        });
                                      });
                                    }),
                              );
                            } else {
                              return Container();
                            }
                        }
                      }),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: Container(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                OutlinedButton(
                  onPressed: () {
                    if (selectedLevel == null) {
                      return;
                    }
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return SelectCourse(widget.user, selectedLevel!);
                    }), (route) => false);
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(60, 10, 60, 10)),
                    side: MaterialStateProperty.all(BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }
}

class SelectCourse extends StatefulWidget {
  const SelectCourse(this.user, this.levelGroup, {Key? key}) : super(key: key);
  final User user;
  final String levelGroup;

  @override
  _SelectCourseState createState() => _SelectCourseState();
}

class _SelectCourseState extends State<SelectCourse> {
  var futureLevels;
  var futureCourses;
  Level? selectedLevel;
  Course? selectedCourse;

  @override
  void initState() {
    futureLevels = LevelDB().levelByGroup(widget.levelGroup);
    LevelDB().levels().then((value) => print(value[0].category));
    super.initState();
  }

  getCourses() {
    return CourseDB().courses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFFF614E)),
        child: Stack(children: [
          Positioned(
              top: -100,
              right: -80,
              child: Image(
                image: AssetImage('assets/images/white_leave.png'),
              )),
          Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainHomePage(widget.user);
                  }));
                },
                child: Text(
                  "Skip",
                  style: TextStyle(color: Color(0xFF00C664), fontSize: 24),
                ),
              )),
          Positioned(
            top: 100,
            right: 0,
            left: 0,
            bottom: 150,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Select your class",
                    style: TextStyle(fontSize: 38, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/class_background.png'),
                      )),
                      child: Center(
                        child: FutureBuilder(
                            future: futureLevels,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                default:
                                  if (snapshot.hasError)
                                    return Padding(
                                      padding: const EdgeInsets.all(28.0),
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  else if (snapshot.data != null) {
                                    List<Level> levels =
                                        snapshot.data as List<Level>;
                                    return Flexible(
                                        child: Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int i = 0;
                                                  i < levels.length;
                                                  i++)
                                                selectText(
                                                    levels[i].name!.split(" ")[
                                                        levels[i]
                                                                .name!
                                                                .split(" ")
                                                                .length -
                                                            1],
                                                    levels[i] == selectedLevel,
                                                    normalSize: 25,
                                                    selectedSize: 30,
                                                    select: () {
                                                  setState(() {
                                                    selectedLevel = levels[i];
                                                  });
                                                  futureCourses = getCourses();
                                                }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ));
                                  } else {
                                    return Container();
                                  }
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: FutureBuilder(
                        future: futureCourses,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(child: Container());
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError)
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              else if (snapshot.data != null) {
                                List<Course> courses =
                                    snapshot.data as List<Course>;

                                return Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: courses.length,
                                      itemBuilder: (context, index) {
                                        return selectText(courses[index].name!,
                                            courses[index] == selectedCourse,
                                            normalSize: 25,
                                            selectedSize: 30, select: () {
                                          setState(() {
                                            selectedCourse = courses[index];
                                          });
                                        });
                                      }),
                                );
                              } else {
                                return Container();
                              }
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: Container(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                OutlinedButton(
                  onPressed: () {
                    if (selectedLevel == null || selectedCourse == null) {
                      return;
                    }
                    showLoaderDialog(context);
                    Future futureList = TestController()
                        .loadDiagnoticQuestion(selectedLevel!, selectedCourse!);

                    futureList.then((apiResponse) {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return QuizView(widget.user, apiResponse.data,
                            level: selectedLevel!, course: selectedCourse!);
                      }));
                    });
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(60, 10, 60, 10)),
                    side: MaterialStateProperty.all(BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
