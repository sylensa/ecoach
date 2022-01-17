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

getSubscriptionSubName(String name) {
  return name.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();
}

class CoursesPage extends StatefulWidget {
  static const String routeName = '/courses';
  CoursesPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late int page;
  late PageController controller;
  List<Subscription> subscriptions = [];

  @override
  void initState() {
    page = 0;
    controller = PageController();
    var futureSubs = SubscriptionDB().subscriptions();
    futureSubs.then((List<Subscription> subscriptions) {
      if (subscriptions.length > 0) {
        setState(() {
          this.subscriptions = subscriptions;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  goToPreviousPage() {
    setState(() {
      page -= 1;
      controller.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  goToFirstPage() {
    setState(() {
      page = 0;
      controller.animateToPage(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  goToLastPage() {
    setState(() {
      page = subscriptions.length - 1;
      controller.animateToPage(
        subscriptions.length - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  goToNextPage() {
    setState(() {
      page += 1;
      controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBackgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              // height: 120,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: Feedback.wrapForTap(() {
                        if (page == 0)
                          goToLastPage();
                        else
                          goToPreviousPage();
                      }, context),
                      child: Container(
                        width: 44.0,
                        height: 32.0,
                        child: Image.asset(
                          'assets/icons/arrows/chevron_left.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      subscriptions.length > 0
                          ? getSubscriptionSubName(subscriptions[page].name!)
                          : 'Loading...',
                      textAlign: TextAlign.center,
                      style: kPageHeaderStyle,
                    ),
                    GestureDetector(
                      onTap: Feedback.wrapForTap(() {
                        if (page == subscriptions.length - 1)
                          goToFirstPage();
                        else
                          goToNextPage();
                      }, context),
                      child: Container(
                        width: 44.0,
                        height: 32.0,
                        child: Image.asset(
                          'assets/icons/arrows/chevron_right.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (dragEndDetails) {
                  // left to right
                  if (dragEndDetails.primaryVelocity! > 0) {
                    if (page == 0)
                      goToLastPage();
                    else
                      goToPreviousPage();
                  }
                  // right to left
                  else if (dragEndDetails.primaryVelocity! < 0) {
                    if (page == subscriptions.length - 1)
                      goToFirstPage();
                    else
                      goToNextPage();
                  }
                },
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: subscriptions
                      .map(
                        (subscription) => CourseView(
                          widget.user,
                          subscription,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
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
  );

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
    subName = widget.subscription.name!;
    subName =
        subName.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();
    futureItems =
        SubscriptionItemDB().subscriptionCourses(widget.subscription.planId!);
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
              List<Course> items = snapshot.data! as List<Course>;
              return ListView.builder(
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
                        title: items[index]
                            .name!
                            .replaceFirst(
                              subName,
                              "",
                            )
                            .replaceFirst(subName.toUpperCase(), ""),
                        subTitle: 'Take a random test across topics',
                        progress: 51,
                      ),
                    ),
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
                    child: Text(widget.user.email ?? "Something isn't right"),
                  ),
                  SizedBox(height: 100),
                ],
              );
        }
      },
    );
  }
}
