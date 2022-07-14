import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/revamp/features/home/view/screen/main_home_page.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/group_main_page.dart';
import 'package:ecoach/views/more_page.dart';
import 'package:ecoach/websocket/event_data.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ecoach/views/auth/home.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/views/more_view.dart';
import 'package:ecoach/widgets/adeo_bottom_navigation_bar.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../websocket/websocket_call.dart';

class MainHomePage extends StatefulWidget {
  static const String routeName = '/main';
  User user;
  int index;
  int planId;
  MainHomePage(this.user, {this.index = 0,this.planId = -1});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with WidgetsBindingObserver
    implements WebsocketListener {
  late List<Widget> _children;
  int currentIndex = 0;
  late MainController mainController;



  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    mainController = MainController(
      context,
      context.read<DownloadUpdate>(),
      widget.user,
    );
    _children = [
      // HomePage(
      //   widget.user,
      //   callback: (tabNumber) {
      //     tapping(tabNumber);
      //   },
      // ),
      HomePageAnnex(
        widget.user,
        callback: (tabNumber) {
          tapping(tabNumber);
        },
        controller: mainController,
      ),
      GroupMainPage(widget.user),
      CoursesPage(widget.user,mainController,planId: widget.planId,),
      AnalysisView(user: widget.user),
      // MoreView(
      //   widget.user,
      //   controller: mainController,
      // ),
      MorePage(
        widget.user,
        controller: mainController,
      ),
    ];
    currentIndex = widget.index;
    checkSubscription();

    WebsocketCall().addListener(this);
    WebsocketCall().connect(user: widget.user, channel: "${widget.user.id}-subscription");


    super.initState();
  }

  checkSubscription() {
    print("hey am here");
    mainController.checkSubscription((success) {
      UserPreferences().getUser().then((user) {
        setState(() {
          widget.user = user!;
        });
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (context.read<DownloadUpdate>().isDownloading) {
        Wakelock.enable();
      }
      WebsocketCall().addListener(this);
      WebsocketCall().connect(user: widget.user, channel: "${widget.user.id}-subscription");
    }
    if (state == AppLifecycleState.paused) {
      Wakelock.disable();
    }
  }

  tapping(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canExit = true;

        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Exit?",
                style: TextStyle(color: Colors.black),
              ),
              content: Text(
                "Are you sure you want to leave?",
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      canExit = true;
                      Navigator.pop(context);
                    },
                    child: Text("Yes")),
                ElevatedButton(
                  onPressed: () {
                    canExit = false;
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                )
              ],
            );
          },
        );

        return Future.value(canExit);
      },
      child: Scaffold(
        backgroundColor: kPageBackgroundGray,
        bottomSheet:
          context.watch<DownloadUpdate>().isDownloading ?
      Container(
        height: MediaQuery.of(context).size.height * .25,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 24, color: Color(0x4D000000))
          ],
        ),
        child: Column(
          children: [
            context.read<DownloadUpdate>().percentage > 0 &&
                context.read<DownloadUpdate>().percentage < 100
                ? LinearPercentIndicator(
              percent:
              context.read<DownloadUpdate>().percentage /
                  100,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 0),
              lineHeight: 4,
            )
                : LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Text(
                context
                    .read<DownloadUpdate>()
                    .message!
                    .toTitleCase(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                shrinkWrap: true,
                itemCount: context
                    .read<DownloadUpdate>()
                    .doneDownloads
                    .length,
                itemBuilder: (context, index) {
                  return Text(
                    context
                        .read<DownloadUpdate>()
                        .doneDownloads[index],
                    style: TextStyle(color: kAdeoGray2),
                  );
                },
              ),
            )

          ],
        ),
      ) :
      Container(height: 0,),
        drawer: AppDrawer(user: widget.user),
        body: _children[currentIndex],
        bottomNavigationBar: AdeoBottomNavigationBar(
          selectedIndex: currentIndex,
          onItemSelected: tapping,
          items: [
            {
              'active': Icons.home_filled,
              'inactive': Icons.home_outlined,
            },
            {
              'active': Icons.group_add_rounded,
              'inactive': Icons.group_add_outlined,
            },
            {'active': Icons.school_rounded, 'inactive': Icons.school_outlined},
            {
              'active': Icons.bar_chart,
              'inactive': Icons.bar_chart_outlined,
            },
            {
              'active': Icons.account_circle_rounded,
              'inactive': Icons.account_circle_outlined,
            },
          ],
        ),
      ),
    );
  }

  @override
  eventHandler(EventData event) {
    print("Websocket event triggered");
    checkSubscription();
  }
}
