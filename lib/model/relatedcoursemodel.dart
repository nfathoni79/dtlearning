// To parse this JSON data, do
//
//     final relatedcourseModel = relatedcourseModelFromJson(jsonString);

import 'dart:convert';

RelatedcourseModel relatedcourseModelFromJson(String str) =>
    RelatedcourseModel.fromJson(json.decode(str));

String relatedcourseModelToJson(RelatedcourseModel data) =>
    json.encode(data.toJson());

class RelatedcourseModel {
  RelatedcourseModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory RelatedcourseModel.fromJson(Map<String, dynamic> json) =>
      RelatedcourseModel(
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
    this.categoryId,
    this.languageId,
    this.subcategoryId,
    this.tutorId,
    this.name,
    this.image,
    this.description,
    this.sortDescription,
    this.duration,
    this.level,
    this.price,
    this.oldPrice,
    this.view,
    this.download,
    this.status,
    this.isPremium,
    this.isFetured,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.languageName,
    this.tutorName,
    this.totalRating,
    this.totalCount,
    this.avgRating,
    this.isWishlist,
    this.isCart,
  });

  int? id;
  int? categoryId;
  int? languageId;
  int? subcategoryId;
  int? tutorId;
  String? name;
  String? image;
  String? description;
  String? sortDescription;
  String? duration;
  String? level;
  String? price;
  String? oldPrice;
  int? view;
  int? download;
  int? status;
  String? isPremium;
  int? isFetured;
  String? date;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? languageName;
  String? tutorName;
  int? totalRating;
  int? totalCount;
  double? avgRating;
  int? isWishlist;
  int? isCart;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        subcategoryId: json["subcategory_id"],
        tutorId: json["tutor_id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        sortDescription: json["sort_description"],
        duration: json["duration"],
        level: json["level"],
        price: json["price"],
        oldPrice: json["old_price"],
        view: json["view"],
        download: json["download"],
        status: json["status"],
        isPremium: json["is_premium"],
        isFetured: json["is_fetured"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        tutorName: json["tutor_name"],
        totalRating: json["total_rating"],
        totalCount: json["total_count"],
        avgRating: json["avg_rating"].toDouble(),
        isWishlist: json["is_wishlist"],
        isCart: json["is_cart"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "language_id": languageId,
        "subcategory_id": subcategoryId,
        "tutor_id": tutorId,
        "name": name,
        "image": image,
        "description": description,
        "sort_description": sortDescription,
        "duration": duration,
        "level": level,
        "price": price,
        "old_price": oldPrice,
        "view": view,
        "download": download,
        "status": status,
        "is_premium": isPremium,
        "is_fetured": isFetured,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_name": categoryName,
        "language_name": languageName,
        "tutor_name": tutorName,
        "total_rating": totalRating,
        "total_count": totalCount,
        "avg_rating": avgRating,
        "is_wishlist": isWishlist,
        "is_cart": isCart,
      };
}
