import 'dart:convert';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/providers/course_db.dart';
import 'package:ecoach/providers/database.dart';
import 'package:ecoach/providers/quiz_db.dart';
import 'package:sqflite/sqflite.dart';

class SubscriptionItemDB {
  Future<void> insert(SubscriptionItem subscriptionItem) async {
    if (subscriptionItem == null) {
      return;
    }
    final Database? db = await DBProvider.database;

    await db!.insert(
      'subscription_items',
      subscriptionItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (subscriptionItem.course != null) {
      CourseDB().insert(subscriptionItem.course!);
      QuizDB().insertAll(subscriptionItem.quizzes!);
    }
  }

  Future<SubscriptionItem?> getMessageById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("subscription_items", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? SubscriptionItem.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<SubscriptionItem> subscriptionItems) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    subscriptionItems.forEach((element) {
      batch.insert(
        'subscription_items',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<SubscriptionItem>> subscriptionItems(int planId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'subscription_items',
        orderBy: "created_at DESC",
        where: "plan_id = ?",
        whereArgs: [planId]);

    List<SubscriptionItem> items = [];
    for (int i = 0; i < maps.length; i++) {
      items.add(SubscriptionItem(
        id: maps[i]["id"],
        tag: maps[i]["tag"],
        name: maps[i]["name"],
        description: maps[i]["description"],
        planId: maps[i]["plan_id"],
        value: maps[i]["value"],
        sortOrder: maps[i]["sort_order"],
        resettableInterval: maps[i]["resettable_interval"],
        resettablePeriod: maps[i]["resettable_period"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
        course: await CourseDB().getCourseById(int.parse(maps[i]['tag'])),
      ));
    }
    return items;
  }

  Future<void> update(SubscriptionItem subscriptionItem) async {
    final db = await DBProvider.database;

    await db!.update(
      'subscription_items',
      subscriptionItem.toJson(),
      where: "id = ?",
      whereArgs: [subscriptionItem.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'subscription_items',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
