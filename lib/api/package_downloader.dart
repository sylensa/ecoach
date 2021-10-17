import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class FileDownloader {
  final String url;
  String filename;

  FileDownloader(this.url, {required this.filename});

  downloadFile(Function(int percentage) publishSubject) async {
    Dio dio = Dio();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filename);

    String? token = await UserPreferences().getUserToken();

    return await dio.download(url, path,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'api-token': token ?? ""
          },
        ), onReceiveProgress: (received, total) {
      if (total != -1) {
        int percentage = ((received / total) * 100).floor();
        publishSubject(percentage);
      }
    });
  }
}

Future<bool> packageExist(String name) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, name);

  final file = File(path);
  return await file.exists();
}

Future<String> readSubscriptionPlan(String name) async {
  try {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, name);

    final file = File(path);

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0
    print(e);
    return "error";
  }
}
