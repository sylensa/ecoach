import 'package:ecoach/database/database.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/new_ui_ben/providers/welcome_screen_provider.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/course_completion_study_progress.dart';
import '../models/revision_study_progress.dart';
import '../models/speed_enhancement_progress_model.dart';

class StudyDB {
  Future<void> insert(Study study) async {
    // print(study.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'studies',
        study.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> insertProgress(StudyProgress progress) async {
    // print(study.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'study_progress',
        progress.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<Study?> getStudyById(int id) async {
    final db = await DBProvider.database;

    var result = await db!.query("studies", where: "id = ?", whereArgs: [id]);
    Study? study = result.isNotEmpty ? Study.fromJson(result.first) : null;

    return study;
  }

  Future<Study?> getStudyByType(int courseId, StudyType type) async {
    final db = await DBProvider.database;

    var result = await db!.query("studies",
        where: "course_id= ? AND type = ?",
        whereArgs: [courseId, type.toString()]);
    Study? study = result.isNotEmpty ? Study.fromJson(result.first) : null;

    return study;
  }

  Future<StudyProgress?> getStudyProgress(int courseId, int level) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('study_progress',
        orderBy: "name ASC",
        where: "course_id = ? AND level= ?",
        whereArgs: [courseId, level]);

    if (level > maps.length || level < 1) {
      return null;
    }

    return StudyProgress.fromJson(maps[level - 1]);
  }

  Future<List<StudyProgress>> getProgress(int studyId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('study_progress',
        orderBy: "name ASC", where: "study_id = ?", whereArgs: [studyId]);

    List<StudyProgress> studies = [];
    for (int i = 0; i < maps.length; i++) {
      StudyProgress progress = StudyProgress.fromJson(maps[i]);
      studies.add(progress);
    }
    return studies;
  }

  Future<StudyProgress?> getCurrentProgress(int studyId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('study_progress',
        orderBy: "created_at DESC",
        where: "study_id = ?",
        whereArgs: [studyId],
        limit: 1);

    StudyProgress? progress =
        result.isNotEmpty ? StudyProgress.fromJson(result.first) : null;
    return progress;
  }

  Future<void> insertAll(List<Study> studies) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    studies.forEach((element) {
      // print(element.toJson());
      batch.insert(
        'studies',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Study>> studies() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('studies', orderBy: "name ASC");

    List<Study> studies = [];
    for (int i = 0; i < maps.length; i++) {
      Study study = Study.fromJson(maps[i]);
      studies.add(study);
    }
    return studies;
  }

  Future<List<Study>> courseTopics(Course course) async {
    final Database? db = await DBProvider.database;
    print("course id = ${course.id}");
    final List<Map<String, dynamic>> maps = await db!.query('studies',
        orderBy: "name ASC",
        where: "course_id = ? AND notes <> '' ",
        whereArgs: [course.id]);

    print('course len=${maps.length}');
    List<Study> studies = [];
    for (int i = 0; i < maps.length; i++) {
      Study study = Study.fromJson(maps[i]);
      studies.add(study);
    }
    return studies;
  }

  Future<Study?> courseLastStudy(int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('studies',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId]);

    return result.isNotEmpty ? Study.fromJson(result.last) : null;
  }

  Future<void> update(Study study) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'studies',
      study.toJson(),
      where: "id = ?",
      whereArgs: [study.id],
    );
  }

  Future<void> updateProgress(StudyProgress progress) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'study_progress',
      progress.toJson(),
      where: "id = ?",
      whereArgs: [progress.id],
    );

    Provider.of<WelcomeScreenProvider>(Get.context!, listen: false)
        .setCurrentProgress(progress);
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'studies',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // revision progress
  Future<void> insertRevisionProgress(RevisionStudyProgress revision) async {
    final db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert("revision_study_progress", revision.toMap());
    }).then((value) {
      print("revision was added");
    }).catchError((e) {
      print("this is the error $e");
    });
  }

  Future<void> updateRevisionProgress(RevisionStudyProgress revision) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'revision_study_progress',
      revision.toMap(),
      where: "id = ?",
      whereArgs: [revision.id],
    );
  }

  Future<RevisionStudyProgress?> getCurrentRevisionProgress() async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('revision_study_progress',
        orderBy: "created_at DESC",
        // where: "study_id = ?",
        // whereArgs: [revisionId],
        limit: 1);

    RevisionStudyProgress? progress =
        result.isNotEmpty ? RevisionStudyProgress.fromMap(result.first) : null;
    return progress;
  }

  Future<RevisionStudyProgress?> getCurrentRevisionProgressByCourse(
      int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('revision_study_progress',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId],
        limit: 1);

    RevisionStudyProgress? progress =
        result.isNotEmpty ? RevisionStudyProgress.fromMap(result.first) : null;
    return progress;
  }
  // speed progress level db functions
  Future<void> insertSpeedProgressLevel(SpeedStudyProgress revision) async {
    final db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert("speed_study_level", revision.toMap());
    }).then((value) {
      print("revision was added");
    }).catchError((e) {
      print("this is the error $e");
    });
  }

  Future<void> updateSpeedProgressLevel(SpeedStudyProgress revision) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'speed_study_level',
      revision.toMap(),
      where: "id = ?",
      whereArgs: [revision.id],
    );
  }

  Future<SpeedStudyProgress?> getCurrentSpeedProgressLevel() async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('speed_study_level',
        orderBy: "created_at DESC",
        // where: "study_id = ?",
        // whereArgs: [revisionId],
        limit: 1);

    SpeedStudyProgress? progress =
        result.isNotEmpty ? SpeedStudyProgress.fromMap(result.first) : null;
    return progress;
  }

  Future<SpeedStudyProgress?> getCurrentSpeedProgressLevelByCourse(
      int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('speed_study_level',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId],
        limit: 1);

    SpeedStudyProgress? progress =
        result.isNotEmpty ? SpeedStudyProgress.fromMap(result.first) : null;
    return progress;
  }

  // revision progress
  Future<void> insertCourseCompletionProgress(
      CourseCompletionStudyProgress revision) async {
    final db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert("course_completion_study_progress", revision.toMap());
    });
  }

  Future<void> updateCourseCompletionProgress(
      CourseCompletionStudyProgress revision) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'course_completion_study_progress',
      revision.toMap(),
      where: "id = ?",
      whereArgs: [revision.id],
    );
  }

  Future<RevisionStudyProgress?> getCurrentCourseCompletionProgress(
      int revisionId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('course_completion_study_progress',
        orderBy: "created_at DESC",
        // where: "study_id = ?",
        // whereArgs: [revisionId],
        limit: 1);

    RevisionStudyProgress? progress =
        result.isNotEmpty ? RevisionStudyProgress.fromMap(result.first) : null;
    return progress;
  }

   Future<CourseCompletionStudyProgress?> getCurrentCourseCompletionProgressByCourse(
      int courseId) async {
    final Database? db = await DBProvider.database;

    var result = await db!.query('course_completion_study_progress',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId],
        limit: 1);

    CourseCompletionStudyProgress? progress =
        result.isNotEmpty ? CourseCompletionStudyProgress.fromMap(result.first) : null;
    return progress;
  }
}
