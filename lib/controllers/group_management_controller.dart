import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/active_package_model.dart';
import 'package:ecoach/models/announcement_list_model.dart';
import 'package:ecoach/models/get_agent_code.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_packages_model.dart';
import 'package:ecoach/models/group_page_view_model.dart';
import 'package:ecoach/models/group_test_model.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';

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
    var res = await doPut(AppUrl.suspendGroupMember, {
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
      var res = await doDelete("${AppUrl.groupUnSuspend}/$groupId",);
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
      var js = await doGet('${AppUrl.getAnnouncement}');
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
       // "description": description,
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
      var js = await doGet('${AppUrl.getAnnouncement}');
      print("res getAnnouncement : $js");
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
    try{
      var res = await doPost(AppUrl.groupTest, {
        "group_id": groupId,
        "name": name,
        "instruction": instruction,
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

  Future<GroupTestData?>  updateGroupTest({String name = '',String id = ''}) async {
    GroupTestData? groupTestData;
    try{
      var res = await doPut("${AppUrl.groupTest}/$id", {
        "name": name,
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
}