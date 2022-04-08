import 'dart:convert';

import 'package:flutter/foundation.dart';

class CartModel {
 List<String> image;
  String name;
  String price;
  String quantity;
  String productId;
  int color; 
  double discountPrice;
  CartModel({
    required this.discountPrice,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    required this.productId,
    required this.color,
  });

  CartModel copyWith({
    List<String>? image,
    String? name,
    String? price,
    String? quantity,
    String? productId,
    int? color,
  }) {
    return CartModel(
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      color: color ?? this.color,
      discountPrice: discountPrice,
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
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      image: List<String>.from(map['image']),
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      quantity: map['quantity'] ?? '',
      productId: map['productId'] ?? '',
      color: map['color']?.toInt() ?? 0,
      discountPrice: map['discountPrice']??'',
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(image: $image, name: $name, price: $price, quantity: $quantity, productId: $productId, color: $color)';
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
      other.color == color;
  }

  @override
  int get hashCode {
    return image.hashCode ^
      name.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      productId.hashCode ^
      color.hashCode;
  }
}
