import 'dart:convert';

import 'package:count_offline/main.dart';
import 'package:count_offline/model/export/exportModel.dart';
import 'package:count_offline/services/database/gallery_db.dart';
import 'package:count_offline/services/database/import_db.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'dart:typed_data';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ExportDB {
  final String mainFolderPath = '/storage/emulated/0/ams_export';
  final String text_name = 'folder:ams_export';

  Future<List<String>> getPlan() async {
    final db = await appDb.database;
    final resultPlan = await db.query(ImportDB.field_tableName,
        distinct: true, columns: [ImportDB.field_plan]);
    final plans =
        resultPlan.map((row) => row[ImportDB.field_plan].toString()).toList();
    return plans;
  }

  Future<void> ExportAllAssetByPlan(String plan) async {
    try {
      final db = await appDb.database;
      const int batchSize = 500;
      int offset = 0;
      bool hasMoreData = true;

      // Create Excel file
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];
      await exportSheet2Image(workbook, plan);
      // Add headers
      sheet.getRangeByName('A1').setText('Plan');
      sheet.getRangeByName('B1').setText('Asset');
      sheet.getRangeByName('C1').setText('Description');
      sheet.getRangeByName('D1').setText('Cost Center');
      sheet.getRangeByName('E1').setText('Capitalized on');
      sheet.getRangeByName('F1').setText('Location');
      sheet.getRangeByName('G1').setText('Department');
      sheet.getRangeByName('H1').setText('Owner Name');
      sheet.getRangeByName('I1').setText('Status Check');
      sheet.getRangeByName('J1').setText('Status Asset');
      sheet.getRangeByName('K1').setText('Scan Date');
      sheet.getRangeByName('L1').setText('Count Location');
      sheet.getRangeByName('M1').setText('Count Department');
      sheet.getRangeByName('N1').setText('Remark');
      sheet.getRangeByName('O1').setText('Asset Not In Plan');
      sheet.getRangeByName('P1').setText('Image');
      sheet.getRangeByName('Q1').setText('USER DEF1');
      sheet.getRangeByName('R1').setText('USER DEF2');

      int currentRow = 2;

      // Show loading

      while (hasMoreData) {
        // Query assets data in batches
        final assets = await db.query(
          ImportDB.field_tableName,
          where: '${ImportDB.field_plan} = ?',
          whereArgs: [plan],
          limit: batchSize,
          offset: offset,
        );

        // Query associated images

        if (assets.isEmpty) {
          hasMoreData = false;
          break;
        }

        for (int i = 0; i < assets.length; i++) {
          final images = await db.query(
            GalleryDB.field_tableName,
            where:
                '${GalleryDB.field_plan} = ? AND ${GalleryDB.field_asset} = ?',
            whereArgs: [plan, assets[i][ImportDB.field_asset]],
            limit: batchSize,
            offset: offset,
          );
          Uint8List? imageBytes;
          var imagesName;

          if (images.isNotEmpty) {
            imagesName = images.firstWhere(
                (image) =>
                    image[GalleryDB.field_asset] ==
                    assets[i][ImportDB.field_asset],
                orElse: () => <String, Object?>{})[GalleryDB.filed_name_image];
            var imageFilePath = images.firstWhere(
              (image) =>
                  image[GalleryDB.field_asset] ==
                  assets[i][ImportDB.field_asset],
              orElse: () => <String, Object?>{},
            )[GalleryDB.field_image_file_path];

            if (imageFilePath != null && imageFilePath is String) {
              File imageFile = File(imageFilePath);
              if (await imageFile.exists()) {
                imageBytes = await imageFile.readAsBytes();
              }
            }
          }

          // Add asset data to Excel row
          sheet
              .getRangeByIndex(currentRow, 1)
              .setText(assets[i][ImportDB.field_plan]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 2)
              .setText(assets[i][ImportDB.field_asset]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 3)
              .setText(assets[i][ImportDB.field_description]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 4)
              .setText(assets[i][ImportDB.field_costCenter]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 5).setText(
              assets[i][ImportDB.field_Capitalized_on]?.toString() == "null" ||
                      assets[i][ImportDB.field_Capitalized_on]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_Capitalized_on]?.toString());
          sheet
              .getRangeByIndex(currentRow, 6)
              .setText(assets[i][ImportDB.field_location]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 7)
              .setText(assets[i][ImportDB.field_department]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 8).setText(
              assets[i][ImportDB.field_asset_Owner]?.toString() == "null" ||
                      assets[i][ImportDB.field_asset_Owner]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_asset_Owner]?.toString());

          sheet.getRangeByIndex(currentRow, 9).setText(
              assets[i][ImportDB.field_status_check]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 10).setText(
              assets[i][ImportDB.field_status_assets]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 11)
              .setText(assets[i][ImportDB.field_scan_date]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 12).setText(
              assets[i][ImportDB.field_count_location]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 13).setText(
              assets[i][ImportDB.field_count_department]?.toString() ?? '');
          sheet
              .getRangeByIndex(currentRow, 14)
              .setText(assets[i][ImportDB.field_remark]?.toString() ?? '');
          sheet.getRangeByIndex(currentRow, 15).setText(
              assets[i][ImportDB.field_asset_not_in_plan]?.toString() ?? '');
          // Insert image if it exists
          if (imageBytes != null) {
            final String fileName = imagesName;
            final String filePath =
                await exportImageToFolder(imageBytes, fileName);

            sheet.getRangeByIndex(currentRow, 16).setText(
                "${filePath.substring(filePath.indexOf('ams_export'))}");
            // try {
            //   final xlsio.Picture picture =
            //       sheet.pictures.addStream(currentRow, 16, imageBytes);
            //   // Set the size of the picture
            //   picture.width = 100;
            //   picture.height = 100;

            //   // Adjust the row height and column width to fit the picture
            //   sheet.getRangeByIndex(currentRow, 16).rowHeight = 100;
            //   sheet.getRangeByIndex(currentRow, 16).columnWidth = 30;

            //   // Optionally, set the position of the picture within the cell
            // } catch (e) {
            //   print('Error exporting image: $e');
            // }
          } else {
            sheet.getRangeByIndex(currentRow, 16).setText(' ');
          }
          sheet.getRangeByIndex(currentRow, 17).setText(
              assets[i][ImportDB.field_user_def_1]?.toString() == "null" ||
                      assets[i][ImportDB.field_user_def_1]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_user_def_1]?.toString());
          sheet.getRangeByIndex(currentRow, 18).setText(
              assets[i][ImportDB.field_user_def_2]?.toString() == "null" ||
                      assets[i][ImportDB.field_user_def_2]?.toString() == ""
                  ? ''
                  : assets[i][ImportDB.field_user_def_2]?.toString());
          currentRow++;
        }

        // Update progress
        final progress = (offset / (offset + batchSize)) * 100;
        EasyLoading.showProgress(
          offset / (offset + batchSize),
          status:
              '${appLocalization.localizations.export_loading}. ${progress.toStringAsFixed(0)}%',
          maskType: EasyLoadingMaskType.black,
        );

        // Move to the next batch of data
        offset += batchSize;
      }
      await createFolderInDocument();
      // Save Excel file with the added images
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      // Path ที่ต้องการบันทึกไฟล์
      final String downloadPath = path.join(mainFolderPath);

      String baseFileName = 'export-$plan';
      String fileExtension = '.xlsx';
      String outputFile =
          path.join(downloadPath, '$baseFileName$fileExtension');
      int fileIndex = 1;

      // Check if file already exists and find a unique file name
      while (File(outputFile).existsSync()) {
        outputFile =
            path.join(downloadPath, '$baseFileName($fileIndex)$fileExtension');
        fileIndex++;
      }

      // Write the file
      File(outputFile).writeAsBytesSync(bytes);

      // Dismiss loading
      EasyLoading.showSuccess(
          '${appLocalization.localizations.export_to} $text_name $baseFileName($fileIndex)$fileExtension',
          maskType: EasyLoadingMaskType.black);
    } catch (e, s) {
      print(e);
      print(s);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> exportSheet2Image(xlsio.Workbook workbook, String plan) async {
    final xlsio.Worksheet worksheet = workbook.worksheets.addWithName('Image');

    try {
      final db = await appDb.database;
      // Add headers
      worksheet.getRangeByName('A1').setText('Plan');
      worksheet.getRangeByName('B1').setText('Asset');
      worksheet.getRangeByName('C1').setText('Image');

      bool hasMoreData = true;
      const int batchSize = 500;
      int offset = 0;
      int currentRow = 2;

      while (hasMoreData) {
        // Query associated images
        final images = await db.query(
          GalleryDB.field_tableName,
          where: '${GalleryDB.field_plan} = ?',
          whereArgs: [plan],
          limit: batchSize,
          offset: offset,
        );

        if (images.isEmpty) {
          hasMoreData = false;
          break;
        }

        for (var image in images) {
          final asset = image[GalleryDB.field_asset];
          final imageFilePath = image[GalleryDB.field_image_file_path];

          // Set asset and plan
          worksheet.getRangeByIndex(currentRow, 1).setText(plan);
          worksheet.getRangeByIndex(currentRow, 1).columnWidth = 25;
          worksheet.getRangeByIndex(currentRow, 2).setText(asset.toString());
          worksheet.getRangeByIndex(currentRow, 2).columnWidth = 25;

          // Insert image if it exists
          if (imageFilePath != null && imageFilePath is String) {
            File imageFile = File(imageFilePath);
            if (await imageFile.exists()) {
              final Uint8List imageBytes = await imageFile.readAsBytes();
              final xlsio.Picture picture =
                  worksheet.pictures.addStream(currentRow, 3, imageBytes);

              // Set the size of the picture
              picture.width = 150;
              picture.height = 150;

              // Adjust the row height and column width to fit the picture
              worksheet.getRangeByIndex(currentRow, 3).rowHeight = 100;
              worksheet.getRangeByIndex(currentRow, 3).columnWidth = 25;
            }
          }

          currentRow++;
        }

        // Move to the next batch of data
        offset += batchSize;
      }
    } catch (e, s) {
      print('Error exporting image: $e');
      print(s);
    }
  }

  Future<String> exportImageToFolder(
      Uint8List imageBytes, String fileName) async {
    try {
      final Directory? downloadDirectory = await getExternalStorageDirectory();
      if (downloadDirectory == null) {
        throw Exception("Unable to get download directory");
      }

      final String folderPath = '$mainFolderPath/image';

      final String filePath = '$folderPath/$fileName';
      final File file = File(filePath);

      // บันทึกไฟล์รูปภาพ
      await file.writeAsBytes(imageBytes);

      return filePath;
    } catch (e) {
      print('Error saving image: $e');
      return '';
    }
  }

  Future<void> createFolderInDocument() async {
    try {
      // Get the path to the Pictures directory
      final Directory? picturesDirectory = await getExternalStorageDirectory();
      if (picturesDirectory == null) {
        throw Exception("Unable to get pictures directory");
      }
      // Path ที่ต้องการสร้างโฟลเดอร์ย่อย
      final String subFolderPath = '$mainFolderPath/image';

      // สร้างโฟลเดอร์หลัก
      final Directory mainDirectory = Directory(mainFolderPath);
      if (!await mainDirectory.exists()) {
        await mainDirectory.create(recursive: true);
      }

      // สร้างโฟลเดอร์ย่อย
      final Directory subDirectory = Directory(subFolderPath);
      if (!await subDirectory.exists()) {
        await subDirectory.create(recursive: true);
      }
    } catch (e) {
      print('Error creating folder: $e');
    }
  }
}
