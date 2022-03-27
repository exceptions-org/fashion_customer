import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageColorModel {
  String colorName;
  int colorCode;
  List<String> images;
  ImageColorModel({
    required this.colorName,
    required this.colorCode,
    required this.images,
  });

  ImageColorModel copyWith({
    String? colorName,
    int? colorCode,
    List<String>? images,
  }) {
    return ImageColorModel(
      colorName: colorName ?? this.colorName,
      colorCode: colorCode ?? this.colorCode,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'colorName': colorName,
      'colorCode': colorCode,
      'images': images,
    };
  }

  factory ImageColorModel.fromMap(Map<String, dynamic> map) {
    return ImageColorModel(
      colorName: map['colorName'] ?? '',
      colorCode: map['colorCode'] ?? Colors.white.value,
      images: List<String>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageColorModel.fromJson(String source) =>
      ImageColorModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ImageColorModel(colorName: $colorName, colorCode: $colorCode, images: $images)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageColorModel &&
        other.colorName == colorName &&
        other.colorCode == colorCode &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode => colorName.hashCode ^ colorCode.hashCode ^ images.hashCode;
}
