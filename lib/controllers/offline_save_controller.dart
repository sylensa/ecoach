import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:http/http.dart' as http;
import 'package:ecoach/database/offline_data_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/models/offline_data.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';
import 'dart:io';

class OfflineSaveController {
  User user;
  BuildContext context;

  OfflineSaveController(this.context, this.user);

  Future<bool> isOfflineDataAvailable(String? type) async {
    bool status = false;
    if (type == null) {
      final data = await OfflineDataDB().offlineData();
      status = data.length > 0;
    } else {
      final data = await OfflineDataDB().dataByType(type);
      status = data.length > 0;
    }

    return status;
  }

  saveTestTaken(TestTaken test) async {
    int id = await TestTakenDB().insert(test);
    var res = await TestTakenDB().getTestTakenById(test.userId!);
    print("res:$res");
    await OfflineDataDB().insert(OfflineData(dataId: id, dataType: "test_taken"));
  }

  saveKeywordTestTaken(TestTaken test) async {
    await TestTakenDB().insertKeywordTestTaken(test);
    var res = await TestTakenDB().getKeywordTestTaken();
    print("keyword res:$res");
  }



  saveFlagQuestion(FlagData flagData) async {
    int id = 0;
     id = await QuizDB().insertFlag(flagData);
    var res = await QuizDB().getFlagQuestionById(id);
    print("res:$res");
    return id;
  }



  syncData({String? type}) async {
    print("trying to sync data");
    if (await isOfflineDataAvailable(type)) {
      print("sync data available");
      List<OfflineData> data;
      if (type == null)
        data = await OfflineDataDB().offlineData();
      else
        data = await OfflineDataDB().dataByType(type);

      for (int i = 0; i < data.length; i++) {
        OfflineData od = data[i];
        if (od.dataType == "test_taken") {
          print("test to saved id=${od.dataId}");
          TestTaken? testTaken =
              await TestTakenDB().getTestTakenById(od.dataId!);

          if (testTaken != null) {
            bool success = await syncTestTakenData(testTaken);
            if (success) await deleteOfflineData(od);
          }
        } else if (od.dataType == "") {
        } else if (od.dataType == "") {}
      }
    }
  }

  Future<bool> syncTestTakenData(TestTaken test) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      return await makeTestApiCall(test);
    }
    return false;
  }

  Future<bool> makeTestApiCall(TestTaken testTaken) async {
    TestTaken? data;
    try {
      http.Response response = await http.post(
        Uri.parse(AppUrl.testTaken),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'api-token': user.token ?? ""
        },
        body: jsonEncode(testTaken.toJson()),
      );

      Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData["status"] == true) {
          print('status is true');
          data = TestTaken.fromJson(responseData["data"]);
        } else {
          data = null;
        }
      }
    } catch (m, e) {
      print(m);
      print(e);
    }
    if (data != null) {
      return true;
    }
    return false;
  }

  deleteOfflineData(OfflineData data) async {
    await OfflineDataDB().delete(data.id!);
    print("deleted successfully");
  }
}
