// To parse this JSON data, do
//
//     final viewReportListPlan = viewReportListPlanFromJson(jsonString);

import 'dart:convert';

ViewReportListPlan viewReportListPlanFromJson(String str) =>
    ViewReportListPlan.fromJson(json.decode(str));

String viewReportListPlanToJson(ViewReportListPlan data) =>
    json.encode(data.toJson());

class ViewReportListPlan {
  String? plan;
  int? uncheck;
  int? check;

  ViewReportListPlan({
    this.plan,
    this.uncheck,
    this.check,
  });

  factory ViewReportListPlan.fromJson(Map<String, dynamic> json) =>
      ViewReportListPlan(
        plan: json["Plan"],
        uncheck: json["Uncheck"],
        check: json["Check"],
      );

  Map<String, dynamic> toJson() => {
        "Plan": plan,
        "Uncheck": uncheck,
        "Check": check,
      };
}
