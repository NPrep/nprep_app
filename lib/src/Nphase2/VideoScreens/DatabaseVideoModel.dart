import 'dart:convert';

class VideoModel {
  final int id;
  final int videokey;
  final String videotitle;
  final String videostamps;
  final String videonotes;
  final String videopath;
  final String videothumbimage;
  final String videoduration;

  VideoModel({
     this.id,
     this.videokey,
     this.videotitle,
     this.videostamps,
     this.videonotes,
     this.videopath,
     this.videothumbimage,
     this.videoduration,
  });

  // Convert a JSON object to a VideoModel instance
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      videokey: json['videokey'],
      videotitle: json['videotitle'],
      videostamps: json['videostamps'],
      videonotes: json['videonotes'],
      videopath: json['videopath'],
      videothumbimage: json['videothumbimage'],
      videoduration: json['videoduration'],
    );
  }

  // Convert a VideoModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videotitle': videotitle,
      'videostamps': videostamps,
      'videonotes': videonotes,
      'videopath': videopath,
      'videothumbimage': videothumbimage,
      'videoduration': videoduration,
    };
  }
}

class VideoStamp {
   dynamic videoId;
   dynamic title;
   dynamic time;
   dynamic status;
  dynamic deletedAt;

  VideoStamp({
     this.videoId,
     this.title,
     this.time,
     this.status,
    this.deletedAt,
  });

  factory VideoStamp.fromJson(Map<String, dynamic> json) {
    return VideoStamp(
      videoId: json['video_id'],
      title: json['title'],
      time: json['time'],
      status: json['status'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'title': title,
      'time': time,
      'status': status,
      'deleted_at': deletedAt,
    };
  }
}
