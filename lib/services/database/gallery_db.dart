import 'dart:io';

import 'package:count_offline/model/galleryModel/galleryModel.dart';
import 'package:count_offline/services/database/quickType.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';

class GalleryDB {
  String tableName = 'GalleryDB';
  String plan = 'Plan';
  String asset = 'Asset';
  String image_file = 'Image_file';
  String created_date = 'created_date';

  createTable(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName ('
        '${QuickTypes.ID_PRIMARYKEY},'
        '$plan ${QuickTypes.TEXT},'
        '$asset ${QuickTypes.TEXT},'
        '$image_file ${QuickTypes.IMAGE},'
        '$created_date ${QuickTypes.TEXT}'
        ')');
  }

  Future<void> insertImage(Database db, String filePath, String planValue,
      String assetValue, String createdDate) async {
    // Read the image file as bytes
    Uint8List imageBytes = await File(filePath).readAsBytes();

    // Insert the image bytes into the database
    await db.insert(
      tableName, // Table name
      {
        plan: planValue,
        asset: assetValue,
        image_file: imageBytes,
        created_date: createdDate,
      }, // Column names and values
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ViewGalleryModel>> getImage() async {
    final db = await appDb.database;
    final result = await db.query(tableName);
    final List<ViewGalleryModel> imageReturn = [];
    for (var json in result) {
      String planStr = json['Plan'].toString();
      String assetStr = json['Asset'].toString();
      Uint8List imageFile = json['Image_file'] as Uint8List;
      String createdDate = json['created_date'] as String;
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
