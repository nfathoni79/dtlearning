// To parse this JSON data, do
//
//     final addtransectionModel = addtransectionModelFromJson(jsonString);

import 'dart:convert';

AddtransectionModel addtransectionModelFromJson(String str) =>
    AddtransectionModel.fromJson(json.decode(str));

String addtransectionModelToJson(AddtransectionModel data) =>
    json.encode(data.toJson());

class AddtransectionModel {
  AddtransectionModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory AddtransectionModel.fromJson(Map<String, dynamic> json) =>
      AddtransectionModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
