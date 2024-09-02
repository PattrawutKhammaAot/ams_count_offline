import 'package:count_offline/component/custom_botToast.dart';
import 'package:count_offline/main.dart';
import 'package:count_offline/services/database/gallery_db.dart';
import 'package:count_offline/services/database/import_db.dart';

class SettingsDB {
  Future<void> deleteAllData() async {
    final db = await appDb.database;
    final result = await db.delete(ImportDB.field_tableName);
    if (result != 0) {
      CustomBotToast.showSuccess(appLocalization.localizations.delete_all_Data);
    } else {
      CustomBotToast.showError(appLocalization.localizations.failed_to_delete);
    }
  }

  Future<void> deleteAllImage() async {
    final db = await appDb.database;
    final result = await db.delete(GalleryDB.field_tableName);
    if (result != 0) {
      CustomBotToast.showSuccess(
          appLocalization.localizations.delete_all_images);
    } else {
      CustomBotToast.showError(appLocalization.localizations.failed_to_delete);
    }
  }
}
