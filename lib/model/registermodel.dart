// To parse this JSON data, do
//
//     final registermodel = registermodelFromJson(jsonString);

import 'dart:convert';

Registermodel registermodelFromJson(String str) =>
    Registermodel.fromJson(json.decode(str));

String registermodelToJson(Registermodel data) => json.encode(data.toJson());

class Registermodel {
  Registermodel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory Registermodel.fromJson(Map<String, dynamic> json) => Registermodel(
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
    this.deviceToken,
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
  String? deviceToken;
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
        deviceToken: json["device_token"],
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
        "device_token": deviceToken,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
