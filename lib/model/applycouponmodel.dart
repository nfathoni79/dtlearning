// To parse this JSON data, do
//
//     final applycouponModel = applycouponModelFromJson(jsonString);

import 'dart:convert';

ApplycouponModel applycouponModelFromJson(String str) =>
    ApplycouponModel.fromJson(json.decode(str));

String applycouponModelToJson(ApplycouponModel data) =>
    json.encode(data.toJson());

class ApplycouponModel {
  ApplycouponModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory ApplycouponModel.fromJson(Map<String, dynamic> json) =>
      ApplycouponModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
