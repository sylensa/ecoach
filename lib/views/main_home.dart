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
    print("main_home");
    _children = [
      HomePage(
        widget.user,
        callback: (tabNumber) {
          tapping(tabNumber);
        },
      ),
      CoursesPage(widget.user),
      StorePage(widget.user),
      AnalysisView(),
      MoreView(
        widget.user,
        controller: mainController,
      ),
    ];
    currentIndex = widget.index;
    print("init");
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
    return Scaffold(
      drawer: AppDrawer(user: widget.user),
      body: _children[currentIndex],
      bottomNavigationBar: AdeoBottomNavigationBar(
        selectedIndex: currentIndex,
        onItemSelected: tapping,
        items: ['home', 'courses', 'adeo', 'analysis', 'account'],
      ),
    );
  }
}
