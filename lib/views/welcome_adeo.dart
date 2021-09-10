import 'package:ecoach/controllers/questions_controller.dart';
import 'package:ecoach/models/api_response.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/subjects.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/quiz_page.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WelcomeAdeo extends StatefulWidget {
  const WelcomeAdeo(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _WelcomeAdeoState createState() => _WelcomeAdeoState();
}

class _WelcomeAdeoState extends State<WelcomeAdeo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return MainHomePage(widget.user);
                      }), (route) => false);
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
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "You currently have\n",
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                        TextSpan(
                            text: "NO",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24)),
                        TextSpan(
                            text: " Subscriptions.",
                            style: TextStyle(color: Colors.white, fontSize: 24))
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
                                    color: Colors.white, fontSize: 24)),
                            TextSpan(
                                text: " DIAGNOSTIC TEST\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 24)),
                            TextSpan(
                                text: "  to determine the right course\n",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                            TextSpan(
                                text: "  for you. ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24))
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
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
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
    futureLevels = getLevels();

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
    return SafeArea(
      child: Scaffold(
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
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return MainHomePage(widget.user);
                    }), (route) => false);
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
                                return Text('Error: ${snapshot.error}');
                              else if (snapshot.data != null) {
                                ApiResponse<String>? apiResponse =
                                    snapshot.data as ApiResponse<String>?;
                                List<String> levels = apiResponse!.data!;
                                return Flexible(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: levels.length,
                                      itemBuilder: (context, index) {
                                        String name = levels[index];
                                        print(name);
                                        return selectText(name,
                                            levels[index] == selectedLevel,
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
                        return SelectSubject(widget.user, selectedLevel!);
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
      ),
    );
  }
}

class SelectSubject extends StatefulWidget {
  const SelectSubject(this.user, this.levelGroup, {Key? key}) : super(key: key);
  final User user;
  final String levelGroup;

  @override
  _SelectSubjectState createState() => _SelectSubjectState();
}

class _SelectSubjectState extends State<SelectSubject> {
  var futureLevels;
  var futureSubjects;
  Level? selectedLevel;
  Subject? selectedSubject;

  @override
  void initState() {
    futureLevels = getLevels();

    super.initState();
  }

  getLevels() async {
    print(widget.user.token!);
    Map<String, String> queryParams = {'group': widget.levelGroup};
    http.Response response = await http.get(
      Uri.parse(AppUrl.levels + '?' + Uri(queryParameters: queryParams).query),
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

        return ApiResponse<Level>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          return Level.fromJson(dataItem);
        });
      } else {
        print("not successful event");
      }
    } else {
      print("Failed ....");
      print(response.statusCode);
    }
  }

  loadSubjects() async {
    print(widget.user.token!);
    Map<String, String> queryParams = {'level_id': "${selectedLevel!.id}"};
    http.Response response = await http.get(
      Uri.parse(
          AppUrl.subjects + '?' + Uri(queryParameters: queryParams).query),
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

        return ApiResponse<Subject>.fromJson(response.body, (dataItem) {
          print("it's fine here");
          return Subject.fromJson(dataItem);
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
    return SafeArea(
      child: Scaffold(
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
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return MainHomePage(widget.user);
                    }), (route) => false);
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
                          image:
                              AssetImage('assets/images/class_background.png'),
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
                                      return Text('Error: ${snapshot.error}');
                                    else if (snapshot.data != null) {
                                      ApiResponse<Level>? apiResponse =
                                          snapshot.data as ApiResponse<Level>?;
                                      List<Level> levels = apiResponse!.data!;
                                      return Flexible(
                                          child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            widget.levelGroup,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
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
                                                  futureSubjects =
                                                      loadSubjects();
                                                }),
                                            ],
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
                    Container(
                      child: FutureBuilder(
                          future: futureSubjects,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Center(child: Container());
                              case ConnectionState.waiting:
                                return Center(
                                    child: CircularProgressIndicator());
                              default:
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                                else if (snapshot.data != null) {
                                  ApiResponse<Subject>? apiResponse =
                                      snapshot.data as ApiResponse<Subject>?;
                                  List<Subject> subjects = apiResponse!.data!;
                                  return SingleChildScrollView(
                                    child: Flexible(
                                        child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            for (int i = 0;
                                                i < subjects.length;
                                                i++)
                                              selectText(
                                                  subjects[i].name.split(" ")[
                                                      subjects[i]
                                                              .name
                                                              .split(" ")
                                                              .length -
                                                          1],
                                                  subjects[i] ==
                                                      selectedSubject,
                                                  normalSize: 25,
                                                  selectedSize: 30, select: () {
                                                setState(() {
                                                  selectedSubject = subjects[i];
                                                });
                                              }),
                                          ],
                                        ),
                                      ],
                                    )),
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
                      if (selectedLevel == null || selectedSubject == null) {
                        return;
                      }
                      showLoaderDialog(context);
                      Future futureList = QuestionsController()
                          .loadDiagnoticQuestion(
                              selectedLevel!, selectedSubject!);

                      futureList.then((apiResponse) {
                        showLoaderDialog(context);
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return QuizView(widget.user, apiResponse.data,
                              level: selectedLevel!, subject: selectedSubject!);
                        }), (route) => false);
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
      ),
    );
  }
}
