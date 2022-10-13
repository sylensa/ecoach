import 'dart:convert';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/review_taken.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class ConquestTestTakenDB {
  Future<int> conquestInsert(TestTaken testTaken) async {
    final Database? db = await DBProvider.database;

    int id = await db!.insert(
      'conquest_tests_taken',
      testTaken.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }


  conquestDeleteAll() async {
    final db = await DBProvider.database;
    db!.delete(
      'conquest_tests_taken'
    );
  }


}
