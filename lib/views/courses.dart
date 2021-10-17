import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/course_analysis.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/course_info.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/providers/subscription_item_db.dart';
import 'package:ecoach/providers/test_taken_db.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/course_card.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 24.0,
      ),
      body: PageView(
        controller: controller,
        children: [
          for (int i = 0; i < subscriptions.length; i++)
            CourseView(
              widget.user,
              subscriptions[i],
            )
        ],
      ),
    );
  }
}

class CourseView extends StatefulWidget {
  CourseView(this.user, this.subscription, {Key? key}) : super(key: key);
  final User user;
  final Subscription subscription;

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
    return Column(
      children: [
        Text(
          subName,
          style: TextStyle(color: Colors.black),
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
                            child: CourseCard(widget.user,
                                courseInfo: CourseInfo(
                                  course: items[index],
                                  title: items[index]
                                      .name!
                                      .toUpperCase()
                                      .replaceFirst(subName.toUpperCase(), ""),
                                  background: kCourseColors[index %
                                      kCourseColors.length]['background'],
                                  icon: 'ict.png',
                                  progress: 51,
                                  progressColor: kCourseColors[
                                      index % kCourseColors.length]['progress'],
                                  rank: {
                                    'position': analytic != null
                                        ? analytic.userRank
                                        : 0,
                                    'numberOnRoll': analytic != null
                                        ? analytic.totalRank
                                        : 0,
                                  },
                                  tests: {
                                    'testsTaken': 132,
                                    'totalNumberOfTests': 3254,
                                  },
                                  totalPoints: analytic != null
                                      ? analytic.coursePoint!
                                      : 0,
                                  times: analytic != null
                                      ? analytic.usedSpeed!
                                      : 0,
                                  totalTimes: analytic != null
                                      ? analytic.totalSpeed!
                                      : 0,
                                )),
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
                            child: Text(
                                widget.user.email ?? "Something isn't right")),
                        SizedBox(height: 100),
                      ],
                    );
              }
            }),
      ],
    );
  }
}
