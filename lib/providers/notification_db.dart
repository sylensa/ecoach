import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class NotificationDB {
  // Future<void> insert(HomeNotification notification) async {
  //   if (notification == null) {
  //     return;
  //   }
  //   final Database db = await DBProvider.database;

  //   await db.insert(
  //     'notifications',
  //     notification.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<List<HomeNotification>> notifications() async {
  //   final Database db = await DBProvider.database;

  //   final List<Map<String, dynamic>> maps =
  //       await db.query('notifications', orderBy: "created_at DESC");

  //   return List.generate(maps.length, (i) {
  //     return HomeNotification(
  //       id: maps[i]["id"],
  //       dataId: maps[i]["data_id"],
  //       text: maps[i]["text"],
  //       title: maps[i]["title"],
  //       createdAt: DateTime.parse(maps[i]["created_at"]),
  //       type: maps[i]["type"],
  //     );
  //   });
  // }

  // delete(int id) async {
  //   final db = await DBProvider.database;
  //   await db.delete(
  //     'notifications',
  //     where: "id = ?",
  //     whereArgs: [id],
  //   );
  // }

  // deleteType(String type) async {
  //   final db = await DBProvider.database;
  //   await db.delete(
  //     'notifications',
  //     where: "type = ?",
  //     whereArgs: [type],
  //   );
  // }
}
