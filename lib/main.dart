import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/flavor_settings.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/revamp/features/account/view/screen/log_in.dart';
import 'package:ecoach/revamp/features/account/view/screen/phone_number_verification.dart';
import 'package:ecoach/test/test.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/review/review_onboarding.dart';
import 'package:ecoach/views/review/review_questions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/auth/otp_view.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/onboard/onboarding.dart';
import 'package:ecoach/views/onboard/welcome_adeo.dart';

import 'models/user.dart';
import 'utils/notification_service.dart';
import 'views/auth/login_view.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
bool? seenOnboard;
List<String> testDeviceIds = ['B23C05CA86653B5B363BFEB03DCC3406'];
void main() async {
  print("object:inti");
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid){
    MobileAds.instance.initialize();
  }
  RequestConfiguration configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
  NotificationService().init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  seenOnboard = await prefs.getBool("seenOnboard") ?? false;

  print("initializing flavor");
  await FlavorSettings.init();

  runApp(
    ChangeNotifierProvider<DownloadUpdate>(
      create: (context) {
        return DownloadUpdate();
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late final Widget myFuture;
  getData(){
    return FutureBuilder(
      future: UserPreferences().getUser(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          default:
            print("user.subscriptions.length:");
            print("!user.hasTakenTest:");
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            else if (snapshot.data != null) {
              User user = snapshot.data as User;

              if (!user.activated && user.token != null) {
                return PhoneNumberVerification(user);
              } else if (!user.activated) {
                return LogInPage();
              }

              if (user.subscriptions.length == 0 && !user.hasTakenTest) {
                return MainHomePage(user);
              }
              return MainHomePage(user);
            }
            else if (snapshot.data == null) {
              return LogInPage();
            }
            else {
              return CircularProgressIndicator(
                color: Colors.blue,
              );
            }
        }
      },
    );
  }



  @override
 void initState(){
    super.initState();
    myFuture = getData();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, widget) {
          return FlavorBanner(
            child: ResponsiveSizer(
              builder:  (_, __, ___) => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Adeo',
                theme: ThemeData(
                  primarySwatch: Colors.green,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  fontFamily: 'Poppins',
                  scaffoldBackgroundColor: Colors.white,
                  textTheme: Theme.of(context).textTheme.apply(
                        // bodyColor: Colors.white,
                        // displayColor: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                ),
                // home: MyTestApp(),
                home: seenOnboard == true
                    ? myFuture
                    : Onboarding(),
                routes: routes,
              ),
            ),
          );
        });
  }
}
