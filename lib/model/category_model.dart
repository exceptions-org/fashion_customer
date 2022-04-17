import 'dart:convert';

import 'package:flutter/foundation.dart';

class FetchCategoryModel {
  final CategoryModel category;
  final List<CategoryModel> subcategory;
  FetchCategoryModel({
    required this.category,
    required this.subcategory,
  });

  FetchCategoryModel copyWith({
    CategoryModel? category,
    List<CategoryModel>? subcategory,
  }) {
    return FetchCategoryModel(
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'subcategory': subcategory.map((x) => x.toMap()).toList(),
    };
  }

  factory FetchCategoryModel.fromMap(Map<String, dynamic> map) {
    return FetchCategoryModel(
      category: CategoryModel.fromMap(map['category']),
      subcategory: List<CategoryModel>.from(map['subcategory']?.map((x) => CategoryModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FetchCategoryModel.fromJson(String source) => FetchCategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'FetchCategoryModel(category: $category, subcategory: $subcategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is FetchCategoryModel &&
      other.category == category &&
      listEquals(other.subcategory, subcategory);
  }

  @override
  int get hashCode => category.hashCode ^ subcategory.hashCode;
}

class CategoryModel {
  final String name;
  final String id;
  final String imageUrl;
  final String description;
  CategoryModel({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.description,
  });

  CategoryModel copyWith({
    String? name,
    String? id,
    String? imageUrl,
    String? description,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(name: $name, id: $id, imageUrl: $imageUrl, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.name == name &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.description == description;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        imageUrl.hashCode ^
        description.hashCode;
  }
}
