import 'dart:convert';

import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/models/get_bundle_plan.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/subscription_item_db.dart';
import 'package:sqflite/sqflite.dart';

class PlanDB {
  Future<void> insert(SubscriptionItem bundleByPlanData) async {
    if (bundleByPlanData == null) {
      return;
    }
    final Database? db = await DBProvider.database;
    await db!.insert(
      'plan_items',
      bundleByPlanData.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertAll(List<Plan> plans) async {
    print("insert all plans");
    final Database? db = await DBProvider.database;
    await db!.transaction((txn) async {
      for (int i = 0; i < plans.length; i++) {
        Plan element = plans[i];
        await txn.insert(
          'plans',
          element.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<Plan>> getAllPlans() async {
    final Database? db = await DBProvider.database;
    List<Plan> plans = [];
    final List<Map<String, dynamic>> maps = await db!.query('plans', orderBy: "created_at DESC");
    for(int i = 0; i < maps.length; i++){
      if(maps[i].isNotEmpty){
        Plan plan = Plan.fromJson(maps[i]);
        plans.add(plan);
      }
    }
    print("plans:${plans.length}");
    return plans;

  }

  Future<List<SubscriptionItem>> planItems(int planId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
        'plan_items',
        orderBy: "name ASC",
        where: "plan_id = ?",
        whereArgs: [planId]);
    List<SubscriptionItem> items = [];
    for(int i =0; i < maps.length; i++){
      SubscriptionItem subscriptionItem = SubscriptionItem.fromJson(maps[i]);
      items.add(subscriptionItem);
    }
    return items;
  }

  deleteAllPlans() async {
    final db = await DBProvider.database;
    db!.delete(
      'plans',
    );
  }
  deleteAllPlanItem() async {
    final db = await DBProvider.database;
    db!.delete(
      'plan_items',
    );
  }
}
