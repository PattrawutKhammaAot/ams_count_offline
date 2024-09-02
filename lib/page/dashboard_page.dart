import 'package:count_offline/component/custom_range_pointer.dart';
import 'package:count_offline/extension/color_extension.dart';
import 'package:count_offline/main.dart';
import 'package:count_offline/model/dashboard/view_dashboard_model.dart';
import 'package:count_offline/services/database/dashboard_db.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({
    super.key,
  });

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  double width = 0;
  double height = 125;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  List<ViewDashboardModel> dashboardList = [];
  Future<List<ViewDashboardModel>>? _futureDashboardList;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _futureDashboardList = DashboardDB().getListDropdown();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      // Simulate a delay for loading
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  void _refreshDashboard() {
    setState(() {
      _futureDashboardList = DashboardDB().getListDropdown();
    });
  }

  Color pastelColor(Color color) {
    return Color.fromARGB(
      color.alpha,
      (color.red + 255) ~/ 2,
      (color.green + 255) ~/ 2,
      (color.blue + 255) ~/ 2,
    );
  }

  dynamic header = AppColors.contentColorBlue;

  // ไล่สีจาก header
  List<Color> getPastelColors() {
    return [
      Colors.green,
      Colors.cyan,
      Colors.teal,
      AppColors.contentColorBlue,
      Colors.red,
      Colors.blue,
      Colors.purple,
      Colors.yellow,
      Colors.orange,
      Colors.pink,
      Colors.lime,
      Colors.amber,
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = getPastelColors();
    return RefreshIndicator(
      onRefresh: () async {
        _refreshDashboard();
        await Future.delayed(Duration(seconds: 1));
      },
      child: FutureBuilder<List<ViewDashboardModel>>(
        future: _futureDashboardList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No data available'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _refreshDashboard,
                    child: Text('Refresh'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 60),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == snapshot.data!.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final item = snapshot.data![index];
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
                                "${appLocalization.localizations.ov_plan} : ${item.plan}",
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
                                            text:
                                                "${appLocalization.localizations.ov_plan}",
                                            valueRangePointer: item.sum_asset,
                                            colorText:
                                                colors[index % colors.length],
                                            color:
                                                colors[index % colors.length],
                                            allItem: item.sum_asset,
                                            icon: Icon(
                                              Icons.assignment,
                                              color:
                                                  colors[index % colors.length],
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
                                            text:
                                                "${appLocalization.localizations.ov_images}",
                                            valueRangePointer: item.image,
                                            colorText:
                                                colors[index % colors.length],
                                            color:
                                                colors[index % colors.length],
                                            allItem: item.sum_asset,
                                            icon: Icon(
                                              Icons.image,
                                              color:
                                                  colors[index % colors.length],
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
                                            text:
                                                "${appLocalization.localizations.ov_counted}",
                                            valueRangePointer: item.check,
                                            colorText:
                                                colors[index % colors.length],
                                            color:
                                                colors[index % colors.length],
                                            allItem: item.sum_asset,
                                            icon: Icon(
                                              Icons.check,
                                              color:
                                                  colors[index % colors.length],
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
                                            text:
                                                "${appLocalization.localizations.ov_not_counted}",
                                            colorText:
                                                colors[index % colors.length],
                                            valueRangePointer: item.uncheck,
                                            color:
                                                colors[index % colors.length],
                                            allItem: item.sum_asset,
                                            icon: Icon(
                                              Icons.cancel,
                                              color:
                                                  colors[index % colors.length],
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
            );
          }
        },
      ),
    );
  }
}
