import 'package:count_offline/main.dart';
import 'package:count_offline/model/count/viewListCount.dart';

class CountDB {
  String tableName = 'ImportMaster';
  Future<List<ViewListCountModel>> getList() async {
    final db = await appDb.database;
    final result = await db.query(tableName,
        distinct: true, columns: ['Plan', 'created_date', 'status_plan']);
    final List<ViewListCountModel> planReturn = [];
    for (var json in result) {
      String planStr = json['Plan'].toString();
      String createdDate = json['created_date'] as String;
      String statusPlan = json['status_plan'] as String;
      planReturn.add(ViewListCountModel(
        plan: planStr,
        createdDate: createdDate,
        statusPlan: statusPlan,
      ));
    }
    return planReturn;
  }
}
