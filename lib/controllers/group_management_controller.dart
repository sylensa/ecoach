import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/active_package_model.dart';
import 'package:ecoach/models/announcement_list_model.dart';
import 'package:ecoach/models/get_agent_code.dart';
import 'package:ecoach/models/group_grades_model.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_notification_model.dart';
import 'package:ecoach/models/group_packages_model.dart';
import 'package:ecoach/models/group_page_view_model.dart';
import 'package:ecoach/models/group_performance_model.dart';
import 'package:ecoach/models/group_test_model.dart';
import 'package:ecoach/models/report.dart';
import 'package:ecoach/models/user_group_rating.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';

import '../views/user_group/group_activities/performance/performance.dart';

class GroupManagementController{
  String? groupId;
  GroupManagementController({this.groupId});
  Future<List<AgentData>> getAgentDetails()async {
    List<AgentData> agentDetails = [];
    try{
      var js = await doGet('${AppUrl.agentPromoCodes}');
      print("res agentPromoCodes : $js");
      if (js["status"] && js["data"]["data"].isNotEmpty) {
        AgentData agentData = AgentData.fromJson(js["data"]);
        totalCommission = js["total_commissions"];
        agentDetails.add(agentData);
        toastMessage("${js["message"]}");
        return agentDetails;
      }else{
        return agentDetails;
      }
    }catch(e){
      return agentDetails;
    }
  }

  Future<List<GroupPackageData>> getGroupPackList()async {
    List<GroupPackageData> groupPackageDetails = [];
    try{
      var js = await doGet('${AppUrl.groupPackages}');
      print("res groupPackages : $js");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
          GroupPackageData groupPackageData = GroupPackageData.fromJson(js["data"]["data"][i]);
          groupPackageDetails.add(groupPackageData);
        }
        toastMessage("${js["message"]}");
        return groupPackageDetails;
      }else{
        toastMessage("${js["message"]}");
        return groupPackageDetails;
      }
    }catch(e){
      return groupPackageDetails;
    }
  }
  Future<List<ActivePackageData>> getActivePackage()async {
    List<ActivePackageData> activePackageDetails = [];
    try{
      var js = await doGet('${AppUrl.groupActivePackage}');
      print("res groupActivePackage : $js");
      if (js["code"].toString() == "200") {
        ActivePackageData activePackageData = ActivePackageData.fromJson(js["data"]);
        activePackageDetails.add(activePackageData);
       return activePackageDetails;
      }else{
        toastMessage("${js["message"]}");
        return activePackageDetails;
      }
    }catch(e){
      return activePackageDetails;
    }
  }

  Future<List<GroupListData>> getGroupList()async {
    List<GroupListData> groupListDetails = [];
    try{
      var js = await doGet('${AppUrl.groups}');
      print("res groups : $js");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
          GroupListData groupListData = GroupListData.fromJson(js["data"]["data"][i]);
          groupListDetails.add(groupListData);
        }
        return groupListDetails;
      }else{
        toastMessage("${js["message"]}");
        return groupListDetails;
      }
    }catch(e){
      toastMessage("Failed");
      return groupListDetails;
    }
  }
  Future<GroupListData?> getGroupDetails()async {
    GroupListData? groupListDetails;
    try{
      var js = await doGet('${AppUrl.groups}');
      print("res groups : $js");
      if (js["code"].toString() == "200" && js["data"].isNotEmpty) {
        groupListDetails = GroupListData.fromJson(js["data"]);
        return groupListDetails;
      }else{
        toastMessage("${js["message"]}");
        return groupListDetails;
      }
    }catch(e){
      toastMessage("Failed");
      return groupListDetails;
    }
  }

  removeUser(String userId) async {
    var res = await doPost(AppUrl.removeMember, {
      "group_id": groupId,
      "user_id": userId,
    });
    if(res["status"]){
      toastMessage(res["message"]);
      return true;
    }else{
      toastMessage(res["message"]);
      return false;
    }
  }
  makeUserParticipant(String userId) async {
    var res = await doPost(AppUrl.makeMemberParticipant, {
      "group_id": groupId,
      "user_id": userId,
    });
    if(res["status"]){
      toastMessage(res["message"]);
      return true;
    }else{
      toastMessage(res["message"]);
      return false;
    }
  }
  suspendUser(String userId) async {
    var res = await doPost(AppUrl.suspendGroupMember, {
      "group_id": groupId,
      "user_id": userId,
    });
    if(res["status"]){
      toastMessage(res["message"]);
      return true;
    }else{
      toastMessage(res["message"]);
      return true;
    }
  }
  unSuspendUser(String userId) async {
    var res = await doPost(AppUrl.unSuspendGroupMember, {
      "group_id": groupId,
      "user_id": userId,
    });
    if(res["status"]){
      toastMessage(res["message"]);
      return true;
    }else{
      toastMessage(res["message"]);
      return true;
    }
  }
  groupRequestAccept(String userId) async {
    var res = await doPost(AppUrl.groupRequestAccept, {
      "group_id": groupId,
      "user_id": userId,
    });
    if(res["status"]){
      toastMessage(res["message"]);
      return true;
    }else{
      toastMessage(res["message"]);
      return true;
    }
  }
  groupRequestReject(String userId) async {
    var res = await doPost(AppUrl.groupRequestReject, {
      "group_id": groupId,
      "user_id": userId,
    });
    if(res["status"]){
      toastMessage(res["message"]);
      return true;
    }else{
      toastMessage(res["message"]);
      return true;
    }
  }

 Future<List<GroupViewData>> getGroupPageView() async{
    List<GroupViewData>listGroupViewData = [];
    try{
      var js = await doGet('${AppUrl.groups}/$groupId');
      print("res groups view : $js");
      if (js["code"].toString() == "200" && js["data"].isNotEmpty) {
        GroupViewData groupViewData = GroupViewData.fromJson(js["data"]);
        listGroupViewData.add(groupViewData);
        toastMessage("${js["message"]}");
        return listGroupViewData;
      }else{
        toastMessage("${js["message"]}");
        return listGroupViewData;
      }
    }catch(e){
      toastMessage("Failed");
      return listGroupViewData;
    }

  }
  makeUserAdmin(String userId) async {
    var res = await doPost(AppUrl.makeMemberAdmin, {
      "group_id": groupId,
      "user_id": userId,
    });
    if(res["status"]){
      toastMessage(res["message"]);
      return true;
    }else{
      toastMessage(res["message"]);
      return false;
    }
  }
  inviteToGroup(String email) async {
    try{
      var res = await doPost(AppUrl.inviteGroup,
          {
            "email": email,
            "group_id": groupId,
          });
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;

      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }
  groupInviteAccept() async {
    try{
      var res = await doPost(AppUrl.groupInviteAccept,
          {
            "group_id": groupId,
          });
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;

      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }
  groupInviteRevoke(String userId) async {
    try{
      var res = await doPut(AppUrl.groupInviteRevoke,
          {
            "invite_id": userId,
          });
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;

      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }
  groupInviteReject() async {
    try{
      var res = await doPost(AppUrl.groupInviteReject,
          {
            "group_id": groupId,
          });
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;

      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }
  groupRequestJoin() async {
    try{
      var res = await doPost(AppUrl.groupRequestJoin,
          {
            "group_id": groupId,
          });
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;

      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }
  groupSuspend() async {
    try{
      var res = await doPut(AppUrl.groupSuspend,
          {
            "group_id": groupId,
          });
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;

      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }
  groupUnSuspend() async {
    try{
      var res = await doPut(AppUrl.groupUnSuspend,
          {
            "group_id": groupId,
          });
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;

      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }
  groupDelete() async {
    try{
      var res = await doDelete("${AppUrl.groups}/$groupId",);
      print("delete:$res");
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;
      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }

  Future<List<AnnouncementData>> getAnnouncement()async {
    List<AnnouncementData> listAnnouncementData = [];
    try{
      Map<String, dynamic> params = {
        "group_id":groupId
      };
      String queryUrl = AppUrl.getAnnouncement + '?' + Uri(queryParameters: params).query;
      var js = await doGet('$queryUrl');
      print("res getAnnouncement : $js");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
          AnnouncementData announcementData = AnnouncementData.fromJson(js["data"]["data"][i]);
          listAnnouncementData.add(announcementData);
        }
        toastMessage("${js["message"]}");
        return listAnnouncementData;
      }else{
        toastMessage("${js["message"]}");
        return listAnnouncementData;
      }
    }catch(e){
      return listAnnouncementData;
    }
  }

  Future<AnnouncementData?>  createAnnouncement(List resources,{String title = '',String description = ''}) async {
    AnnouncementData? announcementData;

   try{
     var res = await doPost(AppUrl.getAnnouncement, {
       "group_id": groupId,
       "title": title,
       "description": description,
       "resources": resources,
     });
     if (res["code"].toString() == "200" && res["data"].isNotEmpty) {
        announcementData = AnnouncementData.fromJson(res["data"]);
       toastMessage("${res["message"]}");
       return announcementData;
     }else{
       toastMessage("${res["message"]}");
       return null;
     }
   }catch(e){
     print(e.toString());
     return null;
   }
  }
  Future<AnnouncementData?>  updateAnnouncement(List resources,{String title = '',String description = '',String id = ''}) async {
    AnnouncementData? announcementData;
   try{
     var res = await doPut("${AppUrl.getAnnouncement}/$id", {
       "title": title,
       "description": description,
       // "resources": resources,
     });
     if (res["code"].toString() == "200" && res["data"].isNotEmpty) {
        announcementData = AnnouncementData.fromJson(res["data"]);
       toastMessage("${res["message"]}");
       return announcementData;
     }else{
       toastMessage("${res["message"]}");
       return null;
     }
   }catch(e){
     print(e.toString());
     return null;
   }
  }
  deleteAnnouncement(String id) async {
    try{
      var res = await doDelete("${AppUrl.getAnnouncement}/$id",);
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;
      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }

  Future<List<GroupTestData>> getGroupTest()async {
    List<GroupTestData> listGroupTestData = [];
    try{
      Map<String, dynamic> params = {
        "group_id":groupId
      };
      String queryUrl = AppUrl.groupTest + '?' + Uri(queryParameters: params).query;
      var js = await doGet('$queryUrl');
      print("res get group test : $js");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
          GroupTestData groupTestData = GroupTestData.fromJson(js["data"]["data"][i]);
          listGroupTestData.add(groupTestData);
        }
        toastMessage("${js["message"]}");
        return listGroupTestData;
      }else{
        toastMessage("${js["message"]}");
        return listGroupTestData;
      }
    }catch(e){
      return listGroupTestData;
    }
  }
  Future<GroupTestData?> getGroupTestView(String id)async {
    try{
      var js = await doGet('${AppUrl.groupTest}/$id');
      print("res getAnnouncement : $js");
      if (js["code"].toString() == "200" && js["data"].isNotEmpty) {
        GroupTestData groupTestData = GroupTestData.fromJson(js["data"]);
        toastMessage("${js["message"]}");
        return groupTestData;
      }else{
        toastMessage("${js["message"]}");
        return null;
      }
    }catch(e){
      return null;
    }
  }
  Future<GroupTestData?>  createGroupTest(Map testConfig,{String name = '',String instruction = ''}) async {
    GroupTestData? groupTestData;
    print("groupID:$groupID");
    try{
      var res = await doPost(AppUrl.groupTest, {
        "group_id": groupId,
        "instructions": instruction,
        "name": name,
        "configurations": testConfig,
      });
      print("res:$res");
      if (res["code"].toString() == "200" && res["data"].isNotEmpty) {
        groupTestData = GroupTestData.fromJson(res["data"]);
        toastMessage("${res["message"]}");
        return groupTestData;
      }else{
        toastMessage("${res["message"]}");
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<GroupTestData?>  updateGroupTest(Map testConfig,{String name = '',String instruction = '',String id = ''}) async {
    GroupTestData? groupTestData;
    try{
      var res = await doPut("${AppUrl.groupTest}/$id", {
        "group_id": groupId,
        "instructions": instruction,
        "name": name,
        "configurations": testConfig,
      });
      if (res["code"].toString() == "200" && res["data"].isNotEmpty) {
        groupTestData = GroupTestData.fromJson(res["data"]);
        toastMessage("${res["message"]}");
        return groupTestData;
      }else{
        toastMessage("${res["message"]}");
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  deleteGroupTest(String id) async {
    try{
      var res = await doDelete("${AppUrl.groupTest}/$id",);
      if(res["status"] && res["code"].toString() == "200"){
        toastMessage(res["message"]);
        return true;
      }else{
        toastMessage(res["message"]);
        return false;
      }
    }catch(e){
      print("error:$e");
      return false;
    }
  }

  Future<GroupListData?>  updateGroup(Map groupSettings) async {
    GroupListData? groupListData;
    try{
      var res = await doPut("${AppUrl.groups}/$groupId", groupSettings);
      if (res["code"].toString() == "200" && res["data"].isNotEmpty) {
        groupListData = GroupListData.fromJson(res["data"]);
        toastMessage("${res["message"]}");
        return groupListData;
      }else{
        toastMessage("${res["message"]}");
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<List<GradesDataResponse>> getGrades()async {
    List<GradesDataResponse> listGrade = [];
    try{
      var js = await doGet('${AppUrl.grades}');
      print("res grades : $js");
      if (js["status"] && js["data"]["data"].isNotEmpty) {
       for(int  i =0; i < js["data"]["data"].length; i++){
         GradesDataResponse agentData = GradesDataResponse.fromJson(js["data"]["data"][i]);
         listGrade.add(agentData);
       }
        toastMessage("${js["message"]}");
        return listGrade;
      }else{
        return listGrade;
      }
    }catch(e){
      return listGrade;
    }
  }

  Future<List<GroupListData>> getJoinGroupList()async {
    List<GroupListData> groupListDetails = [];
    // try{
      var js = await doGet('${AppUrl.joinedGroups}');
      print("res groups joined : $js");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
          if(js["data"]["data"][i]["settings"] != null){
            GroupListData groupListData = GroupListData.fromJson(js["data"]["data"][i]);
            groupListDetails.add(groupListData);
          }
        }
        return groupListDetails;
      }else{
        toastMessage("${js["message"]}");
        return groupListDetails;
      }
    // }catch(e){
    //   toastMessage("Failed");
    //   return groupListDetails;
    // }
  }
  Future<List<GroupListData>> getAllGroupList({String sort = 'popularity',String order = 'asc'})async {
    List<GroupListData> groupListDetails = [];
    // try{
      Map<String, dynamic> params = {
        "sort":sort,
        "order":order
      };
      String queryUrl = AppUrl.userGroups + '?' + Uri(queryParameters: params).query;
      var js = await doGet(queryUrl);
      print("res groups category : ${js["data"]}");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
            GroupListData groupListData = GroupListData.fromJson(js["data"]["data"][i]);
            groupListDetails.add(groupListData);
        }
        return groupListDetails;
      }else{
        toastMessage("${js["message"]}");
        return groupListDetails;
      }
    // }catch(e){
    //   toastMessage("Failed");
    //   return groupListDetails;
    // }
  }
  Future<List<GroupListData>> getGroupsByCategory({String category = ''})async {
    List<GroupListData> groupListDetails = [];
    // try{
      Map<String, dynamic> params = {
        "category":category,
      };
      String queryUrl = AppUrl.userGroups + '?' + Uri(queryParameters: params).query;
      var js = await doGet(queryUrl);
      print("res groups category : ${js["data"]}");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
            GroupListData groupListData = GroupListData.fromJson(js["data"]["data"][i]);
            groupListDetails.add(groupListData);
        }
        return groupListDetails;
      }else{
        toastMessage("${js["message"]}");
        return groupListDetails;
      }
    // }catch(e){
    //   toastMessage("Failed");
    //   return groupListDetails;
    // }
  }

  Future<List<GroupListData>> searchGroupList({String search = ''})async {
    List<GroupListData> groupListDetails = [];
    try{
      Map<String, dynamic> params = {
        "search":search,
      };
      String queryUrl = AppUrl.userSearchGroups + '?' + Uri(queryParameters: params).query;
      var js = await doGet(queryUrl);
      print("res groups : $js");
      if (js["code"].toString() == "200" && js["data"]["data"].isNotEmpty) {
        for(int i =0; i < js["data"]["data"].length; i++){
          GroupListData groupListData = GroupListData.fromJson(js["data"]["data"][i]);
          groupListDetails.add(groupListData);
        }
        return groupListDetails;
      }else{
        toastMessage("${js["message"]}");
        return groupListDetails;
      }
    }catch(e){
      toastMessage("Failed");
      return groupListDetails;
    }
  }

  Future<GroupRatingData?>  reviewGroup({String rating = '',String review = ''}) async {
    GroupRatingData? groupRatingData;
    try{
      var res = await doPost(AppUrl.userGroupRating, {
        "group_id": groupId,
        "rating": rating,
        "review": review,
      });
      print("res:$res");
      if (res["code"].toString() == "200" && res["data"].isNotEmpty) {
        groupRatingData = GroupRatingData.fromJson(res["data"]);
        toastMessage("${res["message"]}");
        return groupRatingData;
      }else{
        toastMessage("${res["message"]}");
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<List<GroupRatingData>>  getReviewGroup() async {
    List<GroupRatingData> listGroupRatingData = [];
    try{
      var res = await doGet("${AppUrl.userGroups}/$groupId}/reviews",);
      print("res:$res");
      if (res["code"].toString() == "200" && res["data"]["data"].isNotEmpty) {
        for(int i =0; i< res["data"]["data"].length; i++){
          GroupRatingData  groupRatingData = GroupRatingData.fromJson(res["data"]["data"][i]);
          listGroupRatingData.add(groupRatingData);
        }
        toastMessage("${res["message"]}");
        return listGroupRatingData;
      }else{
        toastMessage("${res["message"]}");
        return listGroupRatingData;
      }
    }catch(e){
      print(e.toString());
      return listGroupRatingData;
    }
  }
  Future<List<GroupNotificationData>>  getGroupNotifications() async {
    List<GroupNotificationData> listGroupNotificationData = [];
    try{
      var res = await doGet("${AppUrl.userGroupNotification}/notifications?group_id=$groupId",);
      print("res:$res");
      if (res["code"].toString() == "200" && res["data"]["data"].isNotEmpty) {
        for(int i =0; i< res["data"]["data"].length; i++){
          GroupNotificationData  groupNotificationData = GroupNotificationData.fromJson(res["data"]["data"][i]);
          listGroupNotificationData.add(groupNotificationData);
        }
        toastMessage("${res["message"]}");
        return listGroupNotificationData;
      }else{
        toastMessage("${res["message"]}");
        return listGroupNotificationData;
      }
    }catch(e){
      print(e.toString());
      return listGroupNotificationData;
    }
  }
  Future<List<GroupNotificationData>>  getUpcomingGroupNotifications() async {
    List<GroupNotificationData> listGroupNotificationData = [];
    try{
      var res = await doGet("${AppUrl.userGroupNotification}/notifications?upcoming=true",);
      print("res:$res");
      if (res["code"].toString() == "200" && res["data"]["data"].isNotEmpty) {
        for(int i =0; i< res["data"]["data"].length; i++){
          GroupNotificationData  groupNotificationData = GroupNotificationData.fromJson(res["data"]["data"][i]);
          listGroupNotificationData.add(groupNotificationData);
        }
        toastMessage("${res["message"]}");
        return listGroupNotificationData;
      }else{
        toastMessage("${res["message"]}");
        return listGroupNotificationData;
      }
    }catch(e){
      print(e.toString());
      return listGroupNotificationData;
    }
  }
  Future<List<GroupNotificationData>>  getUpcomingAllGroupNotifications() async {
    List<GroupNotificationData> listGroupNotificationData = [];
    try{
      var res = await doGet("${AppUrl.userGroupNotification}/notifications",);
      print("res:$res");
      if (res["code"].toString() == "200" && res["data"]["data"].isNotEmpty) {
        for(int i =0; i< res["data"]["data"].length; i++){
          GroupNotificationData  groupNotificationData = GroupNotificationData.fromJson(res["data"]["data"][i]);
          listGroupNotificationData.add(groupNotificationData);
        }
        toastMessage("${res["message"]}");
        return listGroupNotificationData;
      }else{
        toastMessage("${res["message"]}");
        return listGroupNotificationData;
      }
    }catch(e){
      print(e.toString());
      return listGroupNotificationData;
    }
  }

  Future<List<TopicStat>>  getGroupPerformance() async {
    List<TopicStat> listReport = [] ;
    // try{
      var res = await doGet("${AppUrl.userGroup}/performance?group_id=$groupId",);
      print("performance:${res["data"].length}");
      if (res["code"].toString() == "200" && res["data"].isNotEmpty) {
          for(int i =0; i < res["data"].length; i++){
           for(int t =0; t < res["data"][i]["topics_stats"].length; t++){
             print("topic stats:${res["data"][i]["topics_stats"]}");
             TopicStat  report = TopicStat.fromJson(res["data"][i]["topics_stats"][t]);
             listReport.add(report);
           }
          }
         toastMessage("${res["message"]}");
        return listReport;
      }else{
        toastMessage("${res["message"]}");
        return listReport;
      }
    // }catch(e){
    //   print(e.toString());
    //   return listGroupPerformanceData;
    // }
  }


}