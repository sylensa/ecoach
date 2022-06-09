import 'package:ecoach/utils/app_url.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum FlavorType { PROD, DEV }

class FlavorSettings {
  static late String apiBaseUrl;
  static FlavorType flavor = FlavorType.DEV;

  FlavorSettings() {}

  static Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    switch (packageInfo.packageName) {
      case "com.ecoach.adeo":
        apiBaseUrl = AppUrl.liveBaseURL;
        flavor = FlavorType.PROD;
        break;
      default:
        apiBaseUrl = AppUrl.qaBaseURL;
        flavor = FlavorType.DEV;
    }

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(apiBaseUrl);
  }

  static bool get isDev {
    return flavor == FlavorType.DEV;
  }
}
