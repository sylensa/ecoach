import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/keyword/keyword_quiz_cover.dart';
import 'package:flutter/material.dart';

class TestInstruction extends StatefulWidget {
  TestInstruction({
    Key? key,
    required this.topic,
    this.questionCount = 0,
  }) : super(key: key);
  final TestNameAndCount topic;
  int questionCount = 0;

  @override
  State<TestInstruction> createState() => _TestInstructionState();
}

class _TestInstructionState extends State<TestInstruction> {
  List numberQuestions = [
    05,
  ];
  List selectNumberQuestions = [];
  int _currentPage = 0;
  PageController pageControllerView = PageController();

  calculateQuestionsCount() async {
    if (widget.questionCount > 5) {
      if (numberQuestions[numberQuestions.length - 1] < widget.questionCount) {
        if ((numberQuestions[numberQuestions.length - 1] * 2) <
            widget.questionCount) {
          numberQuestions.add(numberQuestions[numberQuestions.length - 1] * 2);
        } else {
          numberQuestions.add(widget.questionCount);
        }
        setState(() {});
        await calculateQuestionsCount();
      }
    } else {
      numberQuestions.clear();
      numberQuestions.add(widget.questionCount);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateQuestionsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: sText("Assessment",
            color: Colors.black, size: 20, weight: FontWeight.bold),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            if (widget.questionCount != 0)
              Container(
                height: 68,
                // width: appWidth(context),
                child: Center(
                  child: ListView.builder(
                      itemCount: numberQuestions.length,
                      controller: pageControllerView,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (index >= _currentPage) {
                                pageControllerView.animateTo(
                                    appWidth(context) / 10,
                                    duration: new Duration(microseconds: 1),
                                    curve: Curves.easeIn);
                              } else {
                                pageControllerView.jumpTo(0.0);
                              }
                              setState(() {
                                _currentPage = index;
                                selectNumberQuestions.clear();
                                selectNumberQuestions
                                    .add(numberQuestions[index]);
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(14),
                            margin: EdgeInsets.all(5),
                            constraints: BoxConstraints(minWidth: 60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                sText(numberQuestions[index].toString(),
                                    size: selectNumberQuestions
                                            .contains(numberQuestions[index])
                                        ? 30
                                        : 25,
                                    align: TextAlign.center,
                                    color: selectNumberQuestions
                                            .contains(numberQuestions[index])
                                        ? Colors.white
                                        : Colors.grey[400]!,
                                    weight: FontWeight.w600),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: selectNumberQuestions
                                      .contains(numberQuestions[index])
                                  ? kAdeoGreen4
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(
                                  selectNumberQuestions
                                          .contains(numberQuestions[index])
                                      ? 10
                                      : 0),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      sText("Test Instructions", color: kAdeoGray3),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0XFF00C9B9), width: 2),
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kAdeoGray3),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: appWidth(context) * 0.70,
                                    child: sText(
                                        "Take a 10 question test on a topic",
                                        size: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kAdeoGray3),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: appWidth(context) * 0.70,
                                    child: sText(
                                        "Score 7 or Higher to progress to the next topic",
                                        size: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kAdeoGray3),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: appWidth(context) * 0.70,
                                    child: sText(
                                        "A score of less than 7 will open up the topic notes for revision",
                                        size: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kAdeoGray3),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: appWidth(context) * 0.70,
                                    child: sText(
                                        "Progress is saved all the time so you can continue where ever you left off",
                                        size: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kAdeoGray3),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: appWidth(context) * 0.72,
                                    child: sText(
                                        "Start a new revision round whenever you want to",
                                        size: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  MaterialButton(
                                    onPressed: () {
                                      if (widget.questionCount != 0) {
                                        // goTo(context, widget.quizCover,
                                        //     replace: true);
                                      } else {
                                        toastMessage(
                                            "No questions available for ${properCase(widget.topic.name)} keyword");
                                      }
                                    },
                                    padding: EdgeInsets.zero,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child:
                                          sText("Start", color: Colors.white),
                                      decoration: BoxDecoration(
                                          color: Color(0XFF00C9B9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
