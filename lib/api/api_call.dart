import 'dart:convert';
import 'dart:io';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/auth/logout.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class ApiCall<T> {
  Map<String, dynamic>? params;
  Map<String, String>? headers;
  String url;
  String message = "Something went wrong";
  bool isList;
  User? user;
  List<T>? data;
  Function(Map<String, dynamic>) create;
  Function(dynamic)? onCallback;
  Function(dynamic)? onError;
  Function(String)? onMessage;

  bool requireLogIn = false;

  ApiCall(this.url,
      {this.params,
      this.headers,
      this.user,
      this.isList = true,
      required this.create,
      this.onCallback,
      this.onMessage,
      this.onError}) {}

  get(BuildContext context) async {
    String? token = "";
    if (user == null) {
      token = (await UserPreferences().getUserToken());
    } else {
      token = user!.token!;
      await OfflineSaveController(context, user!).syncData();
    }
    try {
      String urlString = url + '?' + Uri(queryParameters: params ?? {}).query;
      print(urlString);
      print("params:$params");
      http.Response response = await http.get(
        Uri.parse(urlString),
        headers: headers ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'api-token': token ?? "",
            },
      );

      handleResponse(response);
      if (onMessage != null) {
        onMessage!(message);
      }

      if (requireLogIn) {
        showLogoutDialog(context);
      }
      print("returning data");
      return getFinalData();
    } on SocketException catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showNoConnectionToast(context);
      if (onError != null) {
        onError!(e);
      }
    } catch (m, e) {
      print(m);
      print(e);
      if (onError != null) {
        onError!(e);
      }
    }
  }

  Future post(BuildContext context) async {
    String? token = "";
    print(Uri.parse(url));
    print(params);
    if (user == null) {
      token = (await UserPreferences().getUserToken());
    } else {
      token = user!.token!;
      await OfflineSaveController(context, user!).syncData();
    }

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'api-token': token ?? ""
            },
        body: jsonEncode(params ?? {}),
      );

      handleResponse(response);
      if (onMessage != null) {
        onMessage!(message);
      }

      if (requireLogIn) {
        showLogoutDialog(context);
      }
      print("returning data");
      return getFinalData();
    } catch (m, e) {
      print(m);
      print(e);
      if (onError != null) {
        onError!(e);
      }
    }
  }

  getFinalData() {
    if (data == null) {
      return null;
    }
    return isList
        ? data
        : data!.length > 0
            ? data![0]
            : null;
  }

  handleResponse(http.Response response) {
    print(response.body);
    print(response.statusCode);
    Map<String, dynamic> responseData = json.decode(response.body);
    message = responseData['message'] ?? "";
    switch (response.statusCode) {
      case 200:
        handleData(responseData);
        break;
      case 301:
        break;
      case 403:
        requireLogIn = true;
        print("required login");
        break;
      case 400:
      case 404:
      case 500:
      case 501:
        if (onError != null) {
          onError!(null);
        }
        break;
      default:
    }
  }

  handleData(Map<String, dynamic> responseData) {
    print(responseData["status"]);
    if (responseData["status"] == true) {
      print('status is true');
      data = fromMap(responseData["data"], (dataItem) {
        return create(dataItem);
      });
      if (onCallback != null) {
        onCallback!(getFinalData());
      }
    } else {
      print('checking on Error');
      if (onError != null) {
        onError!(null);
      }

      data = null;
    }
  }

  fromMap(dynamic jsonData, Function(Map<String, dynamic>) create) {
    List<T> list = [];
    if (isList) {
      if (jsonData != null) {
        jsonData.forEach((v) {
          print("is array");
          list.add(create(v));
        });
      }
    } else {
      print("is object");
      list.add(create(jsonData));
    }

    print(list.length);

    return list;
  }

  void showLogoutDialog(context) {
    print("show dialog...");
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            child: Center(
              child: Container(
                color: Colors.purple,
                width: 300,
                height: 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 0),
                      child: Text(
                        "Logout?",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    Center(child: Text(message)),
                    Spacer(),
                    SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                          ),
                          Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Logout();
                                  }), (route) => false);
                                },
                                child: Text("Logout")),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
