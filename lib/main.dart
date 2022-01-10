import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/routes/Routes.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:ecoach/views/otp_view.dart';
import 'package:ecoach/views/welcome_adeo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

import 'models/user.dart';
import 'utils/notification_service.dart';
import 'views/login_view.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() {
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
  disableSembastCooperator();

  runApp(ChangeNotifierProvider<DownloadUpdate>(
      create: (context) {
        return DownloadUpdate();
      },
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adeo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
                fontFamily: 'Poppins',
              )),
      home: FutureBuilder(
          future: UserPreferences().getUser(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
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

                  if (user.subscriptions.length == 0 && !user.hasTakenTest) {
                    return WelcomeAdeo(user);
                  }

                  return MainHomePage(user);
                } else if (snapshot.data == null) {
                  return LoginPage();
                } else {
                  return CircularProgressIndicator();
                }
            }
          }),
      routes: routes,
    );
  }
}
