import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/course_info.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/subscription_db.dart';
import 'package:ecoach/providers/subscription_item_db.dart';
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
        physics: NeverScrollableScrollPhysics(),
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
  Future<List<SubscriptionItem>>? futureItems;
  String subName = ""; //FIXME temp;

  @override
  void initState() {
    super.initState();
    subName = widget.subscription.name!;
    subName = subName.replaceFirst("Bundle", "").trim();
    print(subName);
    futureItems =
        SubscriptionItemDB().subscriptionItems(widget.subscription.planId!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                List<SubscriptionItem> items =
                    snapshot.data! as List<SubscriptionItem>;

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    if (items[index].course == null) return Container();
                    return Padding(
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CourseCard(widget.user,
                          courseInfo: CourseInfo(
                            course: items[index].course!,
                            title: items[index].name!.replaceFirst(subName, ""),
                            background:
                                kCourseColors[index % kCourseColors.length]
                                    ['background'],
                            icon: 'ict.png',
                            progress: 51,
                            progressColor:
                                kCourseColors[index % kCourseColors.length]
                                    ['progress'],
                            rank: {
                              'position': 12,
                              'numberOnRoll': 305,
                            },
                            tests: {
                              'testsTaken': 132,
                              'totalNumberOfTests': 3254,
                            },
                            totalPoints: 1895,
                            times: 697,
                          )),
                    );
                  },
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
                        child:
                            Text(widget.user.email ?? "Something isn't right")),
                    SizedBox(height: 100),
                  ],
                );
          }
        });
  }
}
