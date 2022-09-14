import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/course_analysis.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/ui/course_info.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/subscription_page.dart';
import 'package:ecoach/widgets/cards/course_card.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/models/user.dart';

getSubscriptionSubName(String name) {
  return name.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();
}

class CoursesPage extends StatefulWidget {
  static const String routeName = '/courses';
  CoursesPage(this.user, this.controller, {Key? key, this.planId = -1})
      : super(key: key);
  User user;
  int planId;
  final MainController controller;

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late int page;
  late PageController controller;
  List<Subscription> subscriptions = [];
  bool progressCode = true;
  getUserSubscriptions() async {
    Subscription? res =
        await SubscriptionDB().getSubscriptionByPlanId(widget.planId);
    if (res != null) {
      subscriptions.add(res);
      var futureSubs = SubscriptionDB().subscriptions();
      futureSubs.then((List<Subscription> subscriptions) {
        if (subscriptions.isNotEmpty) {
          for (int i = 0; i < subscriptions.length; i++) {
            if (subscriptions[i].id != res.id) {
              this.subscriptions.add(subscriptions[i]);
            }
          }
        }
        setState(() {
          progressCode = false;
        });
      });
    } else {
      var futureSubs = SubscriptionDB().subscriptions();
      futureSubs.then((List<Subscription> subscriptions) {
        if (subscriptions.isNotEmpty) {
          this.subscriptions = subscriptions;
        }
        setState(() {
          progressCode = false;
        });
      });
    }
  }

  @override
  void initState() {
    page = 0;
    controller = PageController();
    getUserSubscriptions();
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
                      subscriptions.isNotEmpty
                          ? getSubscriptionSubName(subscriptions[page].name!)
                          : subscriptions.isEmpty && progressCode
                              ? 'Loading...'
                              : "Bundles",
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
            subscriptions.isNotEmpty
                ? Expanded(
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
                                  widget.user, subscription, widget.controller),
                            )
                            .toList(),
                      ),
                    ),
                  )
                : subscriptions.isEmpty && progressCode
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: Container(
                            padding: EdgeInsets.all(20),
                            width: appWidth(context),
                            child: Center(
                                child: Text(
                              Platform.isAndroid
                                  ? "No Subscribed Bundles"
                                  : "No available courses",
                              textAlign: TextAlign.center,
                              style: kPageHeaderStyle,
                            ))))
          ],
        ),
      ),
    );
  }
}

class CourseView extends StatefulWidget {
  CourseView(this.user, this.subscription, this.controller);

  final User user;
  final Subscription subscription;
  final MainController controller;

  @override
  _CourseViewState createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  List<Course> courses = [];
  List<Course> futureItems = [];
  String subName = ""; //FIXME temp;
  bool progressCode = true;
  getSubscriptionCourse() async {
    futureItems = await SubscriptionItemDB()
        .subscriptionCourses(widget.subscription.planId!);
    if (futureItems.isEmpty) {
      ApiCall<Data>(AppUrl.new_user_data, isList: false,
              create: (Map<String, dynamic> json) {
        return Data.fromJson(json);
      }, onCallback: (data) async {
        if (data != null) {
          await LevelDB().insertAll(data!.levels!);
          await CourseDB().insertAll(data!.courses!);
          await getSubscriptionCourse();
        }
      }, onError: (e) {})
          .get(context);
    } else {
      if (mounted)
        setState(() {
          progressCode = false;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    getSubscriptionCourse();
    subName = widget.subscription.name!;
    subName =
        subName.replaceFirst("Bundle", "").replaceFirst("bundle", "").trim();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: futureItems,
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.none:
    //         return Container();
    //       case ConnectionState.waiting:
    //         return Center(
    //           child: CircularProgressIndicator(
    //             color: Colors.blue,
    //           ),
    //         );
    //       default:
    //         if (snapshot.hasError)
    //           return Text('Error: ${snapshot.error}');
    //         else if (snapshot.data != null) {
    //           List<Course> items = snapshot.data! as List<Course>;
    //           return ListView.builder(
    //             scrollDirection: Axis.vertical,
    //             shrinkWrap: true,
    //             itemCount: items.length,
    //             itemBuilder: (context, index) {
    //               CourseAnalytic? analytic = items[index].analytic;
    //               return Padding(
    //                 padding: EdgeInsets.only(left: 24.0, right: 24.0),
    //                 child: CourseCard(
    //                   widget.user,
    //                   courseInfo: CourseInfo(
    //                     course: items[index],
    //                     title: items[index].name!.replaceFirst(subName, "",).replaceFirst(subName.toUpperCase(), ""),
    //                     subTitle: 'Take a random test across topics',
    //                     progress: items[index].averageScore!,
    //                   ),
    //                 ),
    //               );
    //             },
    //           );
    //           // if(items.isNotEmpty){
    //           //   return ListView.builder(
    //           //     scrollDirection: Axis.vertical,
    //           //     shrinkWrap: true,
    //           //     itemCount: items.length,
    //           //     itemBuilder: (context, index) {
    //           //       CourseAnalytic? analytic = items[index].analytic;
    //           //       return Padding(
    //           //         padding: EdgeInsets.only(left: 24.0, right: 24.0),
    //           //         child: CourseCard(
    //           //           widget.user,
    //           //           courseInfo: CourseInfo(
    //           //             course: items[index],
    //           //             title: items[index].name!.replaceFirst(subName, "",).replaceFirst(subName.toUpperCase(), ""),
    //           //             subTitle: 'Take a random test across topics',
    //           //             progress: items[index].averageScore!,
    //           //           ),
    //           //         ),
    //           //       );
    //           //     },
    //           //   );
    //           // }else{
    //           //   return Center(
    //           //     child: GestureDetector(
    //           //       onTap: (){
    //           //         goTo(context, SubscriptionPage(widget.user, controller: widget.controller));
    //           //       },
    //           //       child: Container(
    //           //         child: sText("Tap to download course"),
    //           //       ),
    //           //     ),
    //           //   );
    //           // }
    //
    //         } else if (snapshot.data == null)
    //           return Container(
    //             child: sText("Empty"),
    //           );
    //         else
    //           return Column(
    //             children: [
    //               SizedBox(
    //                 height: 100,
    //               ),
    //               Center(
    //                 child: Text(widget.user.email ?? "Something isn't right"),
    //               ),
    //               SizedBox(height: 100),
    //             ],
    //           );
    //     }
    //   },
    // );
    return futureItems.isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: futureItems.length,
            itemBuilder: (context, index) {
              CourseAnalytic? analytic = futureItems[index].analytic;
              return Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: CourseCard(
                  widget.user,
                  courseInfo: CourseInfo(
                    course: futureItems[index],
                    title: futureItems[index]
                        .name!
                        .replaceFirst(
                          subName,
                          "",
                        )
                        .replaceFirst(subName.toUpperCase(), ""),
                    subTitle: 'Take a random test across topics',
                    progress: futureItems[index].averageScore!,
                  ),
                ),
              );
            },
          )
        : progressCode
            ? Center(
                child: sText("Loading courses"),
              )
            : Center(
                child: sText("Empty courses"),
              );
  }
}
