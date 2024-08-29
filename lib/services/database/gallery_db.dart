import 'dart:io';

import 'package:count_offline/component/custom_botToast.dart';
import 'package:count_offline/model/galleryModel/galleryModel.dart';
import 'package:count_offline/services/database/import_db.dart';
import 'package:count_offline/services/database/quickType.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';

class GalleryDB {
  static const String field_tableName = 'GalleryDB';
  static const String field_plan = 'Plan';
  static const String field_asset = 'Asset';
  static const String filed_name_image = 'name';
  static const String field_image_file = 'Image_file';
  static const String field_created_date = 'created_date';

  createTable(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $field_tableName ('
        '${QuickTypes.ID_PRIMARYKEY},'
        '$field_plan ${QuickTypes.TEXT},'
        '$field_asset ${QuickTypes.TEXT},'
        '$filed_name_image ${QuickTypes.TEXT},'
        '$field_image_file ${QuickTypes.IMAGE},'
        '$field_created_date ${QuickTypes.TEXT}'
        ')');
  }

  Future<bool> insertImage(
      String filePath, String planValue, String assetValue) async {
    try {
      final db = await appDb.database;
      Uint8List imageBytes = await File(filePath).readAsBytes();
      var checkInDB = await db.query(field_tableName,
          where: "$field_asset = ? AND $field_plan = ?",
          whereArgs: [assetValue, planValue],
          limit: 1);

      if (checkInDB.isEmpty) {
        var result = await db.insert(
          field_tableName, // Table name
          {
            filed_name_image:
                "${assetValue}${DateFormat('HH:mm:ss').format(DateTime.now())}",
            field_plan: planValue,
            field_asset: assetValue,
            field_image_file: imageBytes,
            field_created_date:
                "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}",
          }, // Column names and values
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        if (result != 0) {
          CustomBotToast.showSuccess("Upload Image Success !");
          return true;
        }
      } else {
        //update
        var result = await db.update(
          field_tableName, // Table name
          {
            filed_name_image:
                "${assetValue}${DateFormat('HH:mm:ss').format(DateTime.now())}",
            field_plan: planValue,
            field_asset: assetValue,
            field_image_file: imageBytes,
            field_created_date:
                "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}",
          }, // Column names and values
          where: "$field_asset = ? AND $field_plan = ?",
          whereArgs: [assetValue, planValue],
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        if (result != 0) {
          CustomBotToast.showSuccess("Update Image Success !");
          return true;
        }
      }

      return false;
    } catch (e, s) {
      print(e);
      print(s);
      return false;
    }
  }

  Future<List<ViewGalleryModel>> getImage() async {
    final db = await appDb.database;
    final result = await db.query(field_tableName);
    final List<ViewGalleryModel> imageReturn = [];
    for (var json in result) {
      String planStr = json[field_plan].toString();
      String assetStr = json[field_asset].toString();
      Uint8List imageFile = json[field_image_file] as Uint8List;
      String createdDate = json[field_created_date] as String;
      imageReturn.add(ViewGalleryModel(
        plan: planStr,
        asset: assetStr,
        imageFile: imageFile,
        createdDate: createdDate,
      ));
    }
    return imageReturn;
  }
}
