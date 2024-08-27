import 'dart:convert';
import 'dart:io';

import 'package:count_offline/main.dart';
import 'package:count_offline/model/count/ViewSumStatusModel.dart';
import 'package:count_offline/model/importModel/view_Import_Model.dart';
import 'package:count_offline/model/importModel/view_import_detail_Model.dart';
import 'package:count_offline/services/database/quickType.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqflite.dart';

class ImportDB {
  String tableName = 'ImportMaster';
  String plan = 'Plan';
  String asset = 'Asset';
  String description = 'Description';
  String costCenter = 'CostCenter';
  String Capitalized_on = 'Capitalized_on';
  String location = 'Location';
  String department = 'Department';
  String asset_Owner = 'Asset_Owner';
  String created_date = 'created_date';
  String user_def_1 = 'User_def_1';
  String user_def_2 = 'User_def_2';
  String user_def_3 = 'User_def_3';
  String user_def_4 = 'User_def_4';
  String status_check = 'Status_Check';
  String scan_date = 'Scan_Date';
  String count_location = 'count_location';
  String count_department = 'count_department';
  String remark = 'remark';
  String asset_not_in_plan = 'asset_not_in_plan';
  String file_image = 'file_image';
  String status_plan = 'status_plan';

  createTable(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName ('
        '${QuickTypes.ID_PRIMARYKEY},'
        '$plan ${QuickTypes.TEXT},'
        '$asset ${QuickTypes.TEXT},'
        '$description ${QuickTypes.TEXT},'
        '$costCenter ${QuickTypes.TEXT},'
        '$Capitalized_on ${QuickTypes.TEXT},'
        '$location ${QuickTypes.TEXT},'
        '$department ${QuickTypes.TEXT},'
        '$asset_Owner ${QuickTypes.TEXT},'
        '$created_date ${QuickTypes.TEXT},'
        '$status_check ${QuickTypes.TEXT},'
        '$scan_date ${QuickTypes.TEXT},'
        '$count_location ${QuickTypes.TEXT},'
        '$count_department ${QuickTypes.TEXT},'
        '$remark ${QuickTypes.TEXT},'
        '$asset_not_in_plan ${QuickTypes.TEXT},'
        '$file_image BLOB,'
        '$status_plan ${QuickTypes.TEXT},'
        '$user_def_1 ${QuickTypes.TEXT},'
        '$user_def_2 ${QuickTypes.TEXT},'
        '$user_def_3 ${QuickTypes.TEXT},'
        '$user_def_4 ${QuickTypes.TEXT}'
        ')');
  }

  Future importFileExcel() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        EasyLoading.show(
            status: 'Importing...', maskType: EasyLoadingMaskType.black);
        final String excelPath = result.files.single.path!;

        final bytes = File(excelPath).readAsBytesSync();
        final excel = Excel.decodeBytes(bytes);

        final List<List<dynamic>> excelData = [];

        for (var table in excel.tables.keys) {
          final sheet = excel.tables[table];
          if (sheet != null) {
            for (var row in sheet.rows) {
              final List<dynamic> rowData =
                  row.map((cell) => cell?.value).toList();
              excelData.add(rowData);
            }
          }
        }

        // Skip the header row
        final List<List<dynamic>> dataWithoutHeader =
            excelData.skip(1).toList();

        // Initialize EasyLoading

        // Process data in chunks
        const int chunkSize = 100; // Adjust the chunk size as needed
        String plan_id =
            '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}';
        String created_dated =
            '${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}';
        for (int i = 0; i < dataWithoutHeader.length; i += chunkSize) {
          final chunk = dataWithoutHeader.skip(i).take(chunkSize).toList();

          await insertExcelToSql(chunk, plan_id, created_dated);

          final progress = ((i + chunkSize) / dataWithoutHeader.length) * 100;
          EasyLoading.showProgress(progress / 100,
              status: 'Importing... ${progress.toStringAsFixed(0)}%',
              maskType: EasyLoadingMaskType.black);
        }

        // Dismiss EasyLoading
        EasyLoading.dismiss();
      }
    } catch (e, s) {
      EasyLoading.showError('Error: $e');
      print(e);
      print(s);
    }
  }

  Future insertExcelToSql(
      List<List<dynamic>> data, String header, String current_date) async {
    final db = await appDb.database;
    final batch = db.batch();
    for (var row in data) {
      batch.insert(tableName, {
        plan: header,
        asset: row[0].toString(),
        description: row[1].toString(),
        costCenter: row[2].toString(),
        Capitalized_on: row[3].toString(),
        location: row[4].toString(),
        department: row[5].toString(),
        asset_Owner: row[6].toString(),
        user_def_1: row[7].toString(),
        user_def_2: row[8].toString(),
        user_def_3: null,
        user_def_4: null,
        created_date: current_date,
        status_check: uncheck,
        status_plan: status_open,
      });
    }
    await batch.commit(noResult: true);
  }

  // Function to count assets for a specific plan
  Future<int> countAssetsForPlan(String plan) async {
    final db = await appDb.database;
    final countAssets = await db.rawQuery(
        'SELECT COUNT(asset) as assetCount FROM $tableName WHERE plan = ?',
        [plan]);
    final int count = Sqflite.firstIntValue(countAssets) ?? 0;
    return count;
  }

  // Function to select plans and their asset counts
  Future<List<ViewImportModel>> selectPlan() async {
    final db = await appDb.database;

    // Query to get distinct plans and their creation dates
    final result = await db
        .query(tableName, distinct: true, columns: [plan, created_date]);

    // Initialize an empty list to store the ViewImportModel objects
    final List<ViewImportModel> planReturn = [];

    // Iterate over each distinct plan
    for (var json in result) {
      String planStr = json[plan].toString();
      String createdDate = json['created_date'] as String;

      // Get the count of assets for the current plan
      final int count = await countAssetsForPlan(planStr);

      // Create a ViewImportModel object and add it to the list
      planReturn.add(ViewImportModel(
        plan: planStr,
        createdDate: createdDate,
        qtyAssets: count.toString(),
      ));
    }

    return planReturn;
  }

  Future<List<ViewImportdetailModel>> viewDetail(String objPlan,
      {int limit = 10, int offset = 0}) async {
    final db = await appDb.database;
    final result = await db.query(
      tableName,
      where: '$plan = ?',
      whereArgs: [objPlan],
      limit: limit,
      offset: offset,
    );

    final List<ViewImportdetailModel> detailReturn = [];

    for (var json in result) {
      detailReturn.add(ViewImportdetailModel(
        plan: json[plan].toString(),
        asset: json[asset].toString(),
        description: json[description].toString(),
        costCenter: json[costCenter].toString(),
        capitalizedOn: json[Capitalized_on].toString(),
        location: json[location].toString(),
        department: json[department].toString(),
        assetOwner: json[asset_Owner].toString(),
        createdDate: json[created_date].toString(),
        userDef1: json[user_def_1].toString(),
        userDef2: json[user_def_2].toString(),
        userDef3: json[user_def_3].toString(),
        userDef4: json[user_def_4].toString(),
      ));
    }
    return detailReturn;
  }

  Future deleteData(String planOrder) async {
    if (planOrder.isNotEmpty) {
      final db = await appDb.database;
      await db.delete(tableName, where: '$plan = ?', whereArgs: [planOrder]);
    } else {
      final db = await appDb.database;
      await db.delete(tableName);
    }
  }

  Future<ViewSumStatusModel> getSummaryViewOnSelectPlan() async {
    final db = await appDb.database;
    final queryUncheck = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE $status_check = ?',
      [uncheck],
    );
    final queryChecked = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE $status_check = ?',
      [checked],
    );

    final queryAllPlan = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName',
    );

    // Extract the count from the result
    int resultUncheck = Sqflite.firstIntValue(queryUncheck) ?? 0;
    int resultcheck = Sqflite.firstIntValue(queryChecked) ?? 0;
    int allPlan = Sqflite.firstIntValue(queryAllPlan) ?? 0;

    ViewSumStatusModel item = ViewSumStatusModel(
        uncheck: resultUncheck, checked: resultcheck, allitem: allPlan);
    return item;
  }
}
