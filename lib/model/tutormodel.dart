// To parse this JSON data, do
//
//     final tutorModel = tutorModelFromJson(jsonString);

import 'dart:convert';

TutorModel tutorModelFromJson(String str) =>
    TutorModel.fromJson(json.decode(str));

String tutorModelToJson(TutorModel data) => json.encode(data.toJson());

class TutorModel {
  TutorModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory TutorModel.fromJson(Map<String, dynamic> json) => TutorModel(
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
    this.fullname,
    this.mobile,
    this.email,
    this.password,
    this.designation,
    this.about,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.google,
    this.image,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.totalRating,
    this.totalCount,
    this.totalTutorCount,
    this.avgRating,
  });

  int? id;
  String? fullname;
  String? mobile;
  String? email;
  String? password;
  String? designation;
  String? about;
  String? facebook;
  String? twitter;
  String? linkedin;
  String? google;
  String? image;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? totalRating;
  int? totalCount;
  int? totalTutorCount;
  double? avgRating;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        fullname: json["fullname"],
        mobile: json["mobile"],
        email: json["email"],
        password: json["password"],
        designation: json["designation"],
        about: json["about"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        linkedin: json["linkedin"],
        google: json["google"],
        image: json["image"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        totalRating: json["total_rating"],
        totalCount: json["total_count"],
        totalTutorCount: json["total_tutor_count"],
        avgRating: json["avg_rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "mobile": mobile,
        "email": email,
        "password": password,
        "designation": designation,
        "about": about,
        "facebook": facebook,
        "twitter": twitter,
        "linkedin": linkedin,
        "google": google,
        "image": image,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "total_rating": totalRating,
        "total_count": totalCount,
        "total_tutor_count": totalTutorCount,
        "avg_rating": avgRating,
      };
}
