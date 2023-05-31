// To parse this JSON data, do
//
//     final contectusModel = contectusModelFromJson(jsonString);

import 'dart:convert';

ContectusModel contectusModelFromJson(String str) =>
    ContectusModel.fromJson(json.decode(str));

String contectusModelToJson(ContectusModel data) => json.encode(data.toJson());

class ContectusModel {
  ContectusModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory ContectusModel.fromJson(Map<String, dynamic> json) => ContectusModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.fullname,
    this.email,
    this.mobileNumber,
    this.message,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? fullname;
  String? email;
  String? mobileNumber;
  String? message;
  String? updatedAt;
  String? createdAt;
  int? id;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        fullname: json["fullname"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        message: json["message"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "email": email,
        "mobile_number": mobileNumber,
        "message": message,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "id": id,
      };
}
