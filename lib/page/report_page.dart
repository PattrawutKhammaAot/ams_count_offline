import 'package:count_offline/component/custom_dropdown2.dart';
import 'package:count_offline/component/label.dart';
import 'package:count_offline/extension/color_extension.dart';
import 'package:count_offline/main.dart';
import 'package:count_offline/model/report/ViewReportListPlan.dart';
import 'package:count_offline/services/database/report_db.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<ViewReportListPlan> itemList = [];
  List<ViewReportListPlan> _tempItemList = [];
  String valueselected = '';

  TextEditingController uncheck = TextEditingController(),
      checked = TextEditingController();

  @override
  void initState() {
    ReportDB().getList().then((value) {
      itemList = value;
      _tempItemList = value;

      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  void _viewItem(String value) {
    List<ViewReportListPlan> searchResults =
        _tempItemList.where((element) => element.check == value).toList();
    if (searchResults.isNotEmpty) {
      itemList = searchResults;
    } else {
      itemList = _tempItemList;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Label(
            "Report",
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                color: AppColors.contentColorBlue,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.88),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: Column(
                        children: [
                          itemList.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: itemList.length,
                                      itemBuilder: ((context, index) {
                                        return itemList[index].plan ==
                                                valueselected
                                            ? ListTile(
                                                title: Text(
                                                  "Plan : ${itemList[index].plan}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Label(
                                                          "Uncheck : ",
                                                          color: Colors.black,
                                                        ),
                                                        Label(
                                                          "${itemList[index].uncheck}",
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Label(
                                                          "Check : ",
                                                          color: AppColors
                                                              .contentColorBlue,
                                                        ),
                                                        Label(
                                                          "${itemList[index].check}",
                                                          color: Colors.green,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox.fromSize();
                                      })))
                              : const Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [CircularProgressIndicator()],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    Card(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 8, left: 8, bottom: 8),
                        child: Column(
                          children: [
                            itemList.isNotEmpty
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: SizedBox(
                                            child: CustomDropdownButton2(
                                              hintText:
                                                  "Please Select Plan Code",
                                              items: itemList.map((item) {
                                                return DropdownMenuItem<
                                                    dynamic>(
                                                  value: item.plan,
                                                  child: Text(
                                                    "${item.plan}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) async {
                                                valueselected = value;
                                                uncheck.text = itemList
                                                    .where((element) =>
                                                        element.plan ==
                                                        valueselected)
                                                    .first
                                                    .uncheck
                                                    .toString();
                                                checked.text = itemList
                                                    .where((element) =>
                                                        element.plan ==
                                                        valueselected)
                                                    .first
                                                    .check
                                                    .toString();
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.fromSize(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Label(
                                      "UnCheck : ",
                                      color: AppColors.contentColorBlue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      style: TextStyle(
                                          fontSize: 26, color: Colors.black),
                                      controller: uncheck,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(4),
                                          filled: true,
                                          fillColor: Colors.transparent),
                                    )),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _viewItem(status_uncheck),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: AppColors.contentColorBlue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(child: Label("View")),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Label(
                                      "Check : ",
                                      color: AppColors.contentColorBlue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      textAlignVertical:
                                          TextAlignVertical.bottom,
                                      controller: checked,
                                      style: TextStyle(fontSize: 26),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(4),
                                          filled: true,
                                          fillColor: Colors.transparent),
                                    )),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _viewItem(status_checked),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: AppColors.contentColorBlue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(child: Label("View")),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
