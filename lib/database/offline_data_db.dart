import 'package:ecoach/database/database.dart';
import 'package:ecoach/models/offline_data.dart';
import 'package:sqflite/sqflite.dart';

class OfflineDataDB {
  Future<void> insert(OfflineData offlineData) async {
    final Database? db = await DBProvider.database;

    await db!.insert(
      'offline_data',
      offlineData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<OfflineData?> getDataById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("offline_data", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? OfflineData.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<OfflineData> offline_data) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    offline_data.forEach((element) {
      batch.insert(
        'offline_data',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<OfflineData>> offlineData() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('offline_data', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return OfflineData(
        id: maps[i]["id"],
        dataId: maps[i]["data_id"],
        dataType: maps[i]["data_type"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
      );
    });
  }

  Future<List<OfflineData>> dataByType(String type) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!
        .query('offline_data', where: 'data_type = ?', whereArgs: [type]);

    return List.generate(maps.length, (i) {
      return OfflineData(
        id: maps[i]["id"],
        dataId: maps[i]["data_id"],
        dataType: maps[i]["data_type"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
      );
    });
  }

  Future<void> update(OfflineData offlineData) async {
    final db = await DBProvider.database;

    await db!.update(
      'offline_data',
      offlineData.toJson(),
      where: "id = ?",
      whereArgs: [offlineData.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'offline_data',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
