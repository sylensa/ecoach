import 'package:ecoach/provider/google_sign_in_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
  NotificationService().init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  seenOnboard = prefs.getBool("seenOnboard") ?? false;

  runApp(
    ChangeNotifierProvider<DownloadUpdate>(
      create: (context) {
        return DownloadUpdate();
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: Size(360, 640),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_) {
            return GetMaterialApp(
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
              home: seenOnboard == true
                  ? FutureBuilder(
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
                            if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else if (snapshot.data != null) {
                              User user = snapshot.data as User;

                              if (!user.activated && user.token != null) {
                                return OTPView(user);
                              } else if (!user.activated) {
                                return LoginPage();
                              }

                              if (user.subscriptions.length == 0 &&
                                  !user.hasTakenTest) {
                                return WelcomeAdeo(user);
                              }

                              return MainHomePage(user);
                            } else if (snapshot.data == null) {
                              return LoginPage();
                            } else {
                              return CircularProgressIndicator(
                                color: Colors.blue,
                              );
                            }
                        }
                      },
                    )
                  : Onboarding(),
              routes: routes,
            );
          }),
    );
  }
}
