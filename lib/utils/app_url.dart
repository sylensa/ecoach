class AppUrl {
  static const String liveBaseURL = "https://adeo.app/api/";
  static const String qaBaseURL = "https://qa.adeo.app/api/";
  static const String localBaseURL = "http://127.0.0.1:8000/api/";

  static const String websocketWS = "ws://127.0.0.1:6001/app/adeo_key";
  static const String websocketWSS = "wss://adeo.app:6001/app/adeo_key";

  static const String websocket = websocketWS;

  static const String baseURL = qaBaseURL;
  static const String login = baseURL + "signin";
  static const String register = baseURL + "signup";
  static const String resend_pin = baseURL + "pin/resend";
  static const String forgotPassword = baseURL + "password/forgot";
  static const String forgotPasswordVerify = baseURL + "password/forgot/verify";
  static const String forgotPasswordReset = baseURL + "password/reset";
  static const String profile = baseURL + "profile";
  static const String otp_verify = baseURL + "verify";
  static const String change_password = baseURL + "password/reset";
  static const String payment_initialize = baseURL + "paystack/initialize";
  static const String payment_callback = baseURL + "paystack/callback";

  static const String plans = baseURL + "plans";
  static const String levels = baseURL + "levels";
  static const String levelGroups = baseURL + "level-groups";

  static const String subjects = baseURL + 'subjects';

  static const String questions = baseURL + 'questions/get';
  static const String courses = baseURL + 'courses';
  static const String new_user_data = baseURL + 'new_user_data';
  static const String testTaken = baseURL + 'tests/taken';
  static const String subscriptionData = baseURL + 'subscriptions/data';
  static const String subscriptions = baseURL + 'subscriptions';
  static const String subscriptionItem = baseURL + 'subscriptions/feature';
  static const String subscriptionDownload = baseURL + 'subscriptions/download';
  static const String subscriptionItemDownload =
      baseURL + 'subscriptions/feature/download';
  static const String productKey = baseURL + 'products/key-validator';
  static const String questionFlag = baseURL + 'questions/';
  static const String keyGenerator = baseURL + 'products/key-generator';
  static const String analysis = baseURL + 'analysis/course';
  static const String report = baseURL + 'report';

  static const String websocketIpURL =
      "ws://18.185.228.99:6001/app/programmers@shammah/websocket";

  static const String googleLogin = baseURL + "google/signin";
  static const String bannerAdUnitIdAndroid = "ca-app-pub-3198630326946940~5162048290";
  static const String bannerAdUnitIdiOS = "ca-app-pub-3198630326946940~5162048290";
}
