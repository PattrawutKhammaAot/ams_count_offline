import 'package:count_offline/main.dart';
import 'package:count_offline/model/department/departmentModel.dart';

class DepartmenDB {
  String tableName = 'ImportMaster';

  Future<List<DepartmentModel>> getDepartment() async {
    final db = await appDb.database;
    // Fetch data from the database
    final result =
        await db.query(tableName, distinct: true, columns: ['Department']);
    List<DepartmentModel> newItems = [];
    for (var json in result) {
      newItems.add(DepartmentModel.fromJson(json));
    }

    return newItems;
  }
}
