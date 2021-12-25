import 'dart:convert';
import 'dart:html';

import 'package:ecoach/models/image.dart';
import 'package:ecoach/database/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ImageFileDB {
  // Future<void> insert(ImageFile image) async {
  //   if (image == null) {
  //     return;
  //   }
  //   final Database? db = await DBProvider.database;
  //   await db!.transaction((txn) async {
  //     Batch batch = txn.batch();
  //     batch.insert(
  //       'images',
  //       image.toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );

  //     batch.commit();
  //   });
  // }

  Future<String?> getImageFile(String name) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("images", where: "name = ?", whereArgs: [name]);
    ImageFile? image;
    if (result.isNotEmpty) {
      image = ImageFile.fromJson(result.first);
    }
    return image!.base64!;
  }

  delete(String name) async {
    final db = await DBProvider.database;
    db!.delete(
      'images',
      where: "name = ?",
      whereArgs: [name],
    );
  }
}
