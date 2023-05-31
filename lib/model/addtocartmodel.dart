// To parse this JSON data, do
//
//     final addtocartModel = addtocartModelFromJson(jsonString);

import 'dart:convert';

AddtocartModel addtocartModelFromJson(String str) =>
    AddtocartModel.fromJson(json.decode(str));

String addtocartModelToJson(AddtocartModel data) => json.encode(data.toJson());

class AddtocartModel {
  AddtocartModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory AddtocartModel.fromJson(Map<String, dynamic> json) => AddtocartModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
