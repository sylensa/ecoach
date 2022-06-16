import 'package:ecoach/utils/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum FlavorType { PROD, DEV }

class FlavorSettings {
  static FlavorType flavor = FlavorType.DEV;

  FlavorSettings() {}

  static Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("packageInfo.packageName:${packageInfo.packageName}");
    switch (packageInfo.packageName) {
      case "com.ecoach.adeo":
        flavor = FlavorType.PROD;
        FlavorConfig(variables: {"baseUrl": AppUrl.liveBaseURL});
        break;
      default:
        flavor = FlavorType.DEV;
        FlavorConfig(
            name: "TEST",
            color: Colors.red,
            location: BannerLocation.topStart,
            variables: {"baseUrl": AppUrl.qaBaseURL});
    }
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(FlavorConfig.instance.variables['baseUrl']);
  }

  static String get apiBaseUrl {
    return FlavorConfig.instance.variables['baseUrl'];
  }

  static bool get isDev {
    return flavor == FlavorType.DEV;
  }
}
