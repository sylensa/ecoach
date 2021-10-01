import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/test_type_list.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

enum TestType { SPEED, KNOWLEDGE, UNTIMED, CUSTOMIZED, NONE }
enum TestCategory { MOCK, EXAM, TOPIC, ESSAY, SAVED, BANK, NONE }

class TestTypeView extends StatefulWidget {
  TestTypeView(this.user, this.course, {Key? key}) : super(key: key);
  User user;
  Course course;

  @override
  _TestTypeViewState createState() => _TestTypeViewState();
}

class _TestTypeViewState extends State<TestTypeView> {
  TestType testType = TestType.NONE;
  TestCategory testCategory = TestCategory.NONE;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFFF6F6F6),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Choose your test type",
                    style: TextStyle(color: Colors.black38),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                color: Colors.black38,
              ),
              SizedBox(
                height: 40,
              ),
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: [
                  getTypeButton(
                      AssetImage("assets/images/speedometer.png"), "Speed", () {
                    showTestCat(TestType.SPEED);
                  }),
                  getTypeButton(
                      AssetImage("assets/images/brain.png"), "Knowledge", () {
                    showTestCat(TestType.KNOWLEDGE);
                  }),
                  getTypeButton(
                      AssetImage("assets/images/infinite.png"), "Untimed", () {
                    showTestCat(TestType.UNTIMED);
                  }),
                  getTypeButton(
                      AssetImage("assets/images/customize.png"), "Customized",
                      () {
                    showTestCat(TestType.CUSTOMIZED);
                  }),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('View Analysis'),
                          ))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getTypeButton(ImageProvider image, String name, Function()? callback) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 12),
      child: OutlinedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(134, 157)),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
          onPressed: callback != null ? callback : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: image,
              ),
              Text(name),
            ],
          )),
    );
  }

  showTestCat(TestType testType) {
    getTest() {
      Future futureList;
      switch (testCategory) {
        case TestCategory.MOCK:
          futureList = TestController().getMockTests(widget.course);
          break;
        case TestCategory.EXAM:
          futureList = TestController().getExamTests(widget.course);
          break;
        case TestCategory.TOPIC:
          futureList = TestController().getTopics(widget.course);
          break;
        case TestCategory.ESSAY:
          futureList = TestController().getEssays(widget.course);
          break;
        case TestCategory.SAVED:
          futureList = TestController().getSavedTests(widget.course);
          break;
        case TestCategory.BANK:
          futureList = TestController().getBankTest(widget.course);
          break;
        default:
          futureList = TestController().getBankTest(widget.course);
      }

      futureList.then((data) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          Widget? widgetView;
          print("selecting test");
          print(testCategory);
          switch (testCategory) {
            case TestCategory.MOCK:
              widgetView = TestTypeListView(
                widget.user,
                widget.course,
                data,
                title: "Mock Test",
              );
              break;
            case TestCategory.EXAM:
              widgetView = TestTypeListView(
                widget.user,
                widget.course,
                data,
                title: "Exams",
              );
              break;
            case TestCategory.TOPIC:
              widgetView = TestTypeListView(
                widget.user,
                widget.course,
                data,
                title: "Topic",
                multiSelect: true,
              );
              break;
            case TestCategory.ESSAY:
              widgetView = TestTypeListView(
                widget.user,
                widget.course,
                data,
                title: "Essay",
              );
              break;
            case TestCategory.SAVED:
              List<Question> questions = data as List<Question>;
              widgetView = QuizCover(
                widget.user,
                data,
                name: "Saved Test",
              );
              break;
            case TestCategory.BANK:
              widgetView = TestTypeListView(widget.user, widget.course, data,
                  title: "Bank");
              break;
            default:
              widgetView = null;
          }
          return widgetView!;
        }));
      });
    }

    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: GestureDetector(
                child: Icon(Icons.arrow_back_ios),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: Color(0xFFF6F6F6),
            body: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Choose your test type",
                          style: TextStyle(color: Colors.black38),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.black38,
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            getTestCatButton("Mock", () {
                              testCategory = TestCategory.MOCK;
                              getTest();
                            }),
                            getTestCatButton("Exam", () {
                              testCategory = TestCategory.EXAM;
                              getTest();
                            }),
                          ],
                        ),
                        Column(
                          children: [
                            getTestCatButton("Topic", () {
                              testCategory = TestCategory.TOPIC;
                              getTest();
                            }),
                            getTestCatButton("Essay", () {
                              testCategory = TestCategory.ESSAY;
                              getTest();
                            }),
                          ],
                        ),
                        Column(
                          children: [
                            getTestCatButton("Saved", () {
                              testCategory = TestCategory.SAVED;

                              getTest();
                            }),
                            getTestCatButton("Bank", () {
                              testCategory = TestCategory.BANK;

                              getTest();
                            }),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('View Analysis'),
                                ))),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }).then((value) {});
  }

  getTestCatButton(String name, Function()? callback) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 12),
      child: OutlinedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(100, 132)),
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: callback != null ? callback : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(color: Colors.black38),
              ),
            ],
          )),
    );
  }
}

class TestNameAndCount {
  String name;
  int? id;
  int count;
  int totalCount;
  TestCategory? category;

  TestNameAndCount(this.name, this.count, this.totalCount,
      {this.id, this.category});

  double get progress {
    return count / totalCount;
  }
}
