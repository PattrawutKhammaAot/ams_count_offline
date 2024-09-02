import 'package:count_offline/component/custom_dropdown2.dart';
import 'package:count_offline/component/custombutton.dart';
import 'package:count_offline/extension/color_extension.dart';
import 'package:count_offline/main.dart';
import 'package:count_offline/services/database/export_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

class ExportPage extends StatefulWidget {
  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final List<String> items = [];

  @override
  void initState() {
    ExportDB().getPlan().then((value) {
      setState(() {
        items.addAll(value);
      });
    });
    super.initState();
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.contentColorBlue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(appLocalization.localizations.export_title,
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: AppColors.contentColorBlue,
              child: Column(
                children: [
                  CustomDropdownButton2(
                    hintText: appLocalization.localizations.export_downdown,
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      selectedValue = value.toString();
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            selectedValue != null
                ? CustomButton(
                    isUseIcon: false,
                    text: appLocalization.localizations.export_btn_export,
                    color: AppColors.contentColorBlue,
                    onPressed: () async {
                      EasyLoading.show(status: 'loading data ...');
                      await ExportDB().createFolderInDocument();
                      await ExportDB().ExportAllAssetByPlan(selectedValue!);
                    },
                  )
                : SizedBox.fromSize(),
            // Container(
            //   color: AppColors.contentColorBlack,
            //   child: Column(
            //     children: [Text("data")],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
