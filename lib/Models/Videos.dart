class Video {
  int id;
  int videoMainCategory;
  int videoCategoryId;
  String title;
  String thumbImage;
  String videoTime;
  String videoTextNotes;
  int feeType;
  int sortId;
  int isPublished;
  int status;

  Video({
    this.id,
    this.videoMainCategory,
    this.videoCategoryId,
    this.title,
    this.thumbImage,
    this.videoTime,
    this.videoTextNotes,
    this.feeType,
    this.sortId,
    this.isPublished,
    this.status,
  });

  // Convert a Video into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'video_main_category': videoMainCategory,
      'video_category_id': videoCategoryId,
      'title': title,
      'thumb_image': thumbImage,
      'video_time': videoTime,
      'video_text_notes': videoTextNotes,
      'fee_type': feeType,
      'sort_id': sortId,
      'is_published': isPublished,
      'status': status,
    };
  }

  // A method that retrieves a Video from a Map.
  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      videoMainCategory: map['video_main_category'],
      videoCategoryId: map['video_category_id'],
      title: map['title'],
      thumbImage: map['thumb_image'],
      videoTime: map['video_time'],
      videoTextNotes: map['video_text_notes'],
      feeType: map['fee_type'],
      sortId: map['sort_id'],
      isPublished: map['is_published'],
      status: map['status'],
    );
  }
}
