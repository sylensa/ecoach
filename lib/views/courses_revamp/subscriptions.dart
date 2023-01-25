import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/store/all_bundles.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses_revamp/courses_page.dart';
import 'package:ecoach/views/library/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen(
    this.user,
    this.mainController, {
    Key? key,
    this.planId = -1,
  }) : super(key: key);
  final User user;
  final int planId;
  final MainController mainController;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _tabs;
  late int _selectedTab;
  Color _scaffoldBg = Color(0xFFF2F5FA);
  Color _scaffoldTextColor = Colors.black;
  bool isDarkTheme = false;

  setPageTheme({int pageIndex = 0}) {
    switch (pageIndex) {
      case 1:
        _scaffoldBg = kAdeoDark;
        _scaffoldTextColor = Colors.white;
        isDarkTheme = true;
        break;
      default:
        _scaffoldBg = Color(0xFFF2F5FA);
        _scaffoldTextColor = Colors.black;
        isDarkTheme = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        backgroundColor: _scaffoldBg,
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 54,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  labelColor: isDarkTheme ? Colors.white : Colors.black87,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                  unselectedLabelColor:
                      isDarkTheme ? Colors.white : Colors.black54,
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  onTap: (x) {
                    setPageTheme(pageIndex: x);

                    setState(() {});
                  },
                  indicatorColor: isDarkTheme ? Colors.white : Colors.black87,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2,
                  tabs: [
                    Tab(
                      child: Text("Subscriptions"),
                    ),
                    Tab(
                      child: Text("Store"),
                    ),
                    Tab(
                      child: Text("Library"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    CoursesPage(
                      widget.user,
                      widget.mainController,
                      planId: widget.planId,
                    ),
                    AvailableBundlesPage(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 24
                      ),
                      child: LibraryScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
