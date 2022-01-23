import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/views/more_view.dart';
import 'package:ecoach/widgets/adeo_bottom_navigation_bar.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class MainHomePage extends StatefulWidget {
  static const String routeName = '/main';
  User user;
  int index;
  MainHomePage(this.user, {this.index = 0});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with WidgetsBindingObserver {
  late List<Widget> _children;
  int currentIndex = 0;
  late MainController mainController;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    mainController =
        MainController(context, context.read<DownloadUpdate>(), widget.user);
    _children = [
      HomePage(
        widget.user,
        callback: (tabNumber) {
          tapping(tabNumber);
        },
      ),
      StorePage(widget.user),
      CoursesPage(widget.user),
      AnalysisView(user: widget.user),
      MoreView(
        widget.user,
        controller: mainController,
      ),
    ];
    currentIndex = widget.index;
    mainController.checkSubscription((success) {
      UserPreferences().getUser().then((user) {
        setState(() {
          widget.user = user!;
        });
      });
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (context.read<DownloadUpdate>().isDownloading) {
        Wakelock.enable();
      }
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
      child: SafeArea(
        child: Scaffold(
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
                'active': Icons.shop_rounded,
                'inactive': Icons.shop_outlined,
              },
              {
                'active': Icons.school_rounded,
                'inactive': Icons.school_outlined
              },
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
      ),
    );
  }
}
