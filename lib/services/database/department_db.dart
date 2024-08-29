import 'package:count_offline/main.dart';
import 'package:count_offline/model/department/departmentModel.dart';
import 'package:count_offline/services/database/import_db.dart';

class DepartmenDB {
  String tableName = ImportDB.field_tableName;

  Future<List<DepartmentModel>> getDepartment() async {
    final db = await appDb.database;
    // Fetch data from the database
    final result = await db
        .query(tableName, distinct: true, columns: [ImportDB.field_department]);
    List<DepartmentModel> newItems = [];
    for (var json in result) {
      newItems.add(DepartmentModel.fromJson(json));
    }

    return newItems;
  }
}
