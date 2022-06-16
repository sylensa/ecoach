import 'package:ecoach/lib/features/account/view/screen/create_account.dart';
import 'package:ecoach/lib/features/account/view/screen/log_in.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/analysis.dart';
import 'package:ecoach/views/auth/home.dart';
import 'package:ecoach/views/auth/login_view.dart';
import 'package:ecoach/views/auth/logout.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/auth/register_view.dart';
import 'package:ecoach/views/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = HomePage.routeName;
  static const String mainHome = MainHomePage.routeName;
  // static const String dashboard = DashBoard.routeName;
  // static const String subscriptions = SubscriptionsPage.routeName;
  // static const String history = SubscriptionHistoryPage.routeName;
  // static const String library = LibraryPage.routeName;
  // static const String news = NewsPage.routeName;
  static const String store = StorePage.routeName;
  // static const String exams = ExamsPage.routeName;

  // static const String analytics = AnalyticsPage.routeName;
  // static const String contents = ContentsPage.routeName;
  // static const String feedback = FeedbackPage.routeName;
  // static const String monetisation = MonetisationPage.routeName;
  // static const String create = CreateContentsPage.routeName;

  // static const String exams_management = ExamsManagementPage.routeName;
  // static const String test_analytics = TestAnalyticsPage.routeName;
  // static const String tests = TestsPage.routeName;
  static const String courses = CoursesPage.routeName;
  static const String friends = AnalysisView.routeName;
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
  '/login': (context) => LogInPage(),
  '/register': (context) => CreateAccountPage(),
  // '/profile': (context) => ProfilePage(),
  // '/change_password': (context) => ChangePasswordPage(),
  Routes.store: (context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return StorePage(user);
  },
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
