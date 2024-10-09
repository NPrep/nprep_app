class Category {
  final int id;
  final String slug;
  final int parentId;
  final String name;
  final String description;
  final String lecturerName;
  final String lecturerAbout;
  final int feeType;
  final String metaTitle;
  final String metaKeyword;
  final String metaDescription;
  final int isFeature;
  final String image;
  final int sortOrder;
  final int status;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;

  Category({
    this.id,
    this.slug,
    this.parentId,
    this.name,
    this.description,
    this.lecturerName,
    this.lecturerAbout,
    this.feeType,
    this.metaTitle,
    this.metaKeyword,
    this.metaDescription,
    this.isFeature = 0,
    this.image,
    this.sortOrder = 0,
    this.status = 1,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  // Convert a Category into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
      'parent_id': parentId,
      'name': name,
      'description': description,
      'lecturer_name': lecturerName,
      'lecturer_about': lecturerAbout,
      'fee_type': feeType,
      'meta_title': metaTitle,
      'meta_keyword': metaKeyword,
      'meta_description': metaDescription,
      'is_feature': isFeature,
      'image': image,
      'sort_order': sortOrder,
      'status': status,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Convert a Map into a Category object
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      slug: map['slug'],
      parentId: map['parent_id'],
      name: map['name'],
      description: map['description'],
      lecturerName: map['lecturer_name'],
      lecturerAbout: map['lecturer_about'],
      feeType: map['fee_type'],
      metaTitle: map['meta_title'],
      metaKeyword: map['meta_keyword'],
      metaDescription: map['meta_description'],
      isFeature: map['is_feature'],
      image: map['image'],
      sortOrder: map['sort_order'],
      status: map['status'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  // To print the Category in a readable format
  @override
  String toString() {
    return 'Category{id: $id, name: $name, lecturer: $lecturerName, status: $status}';
  }
}
