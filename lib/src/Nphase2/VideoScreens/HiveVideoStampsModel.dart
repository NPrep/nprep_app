// To parse this JSON data, do
//
//     final stamp = stampFromJson(jsonString);

import 'dart:convert';

List<Stamp> stampFromJson(String str) => List<Stamp>.from(json.decode(str).map((x) => Stamp.fromJson(x)));

String stampToJson(List<Stamp> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stamp {
  int videoId;
  String title;
  dynamic time;
  int status;
  dynamic deletedAt;

  Stamp({
    this.videoId,
    this.title,
    this.time,
    this.status,
    this.deletedAt,
  });

  factory Stamp.fromJson(Map<String, dynamic> json) => Stamp(
    videoId: json["video_id"],
    title: json["title"],
    time: json["time"],
    status: json["status"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "video_id": videoId,
    "title": title,
    "time": time,
    "status": status,
    "deleted_at": deletedAt,
  };
}
