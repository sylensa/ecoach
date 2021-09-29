class AppUrl {
  static const String liveBaseURL = "http://3.10.254.94/api/";
  static const String localBaseURL = "http://127.0.0.1:8000/api/";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "signin";
  static const String register = baseURL + "signup";
  static const String resend_pin = baseURL + "pin/resend";
  static const String forgotPassword = baseURL + "forgot-password";
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
}
