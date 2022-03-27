import 'dart:convert';

class CategoryModel {
  final String name;
  final String id;
  final String description;
  CategoryModel({
    required this.name,
    required this.id,
    required this.description,
  });

  CategoryModel copyWith({
    String? name,
    String? id,
    String? description,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryModel(name: $name, id: $id, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CategoryModel &&
      other.name == name &&
      other.id == id &&
      other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ description.hashCode;
}

