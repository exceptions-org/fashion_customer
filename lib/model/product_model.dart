import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'category_model.dart';
import 'image_color_model.dart';
import 'size_price_model.dart';

class ProductModel {
  final String name;
  final String id;
  final String description;
  final CategoryModel category;
  final CategoryModel subCategory;
  final List<ImageColorModel> images;
  final List<SizePriceModel> prices;
  final String quality;
  final String brand;
  final double rating;
  final int orderCount;
  final int reviewCount;
  final String sizeUnit;
  final String unit;
  final double quantity;
  final double discountPrice;
  final String selectedSize;
  ProductModel({
    required this.name,
    required this.id,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.images,
    required this.prices,
    required this.quality,
    required this.brand,
    required this.rating,
    required this.orderCount,
    required this.reviewCount,
    required this.sizeUnit,
    required this.unit,
    required this.quantity,
    required this.discountPrice,
    required this.selectedSize,
  });

  ProductModel copyWith({
    String? name,
    String? id,
    String? description,
    CategoryModel? category,
    CategoryModel? subCategory,
    List<ImageColorModel>? images,
    List<SizePriceModel>? prices,
    String? quality,
    String? brand,
    double? rating,
    int? orderCount,
    int? reviewCount,
    String? sizeUnit,
    String? unit,
    double? quantity,
  }) {
    return ProductModel(
      name: name ?? this.name,
      id: id ?? this.id,
      description: description ?? this.description,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      images: images ?? this.images,
      prices: prices ?? this.prices,
      quality: quality ?? this.quality,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      orderCount: orderCount ?? this.orderCount,
      reviewCount: reviewCount ?? this.reviewCount,
      sizeUnit: sizeUnit ?? this.sizeUnit,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      discountPrice: discountPrice,
      selectedSize: selectedSize,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'description': description,
      'category': category.toMap(),
      'subCategory': subCategory.toMap(),
      'images': images.map((x) => x.toMap()).toList(),
      'prices': prices.map((x) => x.toMap()).toList(),
      'quality': quality,
      'brand': brand,
      'rating': rating,
      'orderCount': orderCount,
      'reviewCount': reviewCount,
      'sizeUnit': sizeUnit,
      'unit': unit,
      'quantity': quantity,
      'selectedSize' : selectedSize,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      discountPrice: map['discountPrice']??0,
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      category: CategoryModel.fromMap(map['category']),
      subCategory: CategoryModel.fromMap(map['subCategory']),
      images: List<ImageColorModel>.from(
          map['images']?.map((x) => ImageColorModel.fromMap(x))),
      prices: List<SizePriceModel>.from(
          map['prices']?.map((x) => SizePriceModel.fromMap(x))),
      quality: map['quality'] ?? '',
      brand: map['brand'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      orderCount: map['orderCount']?.toInt() ?? 0,
      reviewCount: map['reviewCount']?.toInt() ?? 0,
      sizeUnit: map['sizeUnit'] ?? '',
      unit: map['unit'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      selectedSize: map['selectedSize']?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(name: $name, id: $id, description: $description, category: $category, subCategory: $subCategory, images: $images, prices: $prices, quality: $quality, brand: $brand, rating: $rating, orderCount: $orderCount, reviewCount: $reviewCount, sizeUnit: $sizeUnit, unit: $unit, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.name == name &&
        other.id == id &&
        other.description == description &&
        other.category == category &&
        other.subCategory == subCategory &&
        listEquals(other.images, images) &&
        listEquals(other.prices, prices) &&
        other.quality == quality &&
        other.brand == brand &&
        other.rating == rating &&
        other.orderCount == orderCount &&
        other.reviewCount == reviewCount &&
        other.sizeUnit == sizeUnit &&
        other.unit == unit &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        description.hashCode ^
        category.hashCode ^
        subCategory.hashCode ^
        images.hashCode ^
        prices.hashCode ^
        quality.hashCode ^
        brand.hashCode ^
        rating.hashCode ^
        orderCount.hashCode ^
        reviewCount.hashCode ^
        sizeUnit.hashCode ^
        unit.hashCode ^
        quantity.hashCode;
  }
}
