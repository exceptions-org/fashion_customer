import 'dart:convert';

class CarouselModel {
  String imageUrl;
  String navigate;
  int priority;
  CarouselModel({
    required this.imageUrl,
    required this.navigate,
    required this.priority,
  });

  CarouselModel copyWith({
    String? imageUrl,
    String? navigate,
    int? priority,
  }) {
    return CarouselModel(
      imageUrl: imageUrl ?? this.imageUrl,
      navigate: navigate ?? this.navigate,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'navigate': navigate,
      'priority': priority,
    };
  }

  factory CarouselModel.fromMap(Map<String, dynamic> map) {
    return CarouselModel(
      imageUrl: map['imageUrl'] ?? '',
      navigate: map['navigate'] ?? '',
      priority: map['priority']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarouselModel.fromJson(String source) =>
      CarouselModel.fromMap(json.decode(source));

  @override
  String toString() => 'CarouselModel(imageUrl: $imageUrl, navigate: $navigate, priority: $priority)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CarouselModel &&
      other.imageUrl == imageUrl &&
      other.navigate == navigate &&
      other.priority == priority;
  }

  @override
  int get hashCode => imageUrl.hashCode ^ navigate.hashCode ^ priority.hashCode;
}
