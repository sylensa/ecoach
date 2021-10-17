import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/quiz_cover.dart';
import 'package:ecoach/views/test_type.dart';
import 'package:ecoach/views/test_type_list.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:ecoach/widgets/pin_input.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Customize extends StatefulWidget {
  const Customize(this.user, this.course, {Key? key}) : super(key: key);
  final User user;
  final Course course;

  @override
  _CustomizeState createState() => _CustomizeState();
}

class _CustomizeState extends State<Customize> {
  double containerHeight = 480.0;
  final CarouselController controller = CarouselController();
  int currentSliderIndex = 0;
  String numberOfQuestions = '';
  String duration = '';
  TestCategory testCategory = TestCategory.NONE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoTaupe,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20.0),
              Container(
                height: containerHeight,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      left: -36.0,
                      right: -36.0,
                      child: Container(
                        height: containerHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/deep_pool_orange_accent.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: containerHeight,
                      child: CarouselSlider(
                        items: [
                          CarouselItem(
                            label: 'Questions',
                            onChanged: (v) {
                              setState(() {
                                numberOfQuestions = v.split('').join('');
                              });
                              print(numberOfQuestions);
                            },
                          ),
                          CarouselItem(
                            isDuration: true,
                            shouldFocus: currentSliderIndex == 1,
                            label: 'Time',
                            onChanged: (v) {
                              setState(() {
                                duration = v.split('').join('');
                              });
                              print(duration);
                            },
                          )
                        ],
                        carouselController: controller,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentSliderIndex = index;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 44.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentSliderIndex == 1)
                          Row(
                            children: [
                              AdeoOutlinedButton(
                                label: 'Previous',
                                onPressed: () {
                                  controller.previousPage();
                                },
                              ),
                              SizedBox(width: 8.0)
                            ],
                          ),
                        AdeoOutlinedButton(
                          ignoring: currentSliderIndex == 0
                              ? numberOfQuestions.length == 0
                              : duration.length == 0,
                          label: 'Next',
                          onPressed: () {
                            if (currentSliderIndex == 0)
                              controller.nextPage();
                            else {
                              print(duration);
                              if (duration.split(":").length != 2) return;

                              showTestCat(TestType.CUSTOMIZED);
                              // TestController()
                              //     .getCustomizedQuestions(widget.course,
                              //         int.parse(numberOfQuestions))
                              //     .then((questions) {
                              //   Navigator.push(context,
                              //       MaterialPageRoute(builder: (context) {
                              //     return QuizCover(
                              //       widget.user,
                              //       questions,
                              //       course: widget.course,
                              //       type: TestType.CUSTOMIZED,
                              //       category: "Customized",
                              //       time: Duration(
                              //               minutes: int.parse(
                              //                   duration.split(":")[0]),
                              //               seconds: int.parse(
                              //                   duration.split(":")[1]))
                              //           .inSeconds,
                              //       name: "Customize",
                              //     );
                              //   }));
                              // });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 56.0),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showTestCat(TestType testType) {
    Duration timeDuration = Duration(
        minutes: int.parse(duration.split(":")[0]),
        seconds: int.parse(duration.split(":")[1]));

    getTest() {
      Future futureList;
      switch (testCategory) {
        case TestCategory.MOCK:
          futureList = TestController()
              .getMockTests(widget.course, limit: int.parse(numberOfQuestions));
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

          switch (testCategory) {
            case TestCategory.MOCK:
              List<Question> questions = data as List<Question>;
              widgetView = QuizCover(
                widget.user,
                questions,
                course: widget.course,
                type: testType,
                category: testCategory.toString().split(".")[1],
                time: timeDuration.inSeconds,
                name: "Mock Test",
              );
              break;

            case TestCategory.TOPIC:
              widgetView = TestTypeListView(
                  widget.user, widget.course, data, testType,
                  title: "Topic",
                  multiSelect: true,
                  questionLimit: int.parse(numberOfQuestions),
                  time: timeDuration.inSeconds);
              break;
            case TestCategory.ESSAY:
              widgetView = TestTypeListView(
                  widget.user, widget.course, data, testType,
                  title: "Essay",
                  questionLimit: int.parse(numberOfQuestions),
                  time: timeDuration.inSeconds);
              break;
            case TestCategory.SAVED:
              List<Question> questions = data as List<Question>;
              widgetView = QuizCover(
                widget.user,
                questions,
                category: testCategory.toString().split(".")[1],
                course: widget.course,
                time: timeDuration.inSeconds,
                name: "Saved Test",
              );
              break;
            case TestCategory.BANK:
              widgetView = TestTypeListView(
                  widget.user, widget.course, data, testType,
                  title: "Bank",
                  questionLimit: int.parse(numberOfQuestions),
                  time: timeDuration.inSeconds);
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

class CarouselItem extends StatefulWidget {
  final String label;
  final onChanged;
  final bool isDuration;
  final bool shouldFocus;

  CarouselItem({
    required this.label,
    this.onChanged,
    this.isDuration = false,
    this.shouldFocus = false,
  });

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  String leftText = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: kDefaultBlack,
                fontSize: 44.0,
              ),
            ),
            Text(
              'Enter your preferred number',
              style: TextStyle(
                color: kDefaultBlack,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: widget.isDuration ? 120.0 : 180.0,
                    child: PinInput(
                      autoFocus: widget.isDuration && widget.shouldFocus,
                      length: widget.isDuration ? 2 : 3,
                      onChanged: widget.isDuration
                          ? (v) {
                              setState(() {
                                leftText = v;
                              });
                            }
                          : widget.onChanged,
                    ),
                  ),
                  if (widget.isDuration)
                    Row(
                      children: [
                        Text(':', style: kPinInputTextStyle),
                        Container(
                          width: 120.0,
                          child: PinInput(
                            autoFocus: leftText.length == 2,
                            length: 2,
                            onChanged: (v) {
                              widget.onChanged('$leftText:$v');
                            },
                          ),
                        )
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
