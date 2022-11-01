import 'dart:convert';
import 'package:ecoach/api/api_response.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/account/view/screen/log_in.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ApiCall<T> {
  String message = "Something went wrong";
  BuildContext context;

  ApiCall(this.context) {}

  Future<ApiResponse<T>> get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isList = true,
    required Function(Map<String, dynamic>) create,
  }) async {
    try {
      User? user = await UserPreferences().getUser();
      String? accessToken = "";
      if (user != null) {
        accessToken = user.token ?? "";
      }
      String urlString = url + '?' + Uri(queryParameters: params ?? {}).query;
      print(urlString);
      http.Response response = await http.get(
        Uri.parse(urlString),
        headers: headers ??
            {
              "api-token": accessToken,
              "Content-Type": "application/json",
              'Accept': 'application/json'
            },
      );

      return handleResponseData(response, create, isList);
    } catch (e, m) {
      print(e);
      return ApiResponse<T>(message: "Exception occured");
    }
  }

  Future<ApiResponse<T>> post(
    String url, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    bool isList = true,
    required Function(Map<String, dynamic>) create,
  }) async {
    User? user = await UserPreferences().getUser();
    String? accessToken = "";
    if (user != null) {
      accessToken = user.token ?? "";
    }
    print(url);
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers ??
          {"api-token": accessToken, "Content-Type": "application/json"},
      body: json.encode(params),
    );

    return handleResponseData(response, create, isList);
  }

  ApiResponse<T> handleResponseData(http.Response response,
      Function(Map<String, dynamic>) create, bool isList) {
    if (response.statusCode == 200) {
      return handleData(response.body, create, isList);
    }
    if (response.statusCode == 403) {
      Map<String, dynamic> responseData = json.decode(response.body);
      showLogoutDialog(context);
      return ApiResponse<T>(message: responseData['message']);
    }
    if (response.statusCode == 404) {
      return ApiResponse<T>(
          message:
              "It seems the call to the server is wrong. Please contact admin");
    }
    if (response.statusCode == 501) {
      return ApiResponse<T>(message: "Server error. Please contact admin");
    } else {
      return ApiResponse<T>(
          message:
              "Request to server failed with status code ${response.statusCode}");
    }
  }

  ApiResponse<T> handleData(
      String body, Function(Map<String, dynamic>) create, bool isList) {
    Map<String, dynamic> responseData = json.decode(body);
    if (responseData["status"] == true) {
      return ApiResponse<T>.fromJson(body, (dataItem) {
        return create(dataItem);
      }, isList: isList);
    } else {
      print("not successful event");
      return ApiResponse<T>(
        message: responseData['message'],
      );
    }
  }

  void showLogoutDialog(context) {
    print("show dialog...");
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            child: Center(
              child: Container(
                color: Colors.red,
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
                                    return LogInPage();
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
