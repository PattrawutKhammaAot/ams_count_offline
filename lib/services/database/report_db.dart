import 'dart:convert';

import 'package:count_offline/main.dart';
import 'package:count_offline/model/report/ViewReportListPlan.dart';
import 'package:sqflite/sqflite.dart';

class ReportDB {
  String tableName = 'ImportMaster';
  Future<List<ViewReportListPlan>> getList() async {
    final db = await appDb.database;
    final resultPlan =
        await db.query(tableName, distinct: true, columns: ['Plan']);

    // Extract the list of plans
    final plans = resultPlan.map((row) => row['Plan']).toList();

    final List<ViewReportListPlan> planReturn = [];

    for (var plan in plans) {
      final countPlanCheck = await db.rawQuery(
          'SELECT COUNT(*) FROM $tableName WHERE Status_Check = ? AND Plan = ?',
          [status_checked, plan]);
      print("Test ${countPlanCheck}");
      final countPlanUncheck = await db.rawQuery(
          'SELECT COUNT(*) FROM $tableName WHERE Status_Check = ? AND Plan = ?',
          [status_uncheck, plan]);

      final totalCheck = Sqflite.firstIntValue(countPlanCheck);
      final totalUncheck = Sqflite.firstIntValue(countPlanUncheck);

      planReturn.add(ViewReportListPlan(
        plan: plan.toString(),
        uncheck: totalUncheck,
        check: totalCheck,
      ));
    }

    return planReturn;
  }
}
