import 'package:count_offline/main.dart';
import 'package:count_offline/services/database/setting_db.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          appLocalization.localizations.setting_title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text(appLocalization.localizations.setting_btn_clear_data),
              onTap: () {
                // Add your clear transaction logic here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(appLocalization
                        .localizations.setting_alert_clear_data_title),
                    content: Text(appLocalization
                        .localizations.setting_alert_clear_data_content),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                            appLocalization.localizations.import_btn_cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          await SettingsDB().deleteAllData(context);
                          // Perform clear transaction action
                          Navigator.of(context).pop();
                        },
                        child: Text(
                            appLocalization.localizations.import_btn_delete),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.image, color: Colors.blue),
              title:
                  Text(appLocalization.localizations.setting_btn_clear_image),
              onTap: () {
                // Add your clear image logic here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(appLocalization
                        .localizations.setting_alert_clear_image_title),
                    content: Text(appLocalization
                        .localizations.setting_alert_clear_image_content),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                            appLocalization.localizations.import_btn_cancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          await SettingsDB().deleteAllImage(context);
                          // Perform clear image action
                          Navigator.of(context).pop();
                        },
                        child: Text(
                            appLocalization.localizations.import_btn_delete),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
