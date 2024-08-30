import 'package:count_offline/services/database/setting_db.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          'Setting Page',
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
              title: Text('Clear data'),
              onTap: () {
                // Add your clear transaction logic here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Clear data'),
                    content: Text('Are you sure you want to clear all data?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await SettingsDB().deleteAllData();
                          // Perform clear transaction action
                          Navigator.of(context).pop();
                        },
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.image, color: Colors.blue),
              title: Text('Clear Image'),
              onTap: () {
                // Add your clear image logic here
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Clear Image'),
                    content: Text('Are you sure you want to clear all images?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await SettingsDB().deleteAllImage();
                          // Perform clear image action
                          Navigator.of(context).pop();
                        },
                        child: Text('Clear'),
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
