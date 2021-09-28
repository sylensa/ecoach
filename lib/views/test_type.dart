import 'package:ecoach/controllers/questions_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/mock_list.dart';
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
              fixedSize: MaterialStateProperty.all(Size(130, 154)),
              backgroundColor: MaterialStateProperty.all(Colors.white)),
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

      futureList.then((apiResponse) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MockListView(widget.user, apiResponse.data);
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
                              Navigator.pop(context);
                            }),
                            getTestCatButton("Exam", () {
                              testCategory = TestCategory.EXAM;
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                        Column(
                          children: [
                            getTestCatButton("Topic", () {
                              testCategory = TestCategory.TOPIC;
                              Navigator.pop(context);
                            }),
                            getTestCatButton("Essay", () {
                              testCategory = TestCategory.ESSAY;
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                        Column(
                          children: [
                            getTestCatButton("Saved", () {
                              testCategory = TestCategory.SAVED;
                              Navigator.pop(context);
                            }),
                            getTestCatButton("Bank", () {
                              testCategory = TestCategory.BANK;
                              Navigator.pop(context);
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
        }).then((value) {
      getTest();
    });
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
