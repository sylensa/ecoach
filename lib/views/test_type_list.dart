import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TestTypeListView extends StatefulWidget {
  const TestTypeListView(this.user, this.quizzes, {Key? key}) : super(key: key);

  final User user;
  final List<TestNameAndCount> quizzes;

  @override
  _MockListViewState createState() => _MockListViewState();
}

class _MockListViewState extends State<TestTypeListView> {
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Container(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select Your Test",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: Divider(
                    thickness: 2,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.quizzes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 14.0, 0, 14),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () {},
                              child: LinearPercentIndicator(
                                width: 270.0,
                                lineHeight: 49,
                                animation: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                percent: widget.quizzes[index].progress,
                                backgroundColor: Colors.white,
                                progressColor: Color(0xFFE5E5E5),
                                linearStrokeCap: LinearStrokeCap.butt,
                                center: Row(
                                  children: [
                                    SizedBox(
                                      width: 270,
                                      height: 49,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              widget.quizzes[index].name,
                                              style: TextStyle(
                                                  color: Color(0xFF5D5D5D),
                                                  fontSize: 17),
                                            ),
                                          ),
                                          Positioned(
                                            right: -20,
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ]),
            )));
  }
}
