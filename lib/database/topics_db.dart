import 'dart:convert';

import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/database/database.dart';
import 'package:sqflite/sqflite.dart';

class TopicDB {
  Future<void> insert(Topic topic) async {
    if (topic == null) {
      return;
    }
    // print(topic.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'topics',
        topic.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<Topic?> getTopicById(int id) async {
    final db = await DBProvider.database;

    var result = await db!.query("topics", where: "id = ?", whereArgs: [id]);
    Topic? topic = result.isNotEmpty ? Topic.fromJson(result.first) : null;

    return topic;
  }

  Future<Topic?> getLevelTopic(int courseId, int level) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('topics',
        orderBy: "name ASC", where: "course_id = ?", whereArgs: [courseId]);

    if (level > maps.length || level < 1) {
      return null;
    }

    return Topic.fromJson(maps[level - 1]);
  }

  Future<List<Topic>> getTopics(List<int> topicIds) async {
    final Database? db = await DBProvider.database;

    String ids = "";
    for (int i = 0; i < topicIds.length; i++) {
      ids += "${topicIds[i]}";
      if (i < topicIds.length - 1) {
        ids += ",";
      }
    }

    final List<Map<String, dynamic>> maps = await db!
        .rawQuery("SELECT * FROM topics WHERE id IN ($ids) ORDER BY name");

    List<Topic> topics = [];
    for (int i = 0; i < maps.length; i++) {
      Topic topic = Topic.fromJson(maps[i]);
      topics.add(topic);
    }
    return topics;
  }

  Future<void> insertAll(List<Topic> topics) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    topics.forEach((element) {
      // print(element.toJson());
      batch.insert(
        'topics',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Topic>> topics() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('topics', orderBy: "name ASC");

    List<Topic> topics = [];
    for (int i = 0; i < maps.length; i++) {
      Topic topic = Topic.fromJson(maps[i]);
      topics.add(topic);
    }
    return topics;
  }

  Future<List<Topic>> courseTopics(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('topics',
        orderBy: "name ASC",
        where: "course_id = ? AND notes <> '' ",
        whereArgs: [course.id]);

    print('course len=${maps.length}');
    List<Topic> topics = [];
    for (int i = 0; i < maps.length; i++) {
      Topic topic = Topic.fromJson(maps[i]);
      topics.add(topic);
    }
    return topics;
  }

  Future<void> update(Topic topic) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'topics',
      topic.toJson(),
      where: "id = ?",
      whereArgs: [topic.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'topics',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
