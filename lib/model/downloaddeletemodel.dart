// To parse this JSON data, do
//
//     final downloaddeleteModel = downloaddeleteModelFromJson(jsonString);

import 'dart:convert';

DownloaddeleteModel downloaddeleteModelFromJson(String str) => DownloaddeleteModel.fromJson(json.decode(str));

String downloaddeleteModelToJson(DownloaddeleteModel data) => json.encode(data.toJson());

class DownloaddeleteModel {
    DownloaddeleteModel({
         this.status,
         this.message,
    });

    int? status;
    String? message;

    factory DownloaddeleteModel.fromJson(Map<String, dynamic> json) => DownloaddeleteModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
