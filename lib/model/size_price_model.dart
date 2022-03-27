import 'dart:convert';

import 'package:flutter/foundation.dart';

class SizePriceModel {
  final String size;
  final List<ColorPriceModel> colorPrice;
  SizePriceModel({
    required this.size,
    required this.colorPrice,
  });
  

  SizePriceModel copyWith({
    String? size,
    List<ColorPriceModel>? colorPrice,
  }) {
    return SizePriceModel(
      size: size ?? this.size,
      colorPrice: colorPrice ?? this.colorPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'colorPrice': colorPrice.map((x) => x.toMap()).toList(),
    };
  }

  factory SizePriceModel.fromMap(Map<String, dynamic> map) {
    return SizePriceModel(
      size: map['size'] ?? '',
      colorPrice: List<ColorPriceModel>.from(map['colorPrice']?.map((x) => ColorPriceModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SizePriceModel.fromJson(String source) => SizePriceModel.fromMap(json.decode(source));

  @override
  String toString() => 'SizePriceModel(size: $size, colorPrice: $colorPrice)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SizePriceModel &&
      other.size == size &&
      listEquals(other.colorPrice, colorPrice);
  }

  @override
  int get hashCode => size.hashCode ^ colorPrice.hashCode;
}

class ColorPriceModel {
  final String colorName;
  final String price;
  ColorPriceModel({
    required this.colorName,
    required this.price,
  });

  ColorPriceModel copyWith({
    String? colorName,
    String? price,
  }) {
    return ColorPriceModel(
      colorName: colorName ?? this.colorName,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'colorName': colorName,
      'price': price,
    };
  }

  factory ColorPriceModel.fromMap(Map<String, dynamic> map) {
    return ColorPriceModel(
      colorName: map['colorName'] ?? '',
      price: map['price'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorPriceModel.fromJson(String source) => ColorPriceModel.fromMap(json.decode(source));

  @override
  String toString() => 'ColorPriceModel(colorName: $colorName, price: $price)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ColorPriceModel &&
      other.colorName == colorName &&
      other.price == price;
  }

  @override
  int get hashCode => colorName.hashCode ^ price.hashCode;
}
