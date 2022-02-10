import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/bundle_download.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class MoreView extends StatefulWidget {
  static const String routeName = '/more';
  const MoreView(this.user, {Key? key, required this.controller})
      : super(key: key);
  final User user;
  final MainController controller;

  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  late UserInfo userInfo;
  List<AnalysisInfoSnippet> infoList = [];
  int selectedTabIndex = 1;
  List<Bundle> bundleList = [];
  List<Subscription> subscriptions = [];

  handleSelectChanged(index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    UserPreferences().getUser().then((user) {
      setState(() {
        subscriptions = user!.subscriptions;
        context.read<DownloadUpdate>().setSubscriptions(subscriptions);
      });
    });

    userInfo = UserInfo(
      country: 'Ghana',
      dateJoined: widget.user.signupDate!.toString(),
      email: widget.user.email!,
      name: widget.user.name!,
      initials: widget.user.initials,
      phoneNumber: widget.user.phone!,
      profileImageURL: widget.user.avatar != null ? widget.user.avatar! : null,
    );

    infoList = [
      AnalysisInfoSnippet(
        bodyText: '19',
        footerText: 'users',
        performance: '3',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: "${subscriptions.length}",
        footerText: 'bundles',
        performance: "",
        performanceImproved: false,
        background: kAnalysisInfoSnippetBackground2,
      ),
      AnalysisInfoSnippet(
        bodyText: '205',
        footerText: 'ghc',
        performance: '3',
        performanceImproved: false,
        background: kAnalysisInfoSnippetBackground3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: kAdeoGray,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfile(userInfo),
              SizedBox(height: 32),
              if (context.read<DownloadUpdate>().plans!.length > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, bottom: 16),
                  child: Text(
                    'Subscribed bundles',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Helvetica Rounded',
                      fontSize: 24,
                      color: kAdeoBlue2,
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: context.read<DownloadUpdate>().plans!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BundleListItem(
                        bundle: widget.controller.provider.plans![index],
                        isFirstChild: index == 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BundleDownload(
                                widget.user,
                                controller: widget.controller,
                                bundle:
                                    widget.controller.provider.plans![index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BundleListItem extends StatelessWidget {
  const BundleListItem({
    required this.bundle,
    required this.isFirstChild,
    this.onTap,
  });

  final Subscription bundle;
  final bool isFirstChild;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return MultiPurposeCourseCard(
      onTap: onTap,
      title: bundle.name!,
      subTitle: '${bundle.timeLeft} left',
      rightWidget: Container(
        width: 20.0,
        height: 20.0,
        child: Image.asset(
          'assets/icons/arrows/arrow_right.png',
          fit: BoxFit.contain,
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: onTap,
    //   child: Container(
    //     padding: EdgeInsets.only(
    //       left: 32.0,
    //       right: 20.0,
    //       top: 12.0,
    //       bottom: 12.0,
    //     ),
    //     decoration: BoxDecoration(
    //       border: Border(
    //         top: isFirstChild
    //             ? BorderSide(width: 1.0, color: kAdeoGray)
    //             : BorderSide.none,
    //         bottom: BorderSide(width: 1.0, color: kAdeoGray),
    //       ),
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 bundle.name!,
    //                 style: TextStyle(
    //                   color: kDefaultBlack,
    //                   fontSize: 18.0,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //               Text(
    //                 '${bundle.timeLeft} left',
    //                 style: TextStyle(
    //                   color: kBlack38,
    //                   fontSize: 12.0,
    //                   fontWeight: FontWeight.w600,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Text(
    //             "${context.watch<DownloadUpdate>().getDownloadStatus(bundle.id!)}"),
    //         Container(
    //           width: 32.0,
    //           height: 32.0,
    //           child: Image.asset(
    //             'assets/icons/arrows/arrow_right.png',
    //             fit: BoxFit.contain,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
