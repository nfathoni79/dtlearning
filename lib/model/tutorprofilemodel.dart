// To parse this JSON data, do
//
//     final tutorprofilemodel = tutorprofilemodelFromJson(jsonString);

import 'dart:convert';

Tutorprofilemodel tutorprofilemodelFromJson(String str) =>
    Tutorprofilemodel.fromJson(json.decode(str));

String tutorprofilemodelToJson(Tutorprofilemodel data) =>
    json.encode(data.toJson());

class Tutorprofilemodel {
  Tutorprofilemodel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory Tutorprofilemodel.fromJson(Map<String, dynamic> json) =>
      Tutorprofilemodel(
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
      };
}
