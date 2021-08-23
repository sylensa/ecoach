import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/home.dart';
import 'package:ecoach/views/logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = HomePage.routeName;
  // static const String dashboard = DashBoard.routeName;
  // static const String subscriptions = SubscriptionsPage.routeName;
  // static const String history = SubscriptionHistoryPage.routeName;
  // static const String library = LibraryPage.routeName;
  // static const String news = NewsPage.routeName;
  // static const String store = StorePage.routeName;
  // static const String exams = ExamsPage.routeName;

  // static const String analytics = AnalyticsPage.routeName;
  // static const String contents = ContentsPage.routeName;
  // static const String feedback = FeedbackPage.routeName;
  // static const String monetisation = MonetisationPage.routeName;
  // static const String create = CreateContentsPage.routeName;

  // static const String exams_management = ExamsManagementPage.routeName;
  // static const String test_analytics = TestAnalyticsPage.routeName;
  // static const String tests = TestsPage.routeName;
  // static const String questions = QuestionsPage.routeName;
  // static const String students_report = StudentsReportPage.routeName;
  // static const String set_exams = SetExamsPage.routeName;

  // static const String accounts = ProfilePage.routeName;
  // static const String password = ChangePasswordPage.routeName;
  // static const String wallet = WalletPage.routeName;
}

final Map<String, WidgetBuilder> routes = {
  Routes.home: (context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return HomePage(user);
  },
  // Routes.dashboard: (context) => DashBoard(),
  // Routes.contents: (context) => ContentsPage(),
  // Routes.monetisation: (context) => MonetisationPage(),
  // '/subscriptions': (context) => SubscriptionsPage(),
  // '/library': (context) => LibraryPage(),
  // '/news': (context) => NewsPage(),
  // '/login': (context) => Login(),
  // '/register': (context) => Register(),
  // '/profile': (context) => ProfilePage(),
  // '/change_password': (context) => ChangePasswordPage(),
  // '/store': (context) => StorePage(),
  // '/exams': (context) => ExamsPage(),
  // '/exams_management': (context) => ExamsManagementPage(),
  // '/analytics': (context) => AnalyticsPage(),
  // '/monitisation': (context) => MonetisationPage(),
  // '/feedback': (context) => FeedbackPage(),
  // '/tests': (context) => TestsPage(),
  // '/test_analytics': (context) => TestAnalyticsPage(),
  // '/questions': (context) => QuestionsPage(),
  // '/students_report': (context) => StudentsReportPage(),
  '/logout': (context) => Logout(),
};
