// To parse this JSON data, do
//
//     final cartdeleteModel = cartdeleteModelFromJson(jsonString);

import 'dart:convert';

CartdeleteModel cartdeleteModelFromJson(String str) =>
    CartdeleteModel.fromJson(json.decode(str));

String cartdeleteModelToJson(CartdeleteModel data) =>
    json.encode(data.toJson());

class CartdeleteModel {
  CartdeleteModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory CartdeleteModel.fromJson(Map<String, dynamic> json) =>
      CartdeleteModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
