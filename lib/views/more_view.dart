import 'dart:io';

import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/bundle_download.dart';
import 'package:ecoach/views/saved_download.dart';
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
  List<SubscriptionItem> items = [];
  List que = [];
  List queList = [];

  handleSelectChanged(index) {
    setState(() {
      selectedTabIndex = index;
    });
  }
  getSubscriptionItems() async{
    if(context.read<DownloadUpdate>().plans != null){
      for(int i =0; i < context.read<DownloadUpdate>().plans.length; i++){
        int count = 0;
        print("len:${ context.read<DownloadUpdate>().plans.length}");
        List<SubscriptionItem> sItem = await SubscriptionItemDB().subscriptionItems( context.read<DownloadUpdate>().plans[i].planId!);
        for(int t = 0; t < sItem.length; t++){
          if(sItem[t].course != null){
            List<Question> question = await TestController().getSavedTests(sItem[t].course!,limit: sItem[t].questionCount);
            print("object:${question.length}");
            count += question.length;
          }
        }
        que.add(count);
      }
    }

    setState(() {
      print("que:$que");
    });

  }
  GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    UserPreferences().getUser().then((user) {
      setState(() {
        subscriptions = user != null ? user.subscriptions : [];
        context.read<DownloadUpdate>().setSubscriptions(subscriptions);
        getSubscriptionItems();
      });
    });

    userInfo = UserInfo(
      country: 'Ghana',
      dateJoined: widget.user.signupDate != null ? widget.user.signupDate!.toString() : "",
      email: widget.user.email != null ? widget.user.email! : "",
      name: widget.user.name != null ? widget.user.name! : "",
      initials: widget.user.initials,
      phoneNumber: widget.user.phone != null ? widget.user.phone! : "",
      profileImageURL: widget.user.avatar != null ? widget.user.avatar! : "",
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
    return Container(
      color:  Colors.white,
      child: SafeArea(
        top: true,
        bottom: false,
        maintainBottomViewPadding: false,
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.grey[400] ,
            // drawer: MenuDrawer(topMargin: 0,),
            body:  DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: NestedScrollView(
                physics: ClampingScrollPhysics(),
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      expandedHeight: 220.0,
                      floating: true,
                      pinned: false,
                      snap: true,
                      // backgroundColor: Colors.white,
                      backgroundColor:  Colors.white ,

                      flexibleSpace: FlexibleSpaceBar(

                        background:   UserProfile(userInfo),

                      ),
                    ),
                    // if (context.read<DownloadUpdate>().plans.length > 0)
                      SliverPersistentHeader(
                        floating: false,
                        delegate: _SliverAppBarDelegate(
                          Container(
                            // margin: EdgeInsets.zero,
                            color: Colors.white,
                            child: TabBar(
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              labelColor:  Colors.black,
                              indicatorColor: Color(0xFF253341)  ,

                              unselectedLabelColor: Colors.grey,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 5,
                              isScrollable: false,
                              labelStyle:  TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                              unselectedLabelStyle:  TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                              tabs: [
                                Tab(
                                  text: "Subscribed Bundles",
                                ),
                                Tab(
                                  text: "Saved Questions",
                                ),

                                // Tab(
                                //   text: "Stared Rank",
                                // ),

                              ],
                            ),
                          ),

                        ),
                        pinned: true,
                      ),



                  ];

                },

                body:

                TabBarView(
                  children: [
                    context.read<DownloadUpdate>().plans.length > 0 ?
                    Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          SizedBox(height: 20),
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
                              itemCount: context.read<DownloadUpdate>().plans.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: BundleListItem(
                                    bundle: widget.controller.provider.plans[index],
                                    isFirstChild: index == 0,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BundleDownload(
                                            widget.user,
                                            controller: widget.controller,
                                            bundle: widget.controller.provider.plans[index],
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
                    ) :
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(child: sText("You haven't subscribe to any bundles yet", color: Colors.white,size: 20,align: TextAlign.center,weight: FontWeight.bold),),
                    ),
                    context.read<DownloadUpdate>().plans.length > 0 ?
                    Container(
                      color: Colors.grey[200],
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0, bottom: 16),
                              child: Text(
                                'Saved Questions',
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
                              itemCount: context.read<DownloadUpdate>().plans.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: SavedQuestionsListItem(
                                    bundle: widget.controller.provider.plans[index],
                                    count:  que.isNotEmpty ? que[index] : 0,
                                    isFirstChild: index == 0,
                                    onTap: () async{
                                      if(que[index] > 0){
                                      await   Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SavedDownload(
                                              widget.user,
                                              controller: widget.controller,
                                              bundle: widget.controller.provider.plans[index],
                                            ),
                                          ),
                                        );
                                      que.clear();
                                      await getSubscriptionItems();
                                      }else{
                                        toastMessage("No saved questions");
                                      }

                                    },
                                  ),
                                );

                              },
                            ),
                          )
                        ],
                      ),
                    ) :
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(child: sText("You haven't subscribe to any bundles yet", color: Colors.white,size: 20,align: TextAlign.center,weight: FontWeight.bold),),
                    ),
                    // StaredRanks(),

                  ],
                )
              ),
            )
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
class SavedQuestionsListItem extends StatelessWidget {
  const SavedQuestionsListItem({
    required this.bundle,
    required this.isFirstChild,
    this.onTap,
    this.count = 0,
  });

  final Subscription bundle;
  final bool isFirstChild;
  final onTap;
  final count;

  @override
  Widget build(BuildContext context) {
    return MultiPurposeCourseCard(
      onTap: onTap,
      title: bundle.name!,
      subTitle: '$count Saved',
      rightWidget: Container(
        width: 20.0,
        height: 20.0,
        child: Image.asset(
          'assets/icons/arrows/arrow_right.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// class MoreView extends StatefulWidget {
//   static const String routeName = '/more';
//   const MoreView(this.user, {Key? key, required this.controller})
//       : super(key: key);
//   final User user;
//   final MainController controller;
//
//   @override
//   _MoreViewState createState() => _MoreViewState();
// }
//
// class _MoreViewState extends State<MoreView> {
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body:  Container(
//           child: DefaultTabController(
//             length: 2,
//             child: NestedScrollView(
//               physics: ClampingScrollPhysics(),
//               headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//                 return <Widget>[
//                   SliverAppBar(
//                     elevation: 0,
//                    automaticallyImplyLeading: false,
//                     centerTitle: false,
//
//                     expandedHeight: Platform.isIOS ? 280 : 300,
//                     floating: false,
//                     pinned: true,
//                     // snap: true,
//
//                     flexibleSpace: FlexibleSpaceBar(
//                       background:     UserProfile(userInfo),
//
//                     ),
//                   ),
//                   SliverPersistentHeader(
//                     floating: false,
//                     delegate: _SliverAppBarDelegate(
//                       TabBar(
//                         padding: EdgeInsets.zero,
//                         // labelColor: isDarkModeEnabledLocal ?  Colors.white: Colors.black,
//                         unselectedLabelColor: Colors.grey,
//                         indicatorSize: TabBarIndicatorSize.label,
//                         indicatorWeight: 5,
//
//                         labelPadding: EdgeInsets.only(right: 0),
//
//                         // isScrollable: true,
//                         labelStyle: TextStyle(
//                           fontWeight: FontWeight.bold,
//
//                         ),
//                         // indicatorColor: isDarkModeEnabledLocal ?  Color(0xFF253341) : topFiveScheme ,
//
//                         tabs: [
//                           Tab(
//                             text: "My Ranks",
//                           ),
//                           Tab(
//                             text: "Top Rated",
//                           ),
//
//                         ],
//                       ),
//                     ),
//                     pinned: true,
//                   ),
//
//
//                 ];
//
//               },
//
//               body:  TabBarView(
//                 physics: ClampingScrollPhysics(),
//                 children: [
//                  Container(
//                    child: Column(
//                      children: [
//                        SizedBox(height: 32),
//                        if (context.read<DownloadUpdate>().plans.length > 0)
//                          Padding(
//                            padding: const EdgeInsets.only(left: 24.0, bottom: 16),
//                            child: Text(
//                              'Subscribed bundles',
//                              textAlign: TextAlign.left,
//                              style: TextStyle(
//                                fontFamily: 'Helvetica Rounded',
//                                fontSize: 24,
//                                color: kAdeoBlue2,
//                              ),
//                            ),
//                          ),
//                        Expanded(
//                          child: ListView.builder(
//                            shrinkWrap: true,
//                            itemCount: context.read<DownloadUpdate>().plans.length,
//                            itemBuilder: (context, index) {
//                              return Padding(
//                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                                child: BundleListItem(
//                                  bundle: widget.controller.provider.plans[index],
//                                  isFirstChild: index == 0,
//                                  onTap: () {
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) => BundleDownload(
//                                          widget.user,
//                                          controller: widget.controller,
//                                          bundle:
//                                          widget.controller.provider.plans[index],
//                                        ),
//                                      ),
//                                    );
//                                  },
//                                ),
//                              );
//                            },
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                   Container()
//
//
//                 ],
//               ),
//             ),
//           ),
//         )
//     );
//
//   }
// }

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Container _tabBar;

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}
class _SABTState extends State<SABT> {
  ScrollPosition? _position;
  bool? _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }
  void _removeListener() {
    _position?.removeListener(_positionListener);
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings? settings = context.dependOnInheritedWidgetOfExactType(aspect: FlexibleSpaceBarSettings);
    bool visible = settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible!,
      child: Container(
        margin: topPadding(0),
        child: widget.child,
      ),
    );
  }
}