import 'dart:convert';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/views/logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      this.onError}) {
    print(this.url);
    print(params.toString());
  }

  get(BuildContext context) async {
    String token = "";
    if (user == null) {
      token = (await UserPreferences().getUserToken())!;
    }
    try {
      String urlString = url + '?' + Uri(queryParameters: params ?? {}).query;
      print(urlString);
      http.Response response = await http.get(
        Uri.parse(urlString),
        headers: headers ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'api-token': user != null ? user!.token! : token
            },
      );

      handleResponse(response);
      if (onMessage != null) {
        onMessage!(message);
      }
      if (onCallback != null) {
        onCallback!(data);
      }
      if (requireLogIn) {
        showLogoutDialog(context);
      }
      return isList
          ? data
          : data!.length > 0
              ? data![0]
              : null;
    } catch (e) {
      if (onError != null) {
        print(e);
        onError!(e);
      }
    }
  }

  post(BuildContext context) async {
    String token = "";
    if (user == null) {
      token = (await UserPreferences().getUserToken())!;
    }
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers ??
            {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'api-token': user != null ? user!.token! : token
            },
        body: jsonEncode(params ?? {}),
      );

      handleResponse(response);
      if (onMessage != null) {
        onMessage!(message);
      }
      if (onCallback != null) {
        onCallback!(data);
      }

      if (requireLogIn) {
        showLogoutDialog(context);
      }
      print("returning data");
      return isList
          ? data
          : data!.length > 0
              ? data![0]
              : null;
    } catch (e) {
      onError!(e);
    }
  }

  handleResponse(http.Response response) {
    print("api response body: ${response.body}");
    Map<String, dynamic> responseData = json.decode(response.body);
    message = responseData['message'] ?? "";
    switch (response.statusCode) {
      case 200:
        handleData(responseData);
        break;
      case 301:
        break;
      case 400:
        break;
      case 403:
        requireLogIn = true;
        break;
      case 404:
        break;
      case 500:
        break;
      case 501:
        break;
      default:
    }
  }

  handleData(Map<String, dynamic> responseData) {
    if (responseData["status"] == true) {
      data = fromMap(responseData["data"], (dataItem) {
        return create(dataItem);
      });
    } else {
      onError!(null);
      data = null;
    }
  }

  fromMap(dynamic jsonData, Function(Map<String, dynamic>) create) {
    print("data=$jsonData");
    List<T> list = [];
    if (isList) {
      jsonData.forEach((v) {
        print("is array");
        print(v);
        list.add(create(v));
      });
    } else {
      print("is object");
      list.add(create(jsonData));
      print("list len=${list.length}");
    }

    print(list.length);

    return list;
  }

  void showLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
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
          );
        });
  }
}
