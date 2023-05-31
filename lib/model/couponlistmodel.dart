// To parse this JSON data, do
//
//     final couponlistModel = couponlistModelFromJson(jsonString);

import 'dart:convert';

CouponlistModel couponlistModelFromJson(String str) =>
    CouponlistModel.fromJson(json.decode(str));

String couponlistModelToJson(CouponlistModel data) =>
    json.encode(data.toJson());

class CouponlistModel {
  CouponlistModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory CouponlistModel.fromJson(Map<String, dynamic> json) =>
      CouponlistModel(
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
    this.couponCode,
    this.price,
    this.amountType,
    this.startDate,
    this.endDate,
    this.type,
    this.useLimit,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? couponCode;
  String? price;
  String? amountType;
  String? startDate;
  String? endDate;
  int? type;
  String? useLimit;
  int? status;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        couponCode: json["coupon_code"],
        price: json["price"],
        amountType: json["amount_type"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        type: json["type"],
        useLimit: json["use_limit"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_code": couponCode,
        "price": price,
        "amount_type": amountType,
        "start_date": startDate,
        "end_date": endDate,
        "type": type,
        "use_limit": useLimit,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
