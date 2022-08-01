import 'package:ecoach/flavor_settings.dart';

class AppUrl {
  static const String liveBaseURL = "https://adeo.app/api/";
  static const String qaBaseURL = "https://qa.adeo.app/api/";
  static const String localBaseURL = "http://127.0.0.1:8000/api/";

  static const String websocketWS = "ws://127.0.0.1:6001/app/adeo_key";
  static const String websocketWSS = "wss://adeo.app:6001/app/adeo_key";

  static const String websocket = websocketWS;

  static String baseURL = FlavorSettings.apiBaseUrl;
  static String login = baseURL + "signin";
  static String register = baseURL + "signup";
  static String resend_pin = baseURL + "pin/resend";
  static String forgotPassword = baseURL + "password/forgot";
  static String forgotPasswordVerify = baseURL + "password/forgot/verify";
  static String forgotPasswordReset = baseURL + "password/reset";
  static String profile = baseURL + "profile";
  static String otp_verify = baseURL + "verify";
  static String change_password = baseURL + "password/reset";
  static String payment_initialize = baseURL + "paystack/initialize";
  static String payment_callback = baseURL + "paystack/callback";

  static String plans = baseURL + "plans";
  static String agentPromoCodes = baseURL + "agent/promo/codes";
  static String groupTest = baseURL + "group/tests";
  static String groupPackages = baseURL + "group/packages";
  static String getAnnouncement = baseURL + "group/announcements";
  static String groupActivePackage = baseURL + "group/packages/active";
  static String groupPackagesPaymentInitialization = baseURL + "group/package/paystack/initialize";
  static String groups = baseURL + "groups";
  static String suspendGroupMember = baseURL + "groups/member/suspend";
  static String unSuspendGroupMember = baseURL + "groups/member/unsuspend";
  static String groupRequestAccept = baseURL + "groups/request/accept";
  static String groupRequestReject = baseURL + "groups/request/reject";
  static String makeMemberAdmin = baseURL + "groups/member/admin";
  static String makeMemberParticipant = baseURL + "groups/member/participant";
  static String removeMember = baseURL + "groups/member/remove";

  static String inviteGroup = baseURL + "groups/invite/user";
  static String groupInviteAccept = baseURL + "groups/invite/accept";
  static String groupInviteReject = baseURL + "groups/invite/reject";
  static String groupInviteRevoke = baseURL + "groups/invite/cancel";
  static String groupRequestJoin = baseURL + "groups/join/request";
  static String groupSuspend = baseURL + "group/suspend";
  static String groupUnSuspend = baseURL + "group/unsuspend";
  static String userPromoCodes = baseURL + "user/promo/codes";
  static String agentTransaction = baseURL + "agent/transactions";
  static String levels = baseURL + "levels";
  static String levelGroups = baseURL + "level-groups";

  static String subjects = baseURL + 'subjects';

  static String questions = baseURL + 'questions/get';
  static String courses = baseURL + 'courses';
  static String new_user_data = baseURL + 'new_user_data';
  static String testTaken = baseURL + 'tests/taken';
  static String subscriptionData = baseURL + 'subscriptions/data';
  static String subscriptions = baseURL + 'subscriptions';
  static String subscriptionItem = baseURL + 'subscriptions/feature';
  static String subscriptionDownload = baseURL + 'subscriptions/download';
  static String subscriptionItemDownload =
      baseURL + 'subscriptions/feature/download';
  static String productKey = baseURL + 'products/key-validator';
  static String questionFlag = baseURL + 'questions/';
  static String keyGenerator = baseURL + 'products/key-generator';
  static String analysis = baseURL + 'analysis/course';
  static String report = baseURL + 'report';

  static String websocketIpURL =
      "ws://18.185.228.99:6001/app/programmers@shammah/websocket";

  static String googleLogin = baseURL + "google/signin";
  static const String bannerAdUnitIdAndroid =
      "ca-app-pub-3198630326946940~5162048290";
  static const String bannerAdUnitIdiOS =
      "ca-app-pub-3198630326946940~5162048290";
}
