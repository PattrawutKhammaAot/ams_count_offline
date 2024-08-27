import 'dart:convert';

import 'package:count_offline/main.dart';
import 'package:count_offline/model/location/locationModel.dart';

class LocationDB {
  String tableName = 'ImportMaster';

  Future<List<LocationModel>> getLocation() async {
    final db = await appDb.database;
    // Fetch data from the database
    final result =
        await db.query(tableName, distinct: true, columns: ['Location']);
    List<LocationModel> newItems = [];
    for (var json in result) {
      newItems.add(LocationModel.fromJson(json));
    }

    return newItems;
  }
}
