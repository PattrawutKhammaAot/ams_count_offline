import 'dart:convert';
import 'dart:io';

import 'package:count_offline/component/custom_botToast.dart';
import 'package:count_offline/main.dart';
import 'package:count_offline/model/count/countModelEvent.dart';
import 'package:count_offline/model/count/viewListCount.dart';
import 'package:count_offline/model/report/viewReportEditModel.dart';
import 'package:count_offline/services/database/gallery_db.dart';
import 'package:count_offline/services/database/import_db.dart';
import 'package:count_offline/services/database/quickType.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../extension/color_extension.dart';
import '../../model/count/responseCountModel.dart';

enum StatusQuery { inplan, notPlan, invalid }

class CountDB {
  String tableName = ImportDB.field_tableName;
  Future<List<ViewListCountModel>> getList() async {
    final db = await appDb.database;
    final result = await db.query(tableName, distinct: true, columns: [
      ImportDB.field_plan,
      ImportDB.field_created_date,
      ImportDB.field_status_plan
    ]);
    final List<ViewListCountModel> planReturn = [];
    for (var json in result) {
      String planStr = json[ImportDB.field_plan].toString();
      String createdDate = json[ImportDB.field_created_date].toString();
      String statusPlan = json[ImportDB.field_status_plan].toString();
      planReturn.add(ViewListCountModel(
        plan: planStr,
        createdDate: createdDate,
        statusPlan: statusPlan,
      ));
    }
    return planReturn;
  }

  Future<ResponseCountModel> scanBarcode(
      CountModelEvent obj, BuildContext context) async {
    try {
      ResponseCountModel itemReturn = ResponseCountModel();
      StatusQuery isCheckPlan = await _checkInPlan(obj);

      print("isCheckPlan $isCheckPlan");
      bool isCheckLocation;
      bool isCheckDepartment;
      if (isCheckPlan == StatusQuery.inplan)
      //อยู่ในแผน
      {
        bool isChecked = await _checkStatusAsset(obj);
        //ถ้านับไปแล้ว
        if (isChecked) {
          bool isConfirm = await showDialogConfirm(context,
              title: "Warning",
              content:
                  "This asset has already been counted. Do you want to count it again?",
              type: TypeAlert.warning);
          if (isConfirm) {
            //เช็คว่ามีLocation หรือ Department มีส่งมาไหม
            if (obj.location != null && obj.department != null) {
              //ถ้ามี Location และ Department
              isCheckLocation = await checkLocation(obj);
              isCheckDepartment = await checkDepartment(obj);
              if (isCheckLocation && isCheckDepartment) {
                CustomBotToast.showSuccess("Success ");
              } else if (isCheckLocation && !isCheckDepartment) {
                CustomBotToast.showWarning(
                    "Department that does not match the data in the plan");
              } else if (!isCheckLocation && isCheckDepartment) {
                CustomBotToast.showWarning(
                    "Location that does not match the data in the plan");
              } else {
                CustomBotToast.showWarning(
                    "Location and Department that do not match the data in the plan");
              }
            } else if (obj.location != null && obj.department == null) {
              isCheckLocation = await checkLocation(obj);
              if (!isCheckLocation) {
                CustomBotToast.showWarning(
                    "Location that does not match the data in the plan");
              }
            } else if (obj.location == null && obj.department != null) {
              isCheckDepartment = await checkDepartment(obj);
              if (!isCheckDepartment) {
                CustomBotToast.showWarning(
                    "Department that does not match the data in the plan");
              }
            }
            itemReturn = await updateInPlan(obj);
          }
        } else {
          //เช็คว่ามีLocation หรือ Department มีส่งมาไหม
          if (obj.location != null && obj.department != null) {
            //ถ้ามี Location และ Department
            isCheckLocation = await checkLocation(obj);
            isCheckDepartment = await checkDepartment(obj);
            if (isCheckLocation && isCheckDepartment) {
              CustomBotToast.showSuccess("Success ");
            } else if (isCheckLocation && !isCheckDepartment) {
              CustomBotToast.showWarning(
                  "Department that does not match the data in the plan");
            } else if (!isCheckLocation && isCheckDepartment) {
              CustomBotToast.showWarning(
                  "Location that does not match the data in the plan");
            } else {
              CustomBotToast.showWarning(
                  "Location and Department that do not match the data in the plan");
            }
          } else if (obj.location != null && obj.department == null) {
            isCheckLocation = await checkLocation(obj);
            if (!isCheckLocation) {
              CustomBotToast.showWarning(
                  "Location that does not match the data in the plan");
            }
          } else if (obj.location == null && obj.department != null) {
            isCheckDepartment = await checkDepartment(obj);
            if (!isCheckDepartment) {
              CustomBotToast.showWarning(
                  "Department that does not match the data in the plan");
            }
          }
          itemReturn = await updateInPlan(obj);
        }
      }
      //ไม่ได้อยู่ในแผน
      else if (isCheckPlan == StatusQuery.notPlan) {
        bool isConfirmNotPlan = await showDialogConfirm(context,
            title: "Warning",
            content: "This asset is not in the plan. Do you want to count it?",
            type: TypeAlert.warning);
        if (isConfirmNotPlan) {
          if (obj.location != null && obj.department != null) {
            //ถ้ามี Location และ Department
            isCheckLocation = await checkLocation(obj);
            isCheckDepartment = await checkDepartment(obj);
            if (isCheckLocation && isCheckDepartment) {
              CustomBotToast.showSuccess("Success ");
            } else if (isCheckLocation && !isCheckDepartment) {
              CustomBotToast.showWarning(
                  "Department that does not match the data in the plan");
            } else if (!isCheckLocation && isCheckDepartment) {
              CustomBotToast.showWarning(
                  "Location that does not match the data in the plan");
            } else {
              CustomBotToast.showWarning(
                  "Location and Department that do not match the data in the plan");
            }
          } else if (obj.location != null && obj.department == null) {
            isCheckLocation = await checkLocation(obj);
            if (!isCheckLocation) {
              CustomBotToast.showWarning(
                  "Location that does not match the data in the plan");
            }
            //ถ้ามี Location แต่ไม่มี Department
          } else if (obj.location == null && obj.department != null) {
            //ถ้ามี Department แต่ไม่มี Location
            isCheckDepartment = await checkDepartment(obj);
            if (!isCheckDepartment) {
              CustomBotToast.showWarning(
                  "Departmen that does not match the data in the plan");
            }
          }
          itemReturn = await _insertNotINPlan(obj);
        }
      } else if (isCheckPlan == StatusQuery.invalid) {
        CustomBotToast.showWarning("Data not Found");
      }
      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      return ResponseCountModel(is_Success: false);
    }
  }

  Future<bool> _checkStatusAsset(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkStatusAssets = await db.query(tableName,
        where:
            "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ? AND ${ImportDB.field_status_check} = ?",
        whereArgs: [obj.barcode, obj.plan, StatusCheck.status_checked],
        limit: 1);
    if (checkStatusAssets.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<StatusQuery> _checkInPlan(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkInPlan = await db.query(tableName,
        where:
            ImportDB.field_asset + " = ? AND " + ImportDB.field_plan + " = ?",
        whereArgs: [obj.barcode, obj.plan],
        limit: 1);
    if (checkInPlan.isNotEmpty) {
      return StatusQuery.inplan;
    } else {
      final checkOutPlan = await db.query(tableName,
          where: ImportDB.field_asset + " = ?",
          whereArgs: [obj.barcode],
          limit: 1);
      if (checkOutPlan.isNotEmpty) {
        return StatusQuery.notPlan;
      } else {
        return StatusQuery.invalid;
      }
    }
  }

  Future<ResponseCountModel> updateInPlan(CountModelEvent obj) async {
    try {
      ResponseCountModel itemReturn = ResponseCountModel();
      final db = await appDb.database;

      final queryCheckAssetNotInPlan = await db.query(
        tableName,
        where:
            ImportDB.field_asset + " = ? AND " + ImportDB.field_plan + " = ?",
        whereArgs: [obj.barcode, obj.plan],
        columns: [ImportDB.field_asset_not_in_plan],
        limit: 1,
      );
      final updateInPlan = await db.update(
          tableName,
          {
            ImportDB.field_count_location: obj.location,
            ImportDB.field_count_department: obj.department,
            ImportDB.field_status_assets: obj.statusAsset,
            // ImportDB.field_remark: obj.remark ?? "",
            ImportDB.field_scan_date:
                DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
            ImportDB.field_status_check: StatusCheck.status_checked,
            ImportDB.field_asset_not_in_plan: queryCheckAssetNotInPlan[0]
                            [ImportDB.field_asset_not_in_plan]
                        .toString() ==
                    "YES"
                ? "YES"
                : "NO",
          },
          where:
              ImportDB.field_asset + " = ? AND " + ImportDB.field_plan + " = ?",
          whereArgs: [obj.barcode, obj.plan]);
      if (updateInPlan != 0) {
        final result = await db.query(tableName,
            where: "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ?",
            whereArgs: [obj.barcode, obj.plan],
            limit: 1);
        itemReturn = ResponseCountModel(
            asset: result[0][ImportDB.field_asset].toString(),
            costCenter: result[0][ImportDB.field_costCenter].toString(),
            department: result[0][ImportDB.field_department].toString(),
            statusAsset: result[0][ImportDB.field_status_assets].toString(),
            remark: result[0][ImportDB.field_remark].toString(),
            scanDate: result[0][ImportDB.field_scan_date].toString(),
            qty: result[0][ImportDB.field_qty].toString(),
            cap_date: result[0][ImportDB.field_Capitalized_on].toString(),
            check: result[0][ImportDB.field_status_check].toString(),
            name: result[0][ImportDB.field_description].toString(),
            is_Success: true);
      } else {
        itemReturn = ResponseCountModel(is_Success: false);
      }
      await updateStatusPlan(obj);
      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      return ResponseCountModel(is_Success: false);
    }
  }

  Future<bool> checkLocation(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkLocation = await db.query(tableName,
        where: ImportDB.field_location +
            " = ? AND " +
            ImportDB.field_asset +
            " = ? AND " +
            ImportDB.field_plan +
            " = ?  ",
        whereArgs: [obj.location, obj.barcode, obj.plan],
        limit: 1);
    if (checkLocation.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkDepartment(CountModelEvent obj) async {
    final db = await appDb.database;
    final checkDepartment = await db.query(tableName,
        where: ImportDB.field_department +
            " = ? AND " +
            ImportDB.field_asset +
            " = ? AND " +
            ImportDB.field_plan +
            " = ?  ",
        whereArgs: [obj.department, obj.barcode, obj.plan],
        limit: 1);
    if (checkDepartment.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateStatusPlan(CountModelEvent obj) async {
    final db = await appDb.database;
    final queryCheckStatusPlan = await db.query(tableName,
        where: ImportDB.field_plan + " = ?", whereArgs: [obj.plan], limit: 1);
    if (queryCheckStatusPlan[0][ImportDB.field_status_plan].toString() ==
        StatusCheck.status_open) {
      var result = await db.update(
          tableName, {ImportDB.field_status_plan: StatusCheck.status_count},
          where: ImportDB.field_plan + " = ?", whereArgs: [obj.plan]);
    }
  }

  // Future<CountModelEvent> checkStatusAsset1234(CountModelEvent obj) async {
  //   CountModelEvent itemReturn = CountModelEvent();
  //   final db = await appDb.database;
  //   final checkStatusAssets = await db.query(tableName,
  //       where:
  //           "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ? AND ${ImportDB.field_status_check} = ?",
  //       whereArgs: [obj.barcode, obj.plan, StatusCheck.status_checked],
  //       limit: 1);
  //   if (checkStatusAssets.isNotEmpty) {
  //     //ถ้ามีข้อมูลในฐานข้อมูล
  //     itemReturn = CountModelEvent(
  //         plan: checkStatusAssets[0][ImportDB.field_plan].toString(),
  //         barcode: checkStatusAssets[0][ImportDB.field_asset].toString(),
  //         location: checkStatusAssets[0][ImportDB.field_location].toString(),
  //         department:
  //             checkStatusAssets[0][ImportDB.field_department].toString(),
  //         costCenter: checkStatusAssets[0][ImportDB.field_costCenter] as int,
  //         statusAsset:
  //             checkStatusAssets[0][ImportDB.field_status_assets].toString(),
  //         remark: checkStatusAssets[0][ImportDB.field_remark].toString(),
  //         scanDate: checkStatusAssets[0][ImportDB.field_scan_date].toString(),
  //         is_Success: true);
  //   } else {
  //     itemReturn = CountModelEvent(is_Success: false);
  //     //ถ้าไม่มีข้อมูลในฐานข้อมูล
  //   }

  //   return itemReturn;
  // }

  Future<ResponseCountModel> _insertNotINPlan(CountModelEvent obj) async {
    try {
      print("notPlan");
      ResponseCountModel itemReturn = ResponseCountModel(is_Success: false);
      final db = await appDb.database;
      final queryAssetOutPlan = await db.query(tableName,
          where: "${ImportDB.field_asset} = ?",
          whereArgs: [obj.barcode],
          limit: 1);
      if (queryAssetOutPlan.isNotEmpty) {
        final insertNotInPlan = await db.insert(tableName, {
          ImportDB.field_plan: obj.plan.toString(),
          ImportDB.field_asset: obj.barcode,
          ImportDB.field_costCenter:
              queryAssetOutPlan[0][ImportDB.field_costCenter].toString(),
          ImportDB.field_description:
              queryAssetOutPlan[0][ImportDB.field_description].toString(),
          ImportDB.field_Capitalized_on:
              queryAssetOutPlan[0][ImportDB.field_Capitalized_on].toString(),
          ImportDB.field_location:
              queryAssetOutPlan[0][ImportDB.field_location].toString(),
          ImportDB.field_department:
              queryAssetOutPlan[0][ImportDB.field_department].toString(),
          ImportDB.field_asset_Owner:
              queryAssetOutPlan[0][ImportDB.field_asset_Owner].toString(),
          ImportDB.field_qty: obj.qty,
          ImportDB.field_status_assets: obj.statusAsset,
          ImportDB.field_remark: obj.remark ?? "",
          ImportDB.field_count_location: obj.location,
          ImportDB.field_count_department: obj.department,
          ImportDB.field_scan_date:
              DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
          ImportDB.field_status_check: StatusCheck.status_checked,
          ImportDB.field_asset_not_in_plan: "YES",
          ImportDB.field_status_plan: StatusCheck.status_count,
          ImportDB.field_created_date:
              queryAssetOutPlan[0][ImportDB.field_created_date].toString(),
        });
        final result = await db.query(tableName,
            where: "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ?",
            whereArgs: [obj.barcode, obj.plan],
            limit: 1);
        if (result.isNotEmpty) {
          itemReturn = ResponseCountModel(
              asset: result[0][ImportDB.field_asset].toString(),
              costCenter: result[0][ImportDB.field_costCenter].toString(),
              department: result[0][ImportDB.field_department].toString(),
              statusAsset: result[0][ImportDB.field_status_assets].toString(),
              remark: result[0][ImportDB.field_remark].toString(),
              scanDate: result[0][ImportDB.field_scan_date].toString(),
              qty: result[0][ImportDB.field_qty].toString(),
              cap_date: result[0][ImportDB.field_Capitalized_on].toString(),
              check: result[0][ImportDB.field_status_check].toString(),
              name: result[0][ImportDB.field_description].toString(),
              is_Success: true);
        }

        await updateStatusPlan(obj);
        print("update");
        return itemReturn;
      }
      print("Noupdate");
      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      return ResponseCountModel(is_Success: false);
    }
  }

  Future<bool> showDialogConfirm(BuildContext context,
      {required String? title, String? content, TypeAlert? type}) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Text(title!),
                  type == TypeAlert.warning
                      ? Icon(
                          Icons.warning,
                          color: Colors.red,
                        )
                      : SizedBox.fromSize()
                ],
              ),
              content: Text(content ?? ""),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.contentColorRed)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.greenAccent)),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if the dialog is dismissed without a selection
  }

  Future<bool> btnSave(CountModelEvent obj) async {
    final db = await appDb.database;
    final queryAssetOutPlan = await db.update(
        tableName,
        {
          ImportDB.field_status_assets: obj.statusAsset,
          ImportDB.field_remark: obj.remark,
        },
        where: "${ImportDB.field_asset} = ? AND ${ImportDB.field_plan} = ?",
        whereArgs: [obj.barcode, obj.plan]);

    if (queryAssetOutPlan != 0) {
      return true;
    }
    return false;
  }

  //////==================================EditPage=============================//////////////////////
  ///
  ///
  Future<ViewReportEditModel> getAssetEdit(
      {required String plan, required String asset}) async {
    ViewReportEditModel itemReturn = ViewReportEditModel();
    try {
      final db = await appDb.database;
      final result = await db.query(tableName,
          where: "${ImportDB.field_plan} = ? AND ${ImportDB.field_asset} = ?",
          whereArgs: [plan, asset],
          columns: [
            ImportDB.field_description,
            ImportDB.field_costCenter,
            ImportDB.field_Capitalized_on,
            ImportDB.field_location,
            ImportDB.field_department,
            ImportDB.field_asset_Owner,
            ImportDB.field_created_date,
            ImportDB.field_status_check,
            ImportDB.field_status_assets,
            ImportDB.field_count_location,
            ImportDB.field_count_department,
            ImportDB.field_remark,
            ImportDB.field_status_plan,
            ImportDB.field_scan_date,
            ImportDB.field_qty,
          ],
          limit: 1);
      itemReturn = ViewReportEditModel.fromJson(result[0]);
      print(jsonEncode(itemReturn));
      return itemReturn;
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    }
  }
}
