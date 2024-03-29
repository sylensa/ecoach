import 'dart:io';

import 'package:ecoach/utils/shared_preference.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  static initDB() async {
    int? userId = await UserPreferences().getUserId();
    String name = userId != null ? "ecoach_${userId}.123.db" : "ecoach63.db";
    print(name);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, name);
    return await openDatabase(path, version: 46, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE friends_requests ("
          "id INTEGER PRIMARY KEY,"
          "user_id INTEGER,"
          "status TEXT,"
          "user_requested INTEGER,"
          "friend TEXT,"
          "user TEXT,"
          "created_at TEXT,"
          "updated_at TEXT"
          ")");

      await db.execute("""CREATE TABLE 'course_levels' (
        'id' INTEGER PRIMARY KEY,
        'name' varchar(50) NOT NULL,
        'code' varchar(10) NOT NULL,
        'category' varchar(50) NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'glossary_study_progress' (
        'id' int NOT NULL,
        'search_term' varchar(50) NOT NULL,
        'selected_character' varchar(50) NOT NULL,
        'course_id' INTEGER NOT NULL,
       'correct' INTEGER NOT NULL,
        'wrong' INTEGER NOT NULL,
        'count' INTEGER NOT NULL,
        'progress_index' INTEGER NOT NULL,
        'topic_id' INTEGER NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'glossary_try_progress' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'search_term' varchar(50) NOT NULL,
        'selected_character' varchar(50) NOT NULL,
        'course_id' INTEGER NOT NULL,
        'correct' INTEGER NOT NULL,
        'wrong' INTEGER NOT NULL,
        'count' INTEGER NOT NULL,
        'progress_index' INTEGER NOT NULL,
        'topic_id' INTEGER NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'offline_data' (
        'id' INTEGER PRIMARY KEY,
        'data_id' INTEGER NOT NULL,
        'data_type' varchar(10) NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'time' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0'
      ) """);
      await db.execute("""CREATE TABLE 'conquest_questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'time' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0'
      ) """);

      await db.execute("""CREATE TABLE 'test_saved_questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'time' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0'
      ) """);

      await db.execute("""CREATE TABLE 'topics' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int DEFAULT NULL,
        'topicID' text DEFAULT NULL,
        'name' text,
        'image_url' text DEFAULT NULL,
        'author' text DEFAULT NULL,
        'description' text DEFAULT NULL,
        'notes' text DEFAULT NULL,
        'category' text DEFAULT NULL,
        'created_at' text,
        'updated_at' text,
        'confirmed' int DEFAULT NULL,
        'public' int DEFAULT NULL,
        'N' int DEFAULT NULL,
        'p' int DEFAULT NULL,
        'editors' text
      ) """);

      await db.execute("""CREATE TABLE 'notes_read' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'course_id' int DEFAULT NULL,
        'topic_id' int DEFAULT NULL,
        'name' text,
        'image_url' text DEFAULT NULL,
        'author' text DEFAULT NULL,
        'description' text DEFAULT NULL,
        'notes' text DEFAULT NULL,
        'created_at' timestamp DEFAULT NULL,
        'updated_at' timestamp DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'courses' (
        'id' INTEGER PRIMARY KEY,
        'package_code' varchar(11) NOT NULL,
        'courseID' varchar(20) NOT NULL,
        'name' varchar(50) NOT NULL,
        'description' text NOT NULL,
        'category' varchar(50) NOT NULL,
        'author' varchar(50) NOT NULL DEFAULT 'content@ecoachsolutions.com',
        'time' int NOT NULL DEFAULT '60',
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'N' int NOT NULL DEFAULT '0',
        'p' int NOT NULL DEFAULT '0',
        'editors' varchar(128) NOT NULL DEFAULT '[]',
        'level_id' int DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'plans' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255)  NOT NULL,
        'name' varchar(255)  NOT NULL,
        'description' varchar(255)  DEFAULT NULL,
        'is_active' tinyint(1) NOT NULL DEFAULT '1',
        'user_subscribed' tinyint(1) NOT NULL DEFAULT '1',
        'price' decimal(8,2) NOT NULL DEFAULT '0.00',
        'signup_fee' decimal(8,2) NOT NULL DEFAULT '0.00',
        'currency' varchar(3)  NOT NULL,
        'trial_period' smallint unsigned NOT NULL DEFAULT '0',
        'trial_interval' varchar(255)  NOT NULL DEFAULT 'day',
        'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
        'invoice_interval' varchar(255)  NOT NULL DEFAULT 'month',
        'tier' mediumint unsigned NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'answers' (
        'id' INTEGER PRIMARY KEY,
        'question_id' int NOT NULL,
        'text' text NOT NULL,
        'value' int DEFAULT '0',
        'solution' text NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NULL,
        'answer_order' int DEFAULT '0',
        'responses' int NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'editors' varchar(128) NOT NULL DEFAULT '[]'
      )""");

      await db.execute("""CREATE TABLE 'subscriptions' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255) NOT NULL,
        'subscriber_type' varchar(255) NOT NULL,
        'subscriber_id' bigint unsigned NOT NULL,
        'plan_id' int unsigned DEFAULT NULL,
        'name' varchar(255) DEFAULT NULL,
        'description' varchar(255) DEFAULT NULL,
        'price' decimal(8,2) NOT NULL DEFAULT '0.00',
        'currency' varchar(3) NOT NULL,
        'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
        'invoice_interval' varchar(255) NOT NULL DEFAULT 'month',
        'tier' mediumint unsigned NOT NULL DEFAULT '0',
        'trial_ends_at' timestamp NULL DEFAULT NULL,
        'starts_at' timestamp NULL DEFAULT NULL,
        'ends_at' timestamp NULL DEFAULT NULL,
        'cancels_at' timestamp NULL DEFAULT NULL,
        'canceled_at' timestamp NULL DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'subscription_items' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255) NOT NULL,
        'plan_id' int unsigned NOT NULL,
        'question_count' int unsigned NOT NULL,
        'quiz_count' int unsigned NOT NULL,
        'topic_count' int unsigned NOT NULL,
        'name' varchar(255) NOT NULL,
        'description' varchar(255) DEFAULT NULL,
        'value' varchar(255) NOT NULL,
        'resettable_period' smallint unsigned NOT NULL DEFAULT '0',
        'resettable_interval' varchar(255) NOT NULL DEFAULT 'month',
        'sort_order' mediumint unsigned NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'plan_items' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255) NOT NULL,
        'plan_id' int unsigned NOT NULL,
        'question_count' int unsigned NOT NULL,
        'quiz_count' int unsigned NOT NULL,
        'topic_count' int unsigned NOT NULL,
        'name' varchar(255) NOT NULL,
        'description' varchar(255) DEFAULT NULL,
        'value' varchar(255) NOT NULL,
        'resettable_period' smallint unsigned NOT NULL DEFAULT '0',
        'resettable_interval' varchar(255) NOT NULL DEFAULT 'month',
        'sort_order' mediumint unsigned NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'quizzes' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'testID' varchar(50) DEFAULT '0000000000',
        'type' varchar(20) NOT NULL DEFAULT 'DEFINED',
        'name' varchar(50) NOT NULL,
        'author' varchar(50) NOT NULL DEFAULT 'content@ecoachsolutions.com',
        'time' int NOT NULL DEFAULT '0',
        'description' text NULL,
        'category' varchar(255) NOT NULL,
        'instructions' text NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0'
      ) """);

      await db.execute("""CREATE TABLE 'quiz_items' (
        'id' INTEGER PRIMARY KEY,
        'question_id' int NOT NULL,
        'quiz_id' int NOT NULL
      ) """);

      await db.execute("""CREATE TABLE 'tests_taken' (
        'id' INTEGER PRIMARY KEY,
        'user_id' int NOT NULL,
        'group_id' int DEFAULT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'challenge_type' varchar(255) DEFAULT NULL,
        'topic_id' int DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'keyword_test_taken' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'user_id' int NOT NULL,
        'group_id' int DEFAULT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'challenge_type' varchar(255) DEFAULT NULL,
        'topic_id' int DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'conquest_tests_taken' (
        'id' INTEGER PRIMARY KEY,
        'user_id' int NOT NULL,
        'group_id' int DEFAULT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'challenge_type' varchar(255) DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'analysis' (
        'id' INTEGER PRIMARY KEY,
        'user_id' int NULL,
        'course_id' int NULL,
        'mastery' double NOT NULL,
        'last_mastery' double NULL,
        'point' double NOT NULL,
        'last_point' double NULL,
        'used_speed' int NOT NULL,
        'last_speed' int NULL,
        'total_speed' int NOT NULL,
        'user_rank' int NOT NULL,
        'last_rank' int NULL,
        'total_rank' int NOT NULL
      ) """);

      await db.execute("""CREATE TABLE notifications (
          id INTEGER PRIMARY KEY,
          data_id INTEGER,
          title TEXT,
          text TEXT,
          type TEXT,
          created_at TEXT
          )""");

      await db.execute("""
            CREATE TABLE courses_levels (
              id INTEGER PRIMARY KEY, 
              course_id INTEGER NOT NULL,
              level_id INTEGER NOT NULL,
              FOREIGN KEY (course_id) REFERENCES courses (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION,
              FOREIGN KEY (level_id) REFERENCES levels (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )""");

      await db.execute("""CREATE TABLE 'studies' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'name' varchar(255)  NOT NULL,
        'current_topic_id' int NULL,
        'course_id' int NOT NULL,
        'type' varchar(255)  NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'study_progress' (
        id INTEGER PRIMARY KEY, 
        'study_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'level' int DEFAULT NULL,
        'section' int DEFAULT NULL,
        'name' varchar(255)  NOT NULL,
        'score' double DEFAULT NULL,
        'no_failed' tinyint(1) NULL DEFAULT '0',
        'passed' tinyint(1) NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'revision_study_progress' (
        id INTEGER PRIMARY KEY, 
        'study_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'course_id' int DEFAULT NULL,
        'level' int DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'course_completion_study_progress' (
        id INTEGER PRIMARY KEY, 
        'study_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'course_id' int DEFAULT NULL,
        'level' int DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'speed_study_level' (
        id INTEGER PRIMARY KEY, 
        'study_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'course_id' int DEFAULT NULL,
        'level' int DEFAULT NULL,
        'fails' int DEFAULT 0,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'revision_progress_attempts' (
        id INTEGER PRIMARY KEY, 
        "revision_progress_id" int NOT NULL,
        'study_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'course_id' int DEFAULT NULL,
        'topic_name' varchar(255) DEFAULT NULL,
        'score' int DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'course_completion_progress_attempts' (
        id INTEGER PRIMARY KEY, 
        "cc_progress_id" int NOT NULL,
        'study_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'course_id' int DEFAULT NULL,
        'topic_name' varchar(255) DEFAULT NULL,
        'score' int DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);

      await db.execute("""CREATE TABLE 'marathons' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'title' varchar(255)  NOT NULL,
        'type' varchar(255)  NOT NULL,
        'topic_id' int NULL,
        'avg_score' double NOT NULL DEFAULT 0,
        'avg_time' double NOT NULL DEFAULT 0,
        'total_questions' int NOT NULL DEFAULT 0,
        'total_correct' int NOT NULL DEFAULT 0,
        'total_wrong' int NOT NULL DEFAULT 0,
        'total_time' int NOT NULL DEFAULT 0,
        'status' varchar(255)  NOT NULL,
        'start_time' timestamp NULL DEFAULT NULL,
        'end_time' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'marathon_progress' (
        id INTEGER PRIMARY KEY, 
        'marathon_id' int NOT NULL,
        'question_id' int NOT NULL,
        'course_id' int NOT NULL,
        'user_id' int NOT NULL,
        'topic_id' int NULL,
        'topic_name' varchar(255)  NULL,
        'selected_answer_id' int NULL,
         'time' int NULL DEFAULT 0,
        'status' varchar(255)  NULL
      ) """);

      await db.execute("""CREATE TABLE 'treadmills' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'title' varchar(255)  NOT NULL,
        'type' varchar(255)  NOT NULL,
        'topic_id' int NULL,
        'bank_id' int NULL,
        'avg_score' double NOT NULL DEFAULT 0,
        'avg_time' double NOT NULL DEFAULT 0,
        'total_questions' int NOT NULL DEFAULT 0,
        'total_correct' int NOT NULL DEFAULT 0,
        'total_wrong' int NOT NULL DEFAULT 0,
        'total_time' int NOT NULL DEFAULT 0,
        'status' varchar(255)  NOT NULL,
        'duration' int NULL,
        'start_time' timestamp NULL DEFAULT NULL,
        'end_time' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'treadmill_progress' (
        id INTEGER PRIMARY KEY, 
        'treadmill_id' int NOT NULL,
        'question_id' int NOT NULL,
        'course_id' int NOT NULL,
        'user_id' int NOT NULL,
        'topic_id' int NULL,
        'bank_id' int NULL,
        'topic_name' varchar(255)  NULL,
        'selected_answer_id' int NULL,
         'time' int NULL DEFAULT 0,
        'status' varchar(255)  NULL
      ) """);

      await db.execute("""CREATE TABLE 'autopilots' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'title' varchar(255)  NOT NULL,
        'type' varchar(255)  NOT NULL,
        'topic_id' int NULL,
        'status' varchar(255)  NOT NULL,
        'start_time' timestamp NULL DEFAULT NULL,
        'end_time' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'autopilot_progress' (
        id INTEGER PRIMARY KEY, 
        'autopilot_id' int NOT NULL,
        'question_id' int NOT NULL,
        'course_id' int NOT NULL,
        'user_id' int NOT NULL,
        'topic_id' int NULL,
        'topic_name' varchar(255)  NULL,
        'selected_answer_id' int NULL,
         'time' int NULL DEFAULT 0,
        'status' varchar(255)  NULL
      ) """);

      await db.execute("""CREATE TABLE 'autopilot_topics' (
        id INTEGER PRIMARY KEY, 
        'autopilot_id' int NOT NULL,
        'topic_id' int NULL,
        'topic_name' varchar(255)  NULL,
        'avg_score' double NOT NULL DEFAULT 0,
        'avg_time' double NOT NULL DEFAULT 0,
        'total_questions' int NOT NULL DEFAULT 0,
        'correct' int NOT NULL DEFAULT 0,
        'wrong' int NOT NULL DEFAULT 0,
        'time' int NOT NULL DEFAULT 0,
        'start_time' timestamp NULL DEFAULT NULL,
        'end_time' timestamp NULL DEFAULT NULL,
        'status' varchar(255)  NULL
      ) """);

      await db.execute("""CREATE TABLE 'mastery_courses' (
        id INTEGER PRIMARY KEY, 
        'study_id' int NOT NULL,
        'level' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' varchar(255) NOT NULL,
        'passed' tinyint(1) NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'mastery_courses_upgrade' (
        id INTEGER PRIMARY KEY, 
        'study_id' int NOT NULL,
        'level' int NOT NULL,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' varchar(255) NOT NULL,
        'passed' tinyint(1) NOT NULL DEFAULT '0',
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'review_test_taken' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'count' int NOT NULL,
        'completed' int NOT NULL,
        'topic_id' varchar(255) NOT NULL,
        'category' varchar(255) NOT NULL,
        'test_type' varchar(255) NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");

      await db.execute("""CREATE TABLE 'images' (
        id INTEGER PRIMARY KEY, 
        'name' varchar(255) NOT NULL,
        'base64' text NOT NULL
      )""");

      await db.execute("""CREATE TABLE 'glossary' (
        'id' varchar(255) NULL DEFAULT NULL,
        'course_id' int NOT NULL,
         'topic_id' int NOT NULL,
        'glossary' varchar(255) NOT NULL
        )""");
      await db.execute("""CREATE TABLE 'glossary_topic' (
           'id' varchar(255) NULL DEFAULT NULL,
        'course_id' int NOT NULL,
         'topic_id' int NOT NULL,
        'glossary' varchar(255) NOT NULL
        )""");

      await db.execute("""CREATE TABLE 'flag' (
        id INTEGER PRIMARY KEY, 
        'reason' varchar(255) NOT NULL,
        'type' varchar(255) NOT NULL,
        'question_id' int NOT NULL
      )""");

      await db.execute("""CREATE TABLE 'topic_analysis' (
        'id' INTEGER PRIMARY KEY,
        'name' varchar(255) NOT NULL,
        'topic_id' varchar(10) NOT NULL,
        'total_questions' int NOT NULL,
        'correctly_answered' double NOT NULL,
        'test_id' varchar(10) NOT NULL,
        'test_name' varchar(255) NOT NULL,
        'test_score' double NOT NULL
      ) """);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        // you can execute drop table and create table

        try {
          await db.execute("""DROP TABLE 'conquest_tests_taken'""");
          await db.execute("""CREATE TABLE 'conquest_tests_taken' (
            'id' INTEGER PRIMARY KEY,
            'user_id' int NOT NULL,
            'group_id' int DEFAULT NULL,
            'date_time' varchar(255) NOT NULL,
            'course_id' int NOT NULL,
            'topic_id' int DEFAULT NULL,
            'test_name' varchar(255) DEFAULT NULL,
            'test_type' varchar(255) DEFAULT NULL,
            'challenge_type' varchar(255) DEFAULT NULL,
            'test_id' int DEFAULT NULL,
            'test_time' int DEFAULT NULL,
            'used_time' int DEFAULT NULL,
            'pause_duration' int DEFAULT NULL,
            'total_questions' int NOT NULL,
            'score' double NOT NULL,
            'correct' int NOT NULL,
            'wrong' int NOT NULL,
            'unattempted' int NOT NULL,
            'responses' LONGTEXT NOT NULL,
            'comment' text DEFAULT NULL,
            'user_rank' int NULL,
            'total_rank' int NULL,
            'created_at' timestamp NULL DEFAULT NULL,
            'updated_at' timestamp NULL DEFAULT NULL
          ) """);
        } catch (e) {
        }
        try {
          await db.execute("""CREATE TABLE 'conquest_tests_taken' (
            'id' INTEGER PRIMARY KEY,
            'user_id' int NOT NULL,
            'group_id' int DEFAULT NULL,
            'date_time' varchar(255) NOT NULL,
            'course_id' int NOT NULL,
            'topic_id' int DEFAULT NULL,
            'test_name' varchar(255) DEFAULT NULL,
            'test_type' varchar(255) DEFAULT NULL,
            'challenge_type' varchar(255) DEFAULT NULL,
            'test_id' int DEFAULT NULL,
            'test_time' int DEFAULT NULL,
            'used_time' int DEFAULT NULL,
            'pause_duration' int DEFAULT NULL,
            'total_questions' int NOT NULL,
            'score' double NOT NULL,
            'correct' int NOT NULL,
            'wrong' int NOT NULL,
            'unattempted' int NOT NULL,
            'responses' LONGTEXT NOT NULL,
            'comment' text DEFAULT NULL,
            'user_rank' int NULL,
            'total_rank' int NULL,
            'created_at' timestamp NULL DEFAULT NULL,
            'updated_at' timestamp NULL DEFAULT NULL
          ) """);
        } catch (e) {

        }

        try{
          await db.execute("""DROP TABLE 'tests_taken'""");
          await db.execute("""CREATE TABLE 'tests_taken' (
        'id' INTEGER PRIMARY KEY,
        'user_id' int NOT NULL,
        'group_id' int DEFAULT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'challenge_type' varchar(255) DEFAULT NULL,
        'topic_id' int DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);
        }catch(e){
          await db.execute("""CREATE TABLE 'tests_taken' (
        'id' INTEGER PRIMARY KEY,
        'user_id' int NOT NULL,
        'group_id' int DEFAULT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'challenge_type' varchar(255) DEFAULT NULL,
        'topic_id' int DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);
        }

        try {
          await db.execute("""DROP TABLE 'test_saved_questions'""");
          await db.execute("""CREATE TABLE 'test_saved_questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'time' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0'
      ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'test_saved_questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'time' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0'
      ) """);
        }
        try {
          await db.execute("""DROP TABLE 'keyword_test_taken'""");
          await db.execute("""CREATE TABLE 'keyword_test_taken' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'user_id' int NOT NULL,
        'group_id' int DEFAULT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'challenge_type' varchar(255) DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'keyword_test_taken' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'user_id' int NOT NULL,
        'group_id' int DEFAULT NULL,
        'date_time' varchar(255) NOT NULL,
        'course_id' int NOT NULL,
        'topic_id' int DEFAULT NULL,
        'test_name' varchar(255) DEFAULT NULL,
        'test_type' varchar(255) DEFAULT NULL,
        'challenge_type' varchar(255) DEFAULT NULL,
        'test_id' int DEFAULT NULL,
        'test_time' int DEFAULT NULL,
        'used_time' int DEFAULT NULL,
        'pause_duration' int DEFAULT NULL,
        'total_questions' int NOT NULL,
        'score' double NOT NULL,
        'correct' int NOT NULL,
        'wrong' int NOT NULL,
        'unattempted' int NOT NULL,
        'responses' LONGTEXT NOT NULL,
        'comment' text DEFAULT NULL,
        'user_rank' int NULL,
        'total_rank' int NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      ) """);
        }
        try {
          await db.execute("""DROP TABLE 'review_test_taken'""");
          await db.execute("""CREATE TABLE 'review_test_taken' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'count' int NOT NULL,
        'completed' int NOT NULL,
        'topic_id' varchar(255) NOT NULL,
        'category' varchar(255) NOT NULL,
        'test_type' varchar(255) NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");
        } catch (e) {
          await db.execute("""CREATE TABLE 'review_test_taken' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'count' int NOT NULL,
        'completed' int NOT NULL,
        'topic_id' varchar(255) NOT NULL,
        'category' varchar(255) NOT NULL,
        'test_type' varchar(255) NOT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");
        }

        try {
          await db.execute("""DROP TABLE 'flag'""");
          await db.execute("""CREATE TABLE 'flag' (
            id INTEGER PRIMARY KEY, 
            'reason' varchar(255) NOT NULL,
            'type' varchar(255) NOT NULL,
            'question_id' int NOT NULL
          )""");
        } catch (e) {
          await db.execute("""CREATE TABLE 'flag' (
            id INTEGER PRIMARY KEY, 
            'reason' varchar(255) NOT NULL,
            'type' varchar(255) NOT NULL,
            'question_id' int NOT NULL
          )""");
        }
        try {
          await db.execute("""DROP TABLE 'topic_analysis'""");
          await db.execute("""CREATE TABLE 'topic_analysis' (
        'id' INTEGER PRIMARY KEY,
        'name' varchar(255) NOT NULL,
        'topic_id' varchar(10) NOT NULL,
        'total_questions' int NOT NULL,
        'correctly_answered' double NOT NULL,
        'test_id' varchar(10) NOT NULL,
        'test_name' varchar(255) NOT NULL,
        'test_score' double NOT NULL
      ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'topic_analysis' (
        'id' INTEGER PRIMARY KEY,
        'name' varchar(255) NOT NULL,
        'topic_id' varchar(10) NOT NULL,
        'total_questions' int NOT NULL,
        'correctly_answered' double NOT NULL,
        'test_id' varchar(10) NOT NULL,
        'test_name' varchar(255) NOT NULL,
        'test_score' double NOT NULL
      ) """);
        }

        try {
          await db.execute("""DROP TABLE 'treadmills'""");
          await db.execute("""CREATE TABLE 'treadmills' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'title' varchar(255)  NOT NULL,
        'type' varchar(255)  NOT NULL,
        'bank_id' int NULL,
        'topic_id' int NULL,
        'avg_score' double NOT NULL DEFAULT 0,
        'avg_time' double NOT NULL DEFAULT 0,
        'total_questions' int NULL DEFAULT 0,
        'total_correct' int NULL DEFAULT 0,
        'total_wrong' int NULL DEFAULT 0,
        'total_time' int NULL DEFAULT 0,
        'status' varchar(255)  NOT NULL,
        'duration' int NULL,
        'start_time' timestamp NULL DEFAULT NULL,
        'end_time' timestamp NULL DEFAULT NULL
      )""");
        } catch (e) {
          print(e.toString());
          await db.execute("""CREATE TABLE 'treadmills' (
        id INTEGER PRIMARY KEY, 
        'user_id' int NOT NULL,
        'course_id' int NOT NULL,
        'title' varchar(255)  NOT NULL,
        'type' varchar(255)  NOT NULL,
        'bank_id' int NULL,
        'topic_id' int NULL,
        'avg_score' double NOT NULL DEFAULT 0,
        'avg_time' double NOT NULL DEFAULT 0,
        'total_questions' int NOT NULL DEFAULT 0,
        'total_correct' int NOT NULL DEFAULT 0,
        'total_wrong' int NOT NULL DEFAULT 0,
        'total_time' int NOT NULL DEFAULT 0,
        'status' varchar(255)  NOT NULL,
        'duration' int NULL,
        'start_time' timestamp NULL DEFAULT NULL,
        'end_time' timestamp NULL DEFAULT NULL
      )""");
        }

        try {
          await db.execute("""DROP TABLE 'treadmill_progress'""");

          await db.execute("""CREATE TABLE 'treadmill_progress' (
        id INTEGER PRIMARY KEY, 
        'treadmill_id' int NOT NULL,
        'question_id' int NOT NULL,
        'course_id' int NOT NULL,
        'user_id' int NOT NULL,
        'topic_id' int NULL,
        'bank_id' int NULL,
        'topic_name' varchar(255)  NULL,
        'selected_answer_id' int NULL,
         'time' int NULL DEFAULT 0,
        'status' varchar(255)  NULL
      ) """);
        } catch (e) {
          print(e.toString());
          await db.execute("""CREATE TABLE 'treadmill_progress' (
        id INTEGER PRIMARY KEY, 
        'treadmill_id' int NOT NULL,
        'question_id' int NOT NULL,
        'course_id' int NOT NULL,
        'user_id' int NOT NULL,
        'topic_id' int NULL,
        'bank_id' int NULL,
        'topic_name' varchar(255)  NULL,
        'selected_answer_id' int NULL,
         'time' int NULL DEFAULT 0,
        'status' varchar(255)  NULL
      ) """);
        }
        try {
          await db.execute("""DROP TABLE 'plan_items'""");
          await db.execute("""CREATE TABLE 'plan_items' (
          'id' INTEGER PRIMARY KEY,
          'tag' varchar(255) NOT NULL,
          'plan_id' int unsigned NOT NULL,
          'question_count' int unsigned NOT NULL,
          'quiz_count' int unsigned NOT NULL,
          'topic_count' int unsigned NOT NULL,
          'name' varchar(255) NOT NULL,
          'description' varchar(255) DEFAULT NULL,
          'value' varchar(255) NOT NULL,
          'resettable_period' smallint unsigned NOT NULL DEFAULT '0',
          'resettable_interval' varchar(255) NOT NULL DEFAULT 'month',
          'sort_order' mediumint unsigned NOT NULL DEFAULT '0',
          'created_at' timestamp NULL DEFAULT NULL,
          'updated_at' timestamp NULL DEFAULT NULL
        ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'plan_items' (
          'id' INTEGER PRIMARY KEY,
          'tag' varchar(255) NOT NULL,
          'plan_id' int unsigned NOT NULL,
          'question_count' int unsigned NOT NULL,
          'quiz_count' int unsigned NOT NULL,
          'topic_count' int unsigned NOT NULL,
          'name' varchar(255) NOT NULL,
          'description' varchar(255) DEFAULT NULL,
          'value' varchar(255) NOT NULL,
          'resettable_period' smallint unsigned NOT NULL DEFAULT '0',
          'resettable_interval' varchar(255) NOT NULL DEFAULT 'month',
          'sort_order' mediumint unsigned NOT NULL DEFAULT '0',
          'created_at' timestamp NULL DEFAULT NULL,
          'updated_at' timestamp NULL DEFAULT NULL
        ) """);
        }

        try {
          await db.execute("""DROP TABLE 'plans'""");
          await db.execute("""CREATE TABLE 'plans' (
          'id' INTEGER PRIMARY KEY,
          'tag' varchar(255)  NOT NULL,
          'name' varchar(255)  NOT NULL,
          'description' varchar(255)  DEFAULT NULL,
          'is_active' tinyint(1) NOT NULL DEFAULT '1',
          'user_subscribed' tinyint(1) NOT NULL DEFAULT '1',
          'price' decimal(8,2) NOT NULL DEFAULT '0.00',
          'signup_fee' decimal(8,2) NOT NULL DEFAULT '0.00',
          'currency' varchar(3)  NOT NULL,
          'trial_period' smallint unsigned NOT NULL DEFAULT '0',
          'trial_interval' varchar(255)  NOT NULL DEFAULT 'day',
          'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
          'invoice_interval' varchar(255)  NOT NULL DEFAULT 'month',
          'tier' mediumint unsigned NOT NULL DEFAULT '0',
          'created_at' timestamp NULL DEFAULT NULL,
          'updated_at' timestamp NULL DEFAULT NULL
        ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'plans' (
          'id' INTEGER PRIMARY KEY,
          'tag' varchar(255)  NOT NULL,
          'name' varchar(255)  NOT NULL,
          'description' varchar(255)  DEFAULT NULL,
          'is_active' tinyint(1) NOT NULL DEFAULT '1',
          'user_subscribed' tinyint(1) NOT NULL DEFAULT '1',
          'price' decimal(8,2) NOT NULL DEFAULT '0.00',
          'signup_fee' decimal(8,2) NOT NULL DEFAULT '0.00',
          'currency' varchar(3)  NOT NULL,
          'trial_period' smallint unsigned NOT NULL DEFAULT '0',
          'trial_interval' varchar(255)  NOT NULL DEFAULT 'day',
          'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
          'invoice_interval' varchar(255)  NOT NULL DEFAULT 'month',
          'tier' mediumint unsigned NOT NULL DEFAULT '0',
          'created_at' timestamp NULL DEFAULT NULL,
          'updated_at' timestamp NULL DEFAULT NULL
        ) """);
        }

        try {
          await db.execute("""DROP TABLE 'subscription_items'""");
          await db.execute("""CREATE TABLE 'subscription_items' (
          'id' INTEGER PRIMARY KEY,
          'tag' varchar(255) NOT NULL,
          'plan_id' int unsigned NOT NULL,
          'question_count' int unsigned NOT NULL,
          'quiz_count' int unsigned NOT NULL,
          'topic_count' int unsigned NOT NULL,
          'name' varchar(255) NOT NULL,
          'description' varchar(255) DEFAULT NULL,
          'value' varchar(255) NOT NULL,
          'resettable_period' smallint unsigned NOT NULL DEFAULT '0',
          'resettable_interval' varchar(255) NOT NULL DEFAULT 'month',
          'sort_order' mediumint unsigned NOT NULL DEFAULT '0',
          'created_at' timestamp NULL DEFAULT NULL,
          'updated_at' timestamp NULL DEFAULT NULL
        ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'subscription_items' (
          'id' INTEGER PRIMARY KEY,
          'tag' varchar(255) NOT NULL,
          'plan_id' int unsigned NOT NULL,
          'question_count' int unsigned NOT NULL,
          'quiz_count' int unsigned NOT NULL,
          'topic_count' int unsigned NOT NULL,
          'name' varchar(255) NOT NULL,
          'description' varchar(255) DEFAULT NULL,
          'value' varchar(255) NOT NULL,
          'resettable_period' smallint unsigned NOT NULL DEFAULT '0',
          'resettable_interval' varchar(255) NOT NULL DEFAULT 'month',
          'sort_order' mediumint unsigned NOT NULL DEFAULT '0',
          'created_at' timestamp NULL DEFAULT NULL,
          'updated_at' timestamp NULL DEFAULT NULL
        ) """);
        }
        try {
          await db.execute("""DROP TABLE 'subscriptions'""");
          await db.execute("""CREATE TABLE 'subscriptions' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255) NOT NULL,
        'subscriber_type' varchar(255) NOT NULL,
        'subscriber_id' bigint unsigned NOT NULL,
        'plan_id' int unsigned DEFAULT NULL,
        'name' varchar(255) DEFAULT NULL,
        'description' varchar(255) DEFAULT NULL,
        'price' decimal(8,2) NOT NULL DEFAULT '0.00',
        'currency' varchar(3) NOT NULL,
        'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
        'invoice_interval' varchar(255) NOT NULL DEFAULT 'month',
        'tier' mediumint unsigned NOT NULL DEFAULT '0',
        'trial_ends_at' timestamp NULL DEFAULT NULL,
        'starts_at' timestamp NULL DEFAULT NULL,
        'ends_at' timestamp NULL DEFAULT NULL,
        'cancels_at' timestamp NULL DEFAULT NULL,
        'canceled_at' timestamp NULL DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");
        } catch (e) {
          await db.execute("""CREATE TABLE 'subscriptions' (
        'id' INTEGER PRIMARY KEY,
        'tag' varchar(255) NOT NULL,
        'subscriber_type' varchar(255) NOT NULL,
        'subscriber_id' bigint unsigned NOT NULL,
        'plan_id' int unsigned DEFAULT NULL,
        'name' varchar(255) DEFAULT NULL,
        'description' varchar(255) DEFAULT NULL,
        'price' decimal(8,2) NOT NULL DEFAULT '0.00',
        'currency' varchar(3) NOT NULL,
        'invoice_period' smallint unsigned NOT NULL DEFAULT '1',
        'invoice_interval' varchar(255) NOT NULL DEFAULT 'month',
        'tier' mediumint unsigned NOT NULL DEFAULT '0',
        'trial_ends_at' timestamp NULL DEFAULT NULL,
        'starts_at' timestamp NULL DEFAULT NULL,
        'ends_at' timestamp NULL DEFAULT NULL,
        'cancels_at' timestamp NULL DEFAULT NULL,
        'canceled_at' timestamp NULL DEFAULT NULL,
        'created_at' timestamp NULL DEFAULT NULL,
        'updated_at' timestamp NULL DEFAULT NULL
      )""");
        }
        try {
          await db.execute("""DROP TABLE 'questions'""");
          await db.execute("""CREATE TABLE 'questions' (
          'id' INTEGER PRIMARY KEY,
          'course_id' int NOT NULL,
          'topic_id' int NOT NULL,
          'topic_name' text NULL,
          'qid' varchar(50) NOT NULL,
          'text' text NOT NULL,
          'instructions' text NOT NULL,
          'resource' text NOT NULL,
          'options' text NOT NULL,
          'position' int NOT NULL,
          'time' int NOT NULL,
          'created_at' datetime NOT NULL,
          'updated_at' datetime NOT NULL,
          'qtype' varchar(10) DEFAULT 'SINGLE',
          'confirmed' int NOT NULL DEFAULT '0',
          'public' int NOT NULL DEFAULT '0',
          'flagged' int NOT NULL DEFAULT '0',
          'deleted' int NOT NULL DEFAULT '0'
        ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'questions' (
          'id' INTEGER PRIMARY KEY,
          'course_id' int NOT NULL,
          'topic_id' int NOT NULL,
          'topic_name' text NULL,
          'qid' varchar(50) NOT NULL,
          'text' text NOT NULL,
          'instructions' text NOT NULL,
          'resource' text NOT NULL,
          'options' text NOT NULL,
          'position' int NOT NULL,
          'time' int NOT NULL,
          'created_at' datetime NOT NULL,
          'updated_at' datetime NOT NULL,
          'qtype' varchar(10) DEFAULT 'SINGLE',
          'confirmed' int NOT NULL DEFAULT '0',
          'public' int NOT NULL DEFAULT '0',
          'flagged' int NOT NULL DEFAULT '0',
          'deleted' int NOT NULL DEFAULT '0'
        ) """);
        }
        try {
          await db.execute("""DROP TABLE 'conquest_questions'""");
          await db.execute("""CREATE TABLE 'conquest_questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'time' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0'
      ) """);
        } catch (e) {
          await db.execute("""CREATE TABLE 'conquest_questions' (
        'id' INTEGER PRIMARY KEY,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'topic_name' text NULL,
        'qid' varchar(50) NOT NULL,
        'text' text NOT NULL,
        'instructions' text NOT NULL,
        'resource' text NOT NULL,
        'options' text NOT NULL,
        'position' int NOT NULL,
        'time' int NOT NULL,
        'created_at' datetime NOT NULL,
        'updated_at' datetime NOT NULL,
        'qtype' varchar(10) DEFAULT 'SINGLE',
        'confirmed' int NOT NULL DEFAULT '0',
        'public' int NOT NULL DEFAULT '0',
        'flagged' int NOT NULL DEFAULT '0',
        'deleted' int NOT NULL DEFAULT '0'
      ) """);
        }

        try{
          await db.execute("""DROP TABLE 'glossary'""");
          await db.execute("""CREATE TABLE 'glossary' (
        'id' varchar(255) NULL DEFAULT NULL,
        'course_id' int NOT NULL,
         'topic_id' int NOT NULL,
        'glossary' varchar(255) NOT NULL
        )""");
        }catch(e){
          await db.execute("""CREATE TABLE 'glossary' (
        'id' varchar(255) NULL DEFAULT NULL,
        'course_id' int NOT NULL,
         'topic_id' int NOT NULL,
        'glossary' varchar(255) NOT NULL
        )""");
        }
        try{
          await db.execute("""DROP TABLE 'glossary_topic'""");
          await db.execute("""CREATE TABLE 'glossary_topic' (
            'id' varchar(255) NULL DEFAULT NULL,
        'course_id' int NOT NULL,
         'topic_id' int NOT NULL,
        'glossary' varchar(255) NOT NULL
        )""");
        }catch(e){
          await db.execute("""CREATE TABLE 'glossary_topic' (
            'id' varchar(255) NULL DEFAULT NULL,
        'course_id' int NOT NULL,
        'topic_id' int NOT NULL,
        'glossary' varchar(255) NOT NULL
        )""");
        }

        try{
          await db.execute("""DROP TABLE 'glossary_study_progress'""");
          await db.execute("""CREATE TABLE 'glossary_study_progress' (
         'id' int NOT NULL,
        'search_term' varchar(50) NOT NULL,
        'selected_character' varchar(50) NOT NULL,
        'course_id' INTEGER NOT NULL,
        'correct' INTEGER NOT NULL,
        'wrong' INTEGER NOT NULL,
        'count' INTEGER NOT NULL,
        'progress_index' INTEGER NOT NULL,
        'topic_id' INTEGER NULL DEFAULT NULL
      ) """);
        }catch(e){
          await db.execute("""CREATE TABLE 'glossary_study_progress' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'search_term' varchar(50) NOT NULL,
        'selected_character' varchar(50) NOT NULL,
        'course_id' INTEGER NOT NULL,
        'correct' INTEGER NOT NULL,
        'wrong' INTEGER NOT NULL,
        'count' INTEGER NOT NULL,
        'progress_index' INTEGER NOT NULL,
        'topic_id' INTEGER NULL DEFAULT NULL
      ) """);
        }

        try{
          await db.execute("""DROP TABLE 'glossary_try_progress'""");
          await db.execute("""CREATE TABLE 'glossary_try_progress' (
        'id' int NOT NULL,
        'search_term' varchar(50) NOT NULL,
        'selected_character' varchar(50) NOT NULL,
        'course_id' INTEGER NOT NULL,
        'correct' INTEGER NOT NULL,
        'wrong' INTEGER NOT NULL,
        'count' INTEGER NOT NULL,
        'progress_index' INTEGER NOT NULL,
        'topic_id' INTEGER NULL DEFAULT NULL
      ) """);
        }catch(e){
          await db.execute("""CREATE TABLE 'glossary_try_progress' (
         'id' int NOT NULL,
        'search_term' varchar(50) NOT NULL,
        'selected_character' varchar(50) NOT NULL,
        'course_id' INTEGER NOT NULL,
        'correct' INTEGER NOT NULL,
        'wrong' INTEGER NOT NULL,
        'count' INTEGER NOT NULL,
        'progress_index' INTEGER NOT NULL,
        'topic_id' INTEGER NULL DEFAULT NULL
      ) """);
        }
      }
    });
  }
}
