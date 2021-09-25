import 'dart:convert';

import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/providers/database.dart';
import 'package:sqflite/sqflite.dart';

class SubscriptionDB {
  Future<void> insert(Subscription subscription) async {
    if (subscription == null) {
      return;
    }
    final Database? db = await DBProvider.database;

    await db!.insert(
      'subscriptions',
      subscription.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Subscription?> getMessageById(int id) async {
    final db = await DBProvider.database;
    var result =
        await db!.query("subscriptions", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Subscription.fromJson(result.first) : null;
  }

  Future<void> insertAll(List<Subscription> subscriptions) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    subscriptions.forEach((element) {
      batch.insert(
        'subscriptions',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<List<Subscription>> subscriptions() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps =
        await db!.query('subscriptions', orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Subscription(
        id: maps[i]["id"],
        tag: maps[i]["tag"],
        name: maps[i]["name"],
        description: maps[i]["description"],
        planId: maps[i]["plan_id"],
        subscriberId: maps[i]["subscription_id"],
        price: maps[i]["price"],
        subscriberType: maps[i]["subscriber_type"],
        currency: maps[i]["currency"],
        canceledAt: maps[i]["canceled_at"],
        cancelsAt: maps[i]["cancels_at"],
        invoiceInterval: maps[i]["invoice_interval"],
        invoicePeriod: maps[i]["invoice_period"],
        tier: maps[i]['tier'],
        trialEndsAt: DateTime.parse(maps[i]["trial_ends_at"]),
        startsAt: DateTime.parse(maps[i]["starts_at"]),
        endsAt: DateTime.parse(maps[i]["ends_at"]),
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
      );
    });
  }

  Future<void> update(Subscription subscription) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'subscriptions',
      subscription.toJson(),
      where: "id = ?",
      whereArgs: [subscription.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'subscriptions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
