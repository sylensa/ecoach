import 'dart:convert';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:http/http.dart' as http;

getAPI(
  String url, {
  Map<String, dynamic>? params,
  Map<String, String>? headers,
  bool isList = true,
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

    return jsonDecode(response.body);

  } catch (e, m) {
    print(e);
  }
}
