// To parse this JSON data, do
//
//     final getPageModel = getPageModelFromJson(jsonString);

import 'dart:convert';

GetPageModel getPageModelFromJson(String str) =>
    GetPageModel.fromJson(json.decode(str));

String getPageModelToJson(GetPageModel data) => json.encode(data.toJson());

class GetPageModel {
  GetPageModel({
    this.status,
    this.message,
    this.result,
  });
  int? status;
  String? message;
  List<Result>? result;

  factory GetPageModel.fromJson(Map<String, dynamic> json) => GetPageModel(
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
    this.id,
    this.name,
    this.title,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? title;
  String? description;
  int? status;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "description": description,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
