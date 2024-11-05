class Exam {
  int id;
  String image;
  int examType;
  int subject;
  String title;
  int feeType;
  String examYear;
  int userTag;
  int examDuration;
  String description;
  int sortOrder;
  int status;
  int isPublished;

  Exam({
    this.id,
    this.image,
    this.examType,
    this.subject,
    this.title,
    this.feeType,
    this.examYear,
    this.userTag,
    this.examDuration,
    this.description,
    this.sortOrder,
    this.status,
    this.isPublished,
  });

  // Convert an Exam into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'exam_type': examType,
      'subject': subject,
      'title': title,
      'fee_type': feeType,
      'exam_year': examYear,
      'user_tag': userTag,
      'exam_duration': examDuration,
      'description': description,
      'sort_order': sortOrder,
      'status': status,
      'is_published': isPublished
    };
  }

  // A method that retrieves an Exam from a Map.
  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      image: map['image'],
      examType: map['exam_type'],
      subject: map['subject'],
      title: map['title'],
      feeType: map['fee_type'],
      examYear: map['exam_year'],
      userTag: map['user_tag'],
      examDuration: map['exam_duration'],
      description: map['description'],
      sortOrder: map['sort_order'],
      status: map['status'],
      isPublished: map['is_published']
    );
  }
}
