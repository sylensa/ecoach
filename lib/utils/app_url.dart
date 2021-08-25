class AppUrl {
  static const String liveBaseURL = "http://3.10.254.94/api/";
  static const String localBaseURL = "http://127.0.0.1:8000/api/";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "signin";
  static const String register = baseURL + "signup";
  static const String resend_pin = baseURL + "pin/resend";
  static const String forgotPassword = baseURL + "forgot-password";
  static const String profile = baseURL + "profile";
  static const String otp_verify = baseURL + "otp/verify";
  static const String change_password = baseURL + "password/reset";
  static const String payment_initialize = baseURL + "paystack/initialize";
}
