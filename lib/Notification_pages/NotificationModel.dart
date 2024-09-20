// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  RedirectionInfo redirectionInfo;
  int redirectionType;

  NotificationModel({
    this.redirectionInfo,
    this.redirectionType,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    redirectionInfo: RedirectionInfo.fromJson(json["redirection_info"]),
    redirectionType: json["redirection_type"],
  );

  Map<String, dynamic> toJson() => {
    "redirection_info": redirectionInfo.toJson(),
    "redirection_type": redirectionType,
  };
}

class RedirectionInfo {
  String redirectionPage;
  String examType;
  String moduleId;
  String moduleName;
  String indexId;
  dynamic externalLink;

  RedirectionInfo({
    this.redirectionPage,
    this.examType,
    this.moduleId,
    this.moduleName,
    this.indexId,
    this.externalLink,
  });

  factory RedirectionInfo.fromJson(Map<String, dynamic> json) => RedirectionInfo(
    redirectionPage: json["redirection_page"],
    examType: json["exam_type"],
    moduleId: json["module_id"],
    moduleName: json["module_name"],
    indexId: json["index_id"],
    externalLink: json["external_link"],
  );

  Map<String, dynamic> toJson() => {
    "redirection_page": redirectionPage,
    "exam_type": examType,
    "module_id": moduleId,
    "module_name": moduleName,
    "index_id": indexId,
    "external_link": externalLink,
  };
}
