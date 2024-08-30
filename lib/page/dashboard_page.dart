// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:count_offline/component/custom_range_pointer.dart';
import 'package:count_offline/extension/color_extension.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatelessWidget {
  DashBoardPage({super.key});

  double width = 0;
  double height = 125;

  Color pastelColor(Color color) {
    return Color.fromARGB(
      color.alpha,
      (color.red + 255) ~/ 2,
      (color.green + 255) ~/ 2,
      (color.blue + 255) ~/ 2,
    );
  }

  dynamic header = AppColors.contentColorBlue;
  //ไล่สีจาก header
  List<Color> getPastelColors() {
    return [
      pastelColor(Colors.cyan),
      pastelColor(Colors.teal),
      pastelColor(Colors.indigo),
      pastelColor(Colors.blue),
      pastelColor(Colors.purple),
      pastelColor(Colors.red),
      pastelColor(Colors.green),
      pastelColor(Colors.yellow),
      pastelColor(Colors.orange),
      pastelColor(Colors.pink),
      pastelColor(Colors.lime),
      pastelColor(Colors.amber),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = getPastelColors();
    return Expanded(
      flex: 2,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: colors[index % colors.length],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          "Plan : 202409809-00001",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomRangePoint(
                                      text: "Plan",
                                      valueRangePointer: 10000,
                                      colorText: colors[index % colors.length],
                                      color: colors[index % colors.length],
                                      allItem: 50,
                                      icon: Icon(
                                        Icons.assignment,
                                        color: colors[index % colors.length],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomRangePoint(
                                      text: "Images",
                                      valueRangePointer: 10,
                                      colorText: colors[index % colors.length],
                                      color: colors[index % colors.length],
                                      allItem: 50,
                                      icon: Icon(
                                        Icons.image,
                                        color: colors[index % colors.length],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomRangePoint(
                                      text: "Check",
                                      valueRangePointer: 10,
                                      colorText: colors[index % colors.length],
                                      color: colors[index % colors.length],
                                      allItem: 50,
                                      icon: Icon(
                                        Icons.check,
                                        color: colors[index % colors.length],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomRangePoint(
                                      text: "Uncheck",
                                      colorText: colors[index % colors.length],
                                      valueRangePointer: 10,
                                      color: colors[index % colors.length],
                                      allItem: 50,
                                      icon: Icon(
                                        Icons.cancel,
                                        color: colors[index % colors.length],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
