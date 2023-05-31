// To parse this JSON data, do
//
//     final courseDetailsModel = courseDetailsModelFromJson(jsonString);

import 'dart:convert';

CourseDetailsModel courseDetailsModelFromJson(String str) =>
    CourseDetailsModel.fromJson(json.decode(str));

String courseDetailsModelToJson(CourseDetailsModel data) =>
    json.encode(data.toJson());

class CourseDetailsModel {
  CourseDetailsModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) =>
      CourseDetailsModel(
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
    this.tutorName,
    this.tutorImage,
    this.categoryName,
    this.languageName,
    this.totalRating,
    this.totalCount,
    this.avgRating,
    this.isWishlist,
    this.isCart,
    this.courseVideo,
    this.requrirment,
    this.include,
    this.learn,
    this.tutorProfile,
    this.studentFeedback,
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
  String? tutorName;
  String? tutorImage;
  String? categoryName;
  String? languageName;
  int? totalRating;
  int? totalCount;
  double? avgRating;
  int? isWishlist;
  int? isCart;
  List<CourseVideo>? courseVideo;
  List<Include>? requrirment;
  List<Include>? include;
  List<Include>? learn;
  TutorProfile? tutorProfile;
  List<StudentFeedback>? studentFeedback;

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
        tutorName: json["tutor_name"],
        tutorImage: json["tutor_image"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        totalRating: json["total_rating"],
        totalCount: json["total_count"],
        avgRating: json["avg_rating"]?.toDouble(),
        isWishlist: json["is_wishlist"],
        isCart: json["is_cart"],
        courseVideo: List<CourseVideo>.from(
            json["course_video"].map((x) => CourseVideo.fromJson(x))),
        requrirment: List<Include>.from(
            json["requrirment"].map((x) => Include.fromJson(x))),
        include:
            List<Include>.from(json["include"].map((x) => Include.fromJson(x))),
        learn:
            List<Include>.from(json["learn"].map((x) => Include.fromJson(x))),
        tutorProfile: TutorProfile.fromJson(json["tutor_profile"]),
        studentFeedback: List<StudentFeedback>.from(
            json["student_feedback"].map((x) => StudentFeedback.fromJson(x))),
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
        "tutor_name": tutorName,
        "tutor_image": tutorImage,
        "category_name": categoryName,
        "language_name": languageName,
        "total_rating": totalRating,
        "total_count": totalCount,
        "avg_rating": avgRating,
        "is_wishlist": isWishlist,
        "is_cart": isCart,
        "course_video": List<dynamic>.from(courseVideo!.map((x) => x.toJson())),
        "requrirment": List<dynamic>.from(requrirment!.map((x) => x.toJson())),
        "include": List<dynamic>.from(include!.map((x) => x.toJson())),
        "learn": List<dynamic>.from(learn!.map((x) => x.toJson())),
        "tutor_profile": tutorProfile!.toJson(),
        "student_feedback":
            List<dynamic>.from(studentFeedback!.map((x) => x.toJson())),
      };
}

class CourseVideo {
  CourseVideo({
    this.id,
    this.courseId,
    this.name,
    this.image,
    this.video,
    this.videoType,
    this.videoUrl,
    this.description,
    this.view,
    this.download,
    this.status,
    this.isTitle,
    this.videoduration,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? courseId;
  String? name;
  String? image;
  String? video;
  String? videoType;
  String? videoUrl;
  String? description;
  int? view;
  int? download;
  int? status;
  int? isTitle;
  String? videoduration;
  String? date;
  String? createdAt;
  String? updatedAt;

  factory CourseVideo.fromJson(Map<String, dynamic> json) => CourseVideo(
        id: json["id"],
        courseId: json["course_id"],
        name: json["name"],
        image: json["image"],
        video: json["video"],
        videoType: json["video_type"],
        videoUrl: json["video_url"],
        description: json["description"],
        view: json["view"],
        download: json["download"],
        status: json["status"],
        isTitle: json["is_title"],
        videoduration: json["video_duration"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "name": name,
        "image": image,
        "video": video,
        "video_type": videoType,
        "video_url": videoUrl,
        "description": description,
        "view": view,
        "download": download,
        "status": status,
        "is_title": isTitle,
        "video_duration": videoduration,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Include {
  Include({
    this.id,
    this.courseId,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? courseId;
  String? title;
  String? createdAt;
  String? updatedAt;

  factory Include.fromJson(Map<String, dynamic> json) => Include(
        id: json["id"],
        courseId: json["course_id"],
        title: json["title"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "title": title,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class StudentFeedback {
  StudentFeedback({
    this.id,
    this.userId,
    this.courseId,
    this.rating,
    this.comment,
    this.status,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.userName,
  });

  int? id;
  int? userId;
  int? courseId;
  String? rating;
  String? comment;
  int? status;
  int? isDelete;
  String? createdAt;
  String? updatedAt;
  String? userName;

  factory StudentFeedback.fromJson(Map<String, dynamic> json) =>
      StudentFeedback(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        rating: json["rating"],
        comment: json["comment"],
        status: json["status"],
        isDelete: json["is_delete"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "course_id": courseId,
        "rating": rating,
        "comment": comment,
        "status": status,
        "is_delete": isDelete,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_name": userName,
      };
}

class TutorProfile {
  TutorProfile({
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
    this.totalCourse,
    this.tutorImage,
    this.totalRating,
    this.totalCount,
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
  int? totalCourse;
  String? tutorImage;
  int? totalRating;
  int? totalCount;
  double? avgRating;

  factory TutorProfile.fromJson(Map<String, dynamic> json) => TutorProfile(
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
        totalCourse: json["total_course"],
        tutorImage: json["tutor_image"],
        totalRating: json["total_rating"],
        totalCount: json["total_count"],
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
        "total_course": totalCourse,
        "tutor_image": tutorImage,
        "total_rating": totalRating,
        "total_count": totalCount,
        "avg_rating": avgRating,
      };
}
