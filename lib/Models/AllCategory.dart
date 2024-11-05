class AllCategory {
  final int id;
  final String slug;
  final int parentId;
  final String name;
  final String description;
  final String metaTitle;
  final String metaKeyword;
  final String metaDescription;
  final int feeType;
  final int isFeature;
  final int isMixed;
  final String image;
  final int sortOrder;
  final int status;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;
  final int totalQuestions;

  AllCategory({
    this.id,
    this.slug,
    this.parentId,
    this.name,
    this.description,
    this.metaTitle,
    this.metaKeyword,
    this.metaDescription,
    this.feeType,
    this.isFeature = 0,
    this.isMixed = 0,
    this.image,
    this.sortOrder = 0,
    this.status = 1,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.totalQuestions
  });

  // Convert an AllCategory into a Map. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
      'parent_id': parentId,
      'name': name,
      'description': description,
      'meta_title': metaTitle,
      'meta_keyword': metaKeyword,
      'meta_description': metaDescription,
      'fee_type': feeType,
      'is_feature': isFeature,
      'is_mixed': isMixed,
      'image': image,
      'sort_order': sortOrder,
      'status': status,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'total_questions' : totalQuestions
    };
  }

  // Convert a Map into an AllCategory object
  factory AllCategory.fromMap(Map<String, dynamic> map) {
    return AllCategory(
      id: map['id'],
      slug: map['slug'],
      parentId: map['parent_id'],
      name: map['name'],
      description: map['description'],
      metaTitle: map['meta_title'],
      metaKeyword: map['meta_keyword'],
      metaDescription: map['meta_description'],
      feeType: map['fee_type'],
      isFeature: map['is_feature'],
      isMixed: map['is_mixed'],
      image: map['image'],
      sortOrder: map['sort_order'],
      status: map['status'],
      deletedAt: map['deleted_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
        totalQuestions: map['total_questions']
    );
  }
}
