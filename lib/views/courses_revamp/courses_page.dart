import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/database/subscription_db.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/payment/views/screens/buy_bundle.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses_revamp/course_details_page.dart';
import 'package:ecoach/views/courses_revamp/no_susbcription.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoursesPage extends StatefulWidget {
  static const String routeName = '/courses';
  CoursesPage(this.user, this.controller, {Key? key, this.planId = -1})
      : super(key: key);
  User user;
  int planId;
  final MainController controller;

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool progressCode = true;
  List<Subscription> selectedSubscription = [];
  getUserSubscriptionsFromOnline() async {
    context.read<DownloadUpdate>().plans =
        await widget.controller.makeSubscriptionsCall();
    if (context.read<DownloadUpdate>().plans.isEmpty) {
      await goTo(
          context,
          NoSubscriptionsPage(
            controller: widget.controller,
            user: widget.user,
          ));
    }
    if (mounted)
      setState(() {
        progressCode = false;
      });
  }

  getUserSubscriptions() async {
    context.read<DownloadUpdate>().plans =
        await SubscriptionDB().subscriptions();
    if (context.read<DownloadUpdate>().plans.isEmpty) {
      await getUserSubscriptionsFromOnline();
    }
    if (mounted)
      setState(() {
        progressCode = false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (context.read<DownloadUpdate>().plans.isEmpty) {
      getUserSubscriptions();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        context.read<DownloadUpdate>().plans.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 26, bottom: 12),
                    itemCount: context.read<DownloadUpdate>().plans.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return MaterialButton(
                        onPressed: () async {
                          setState(() {
                            selectedSubscription.clear();
                            selectedSubscription.add(
                                context.read<DownloadUpdate>().plans[index]);
                          });

                          showLoaderDialog(context, message: "Loading courses");
                          List<Course> courses = await SubscriptionItemDB()
                              .subscriptionCourses(context
                                  .read<DownloadUpdate>()
                                  .plans[index]
                                  .planId!);

                          Plan newPlan = Plan(
                            id: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .planId,
                            updatedAt: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .updatedAt,
                            name: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .name,
                            createdAt: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .createdAt,
                            currency: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .currency,
                            description: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .description,
                            invoiceInterval: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .invoiceInterval,
                            invoicePeriod: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .invoicePeriod,
                            isActive: true,
                            price: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .price!
                                .toDouble(),
                            signupFee: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .price!
                                .toDouble(),
                            tag:
                                context.read<DownloadUpdate>().plans[index].tag,
                            tier: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .tier,
                            trialInterval: context
                                .read<DownloadUpdate>()
                                .plans[index]
                                .invoiceInterval,
                            trialPeriod: 1,
                          );
                          Navigator.pop(context);
                          if (courses.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: RouteSettings(
                                  name: CoursesDetailsPage.routeName,
                                ),
                                builder: (context) {
                                  return CoursesDetailsPage(
                                    courses: courses,
                                    user: widget.user,
                                    subscription: newPlan,
                                    controller: widget.controller,
                                  );
                                },
                              ),
                            );
                          } else {
                            showDialogYesNo(
                                context: context,
                                message: "Download course for this bundle",
                                target: BuyBundlePage(
                                  widget.user,
                                  controller: widget.controller,
                                  bundle: newPlan,
                                ));
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              width: appWidth(context),
                              constraints: BoxConstraints(minHeight: 70),
                              padding: EdgeInsets.all(18),
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      sText(
                                          "${context.read<DownloadUpdate>().plans[index].name}",
                                          weight: FontWeight.w600,
                                          size: 15,
                                          color: kAdeoDark,
                                          align: TextAlign.left,
                                          lHeight: 1.8),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF2F5FA),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              )
            : context.read<DownloadUpdate>().plans.isEmpty && progressCode
                ? Expanded(
                    child: Center(
                    child: progress(),
                  ))
                : Expanded(
                    child: Center(
                    child: sText("You've no subscriptions"),
                  ))
      ],
    );
  }
}
