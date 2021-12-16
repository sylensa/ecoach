import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/course_analysis.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/ui/course_info.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/course_card.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/models/user.dart';
// import 'package:ecoach/controllers/test_controller.dart';
// import 'package:ecoach/models/subscription_item.dart';
// import 'package:ecoach/database/course_db.dart';
// import 'package:ecoach/database/test_taken_db.dart';
// import 'package:ecoach/utils/style_sheet.dart';
// import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';

class CoursesPage extends StatefulWidget {
  static const String routeName = '/courses';
  CoursesPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late final PageController controller;
  List<Subscription> subscriptions = [];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    var futureSubs = SubscriptionDB().subscriptions();
    futureSubs.then((List<Subscription> subscriptions) {
      if (subscriptions.length > 0) {
        setState(() {
          this.subscriptions = subscriptions;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            for (int i = 0; i < subscriptions.length; i++)
              CourseView(
                widget.user,
                subscriptions[i],
                i,
                subscriptions.length,
                () {
                  setState(() {
                    this.controller.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                  });
                },
                () {
                  setState(() {
                    this.controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                  });
                },
              )
          ],
        ),
      ),
    );
  }
}

class CourseView extends StatefulWidget {
  CourseView(
    this.user,
    this.subscription,
    this.currentSubscriptionIndex,
    this.subscriptionLength,
    this.goToPrevious,
    this.goToNext,
  );

  final User user;
  final Subscription subscription;
  final int currentSubscriptionIndex;
  final int subscriptionLength;
  final goToPrevious;
  final goToNext;

  @override
  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  List<Course> courses = [];
  Future<List<Course>>? futureItems;
  String subName = ""; //FIXME temp;

  @override
  void initState() {
    super.initState();
    print("course view");
    subName = widget.subscription.name!;
    subName =
        subName.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();
    print(subName);
    futureItems =
        SubscriptionItemDB().subscriptionCourses(widget.subscription.planId!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 120,
            child: Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.currentSubscriptionIndex > 0)
                    GestureDetector(
                      onTap: widget.goToPrevious,
                      child: Container(
                        width: 44.0,
                        height: 32.0,
                        child: Image.asset(
                          'assets/icons/arrows/chevron_left.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 44.0,
                      height: 32.0,
                    ),
                  Text(
                    subName,
                    style: kPageHeaderStyle,
                  ),
                  if (widget.currentSubscriptionIndex <
                      widget.subscriptionLength - 1)
                    GestureDetector(
                      onTap: widget.goToNext,
                      child: Container(
                        width: 44.0,
                        height: 32.0,
                        child: Image.asset(
                          'assets/icons/arrows/chevron_right.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 44.0,
                      height: 32.0,
                    ),
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: futureItems,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Container();
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data != null) {
                      List<Course> items = snapshot.data! as List<Course>;

                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            CourseAnalytic? analytic = items[index].analytic;
                            return Padding(
                              padding: EdgeInsets.only(left: 24.0, right: 24.0),
                              child: CourseCard(
                                widget.user,
                                courseInfo: CourseInfo(
                                  course: items[index],
                                  title: items[index].name!.replaceFirst(
                                        subName,
                                        "",
                                      ),
                                  subTitle: 'Take  a random test across topics',
                                  progress: 51,
                                ),
                              ),
                              //   child: CourseCard(widget.user,
                              //       courseInfo: CourseInfo(
                              //         course: items[index],
                              //         title: items[index]
                              //             .name!
                              //             .toUpperCase()
                              //             .replaceFirst(
                              //                 subName.toUpperCase(), ""),
                              //         background: kCourseColors[index %
                              //             kCourseColors.length]['background'],
                              //         icon: 'ict.png',
                              //         progress: 51,
                              //         progressColor: kCourseColors[index %
                              //             kCourseColors.length]['progress'],
                              //         rank: {
                              //           'position': analytic != null
                              //               ? analytic.userRank
                              //               : 0,
                              //           'numberOnRoll': analytic != null
                              //               ? analytic.totalRank
                              //               : 0,
                              //         },
                              //         tests: {
                              //           'testsTaken': 132,
                              //           'totalNumberOfTests': 3254,
                              //         },
                              //         totalPoints: analytic != null
                              //             ? analytic.coursePoint!
                              //             : 0,
                              //         times: analytic != null
                              //             ? analytic.usedSpeed!
                              //             : 0,
                              //         totalTimes: analytic != null
                              //             ? analytic.totalSpeed!
                              //             : 0,
                              //       )),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.data == null)
                      return Container();
                    else
                      return Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Center(
                              child: Text(widget.user.email ??
                                  "Something isn't right")),
                          SizedBox(height: 100),
                        ],
                      );
                }
              }),
        ],
      ),
    );
  }
}
