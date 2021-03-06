import 'dart:convert';

import 'package:flutter/foundation.dart';

class CartModel {
  final List<String> image;
  final String name;
  double price;
  int quantity;
  String productId;
  final int color;
  final String colorName;
  double discountPrice;
  String selectedSize;
  CartModel({
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    required this.productId,
    required this.color,
    required this.colorName,
    required this.discountPrice,
    required this.selectedSize
  });

  CartModel copyWith({
    List<String>? image,
    String? name,
    double? price,
    int? quantity,
    String? productId,
    int? color,
    String? colorName,
    double? discountPrice,
    String? selectedSize,
  }) {
    return CartModel(
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      color: color ?? this.color,
      colorName: colorName ?? this.colorName,
      discountPrice: discountPrice ?? this.discountPrice,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'name': name,
      'price': price,
      'quantity': quantity,
      'productId': productId,
      'color': color,
      'colorName': colorName,
      'discountPrice': discountPrice,
      'selectedSize': selectedSize,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      image: List<String>.from(map['image']),
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toInt() ?? 0,
      productId: map['productId'] ?? '',
      color: map['color']?.toInt() ?? 0,
      colorName: map['colorName'] ?? '',
      discountPrice: map['discountPrice']?.toDouble() ?? 0.0,
      selectedSize: map['selectedSize'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(image: $image, name: $name, price: $price, quantity: $quantity, productId: $productId, color: $color, colorName: $colorName, discountPrice: $discountPrice, selectedSize: $selectedSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CartModel &&
      listEquals(other.image, image) &&
      other.name == name &&
      other.price == price &&
      other.quantity == quantity &&
      other.productId == productId &&
      other.color == color &&
      other.colorName == colorName &&
      other.discountPrice == discountPrice &&
      other.selectedSize == selectedSize;
  }

  @override
  int get hashCode {
    return image.hashCode ^
      name.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      productId.hashCode ^
      color.hashCode ^
      colorName.hashCode ^
      discountPrice.hashCode ^
      selectedSize.hashCode;
  }
}
