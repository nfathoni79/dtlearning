// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
    this.email,
    this.password,
    this.mobileNumber,
    this.image,
    this.backgroundImage,
    this.type,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? fullname;
  String? email;
  String? password;
  String? mobileNumber;
  String? image;
  String? backgroundImage;
  int? type;
  int? status;
  String? date;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        password: json["password"],
        mobileNumber: json["mobile_number"],
        image: json["image"],
        backgroundImage: json["background_image"],
        type: json["type"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "password": password,
        "mobile_number": mobileNumber,
        "image": image,
        "background_image": backgroundImage,
        "type": type,
        "status": status,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
