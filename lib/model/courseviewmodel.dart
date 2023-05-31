// To parse this JSON data, do
//
//     final courseviewModel = courseviewModelFromJson(jsonString);

import 'dart:convert';

CourseviewModel courseviewModelFromJson(String str) =>
    CourseviewModel.fromJson(json.decode(str));

String courseviewModelToJson(CourseviewModel data) =>
    json.encode(data.toJson());

class CourseviewModel {
  CourseviewModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory CourseviewModel.fromJson(Map<String, dynamic> json) =>
      CourseviewModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
