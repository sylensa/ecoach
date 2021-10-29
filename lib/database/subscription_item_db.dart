import 'dart:convert';
import 'package:ecoach/api/package_downloader.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:sqflite/sqflite.dart';

class SubscriptionItemDB {
  Future<void> insert(SubscriptionItem subscriptionItem) async {
    print("saving subcription item ${subscriptionItem.name}");
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'subscription_items',
        subscriptionItem.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (subscriptionItem.course != null) {
        await CourseDB().insert(subscriptionItem.course!);
        await QuizDB().insertAll(subscriptionItem.quizzes!);
      }
    });
  }

  Future<SubscriptionItem?> getMessageById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("subscription_items", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? SubscriptionItem.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<SubscriptionItem> subscriptionItems) async {
    print("insert all subs");
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

  Future<List<SubscriptionItem>> allSubscriptionItems() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'subscription_items',
      orderBy: "name ASC",
    );

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
      ));
    }
    return items;
  }

  Future<List<SubscriptionItem>> undownloadedItems() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'subscription_items',
      orderBy: "name ASC",
    );

    List<SubscriptionItem> items = [];
    for (int i = 0; i < maps.length; i++) {
      bool exist = await packageExist(maps[i]['name']);
      print("package ${maps[i]['name']} exist? $exist");
      if (exist) continue;
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
      ));
    }
    return items;
  }

  Future<List<SubscriptionItem>> subscriptionItems(int planId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'subscription_items',
        orderBy: "name ASC",
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
        quizCount: await QuizDB().quizCount(int.parse(maps[i]['tag'])),
        questionCount:
            await QuestionDB().getTotalQuestionCount(int.parse(maps[i]['tag'])),
      ));
    }
    return items;
  }

  Future<List<Course>> subscriptionCourses(int planId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'subscription_items',
        orderBy: "name ASC",
        where: "plan_id = ?",
        whereArgs: [planId]);

    List<Course> items = [];
    for (int i = 0; i < maps.length; i++) {
      Course? course =
          await CourseDB().getCourseById(int.parse(maps[i]['tag']));
      print(int.parse(maps[i]['tag']));
      if (course != null) {
        print(course.toJson());
        items.add(course);
      }
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
