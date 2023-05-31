// To parse this JSON data, do
//
//     final browsecategoryModel = browsecategoryModelFromJson(jsonString);

import 'dart:convert';

BrowsecategoryModel browsecategoryModelFromJson(String str) =>
    BrowsecategoryModel.fromJson(json.decode(str));

String browsecategoryModelToJson(BrowsecategoryModel data) =>
    json.encode(data.toJson());

class BrowsecategoryModel {
  BrowsecategoryModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory BrowsecategoryModel.fromJson(Map<String, dynamic> json) =>
      BrowsecategoryModel(
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
    this.languageId,
    this.name,
    this.image,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? languageId;
  String? name;
  String? image;
  String? status;
  String? date;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        languageId: json["language_id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "language_id": languageId,
        "name": name,
        "image": image,
        "status": status,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
