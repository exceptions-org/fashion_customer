import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final List<String> images;
  final Timestamp createdAt;
  final List<String> productId;
  final double rating;
  final String userPhone;
  final String userName;
  final String review;
  final String heading;
  ReviewModel({
    required this.createdAt,
    required this.productId,
    required this.rating,
    required this.review,
    required this.images,
    required this.userName,
    required this.userPhone,
    required this.heading,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'userName': userName,
      'userPhone': userPhone,
      'productId': productId,
      'rating': rating,
      'review': review,
      'images': images,
      'heading': heading,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      images: map['images'] != null && map['images']?.length != 0
          ? List.from(map['images'])
          : [],
      productId: List.from(map['productId']),
      userName: map['userName'],
      userPhone: map['userPhone'],
      createdAt: map['createdAt'],
      rating: map['rating']?.toDouble() ?? 0.0,
      review: map['review'] ?? '',
      heading: map['heading'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) =>
      ReviewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewModel(createdAt: $createdAt, productId: $productId, rating: $rating, review: $review,userName:$userName,userPhone:$userPhone,images:$images),';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewModel &&
        other.createdAt == createdAt &&
        other.productId == productId &&
        other.rating == rating &&
        other.review == review &&
        other.images == images &&
        other.userName == userName &&
        other.userPhone == userPhone;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        productId.hashCode ^
        rating.hashCode ^
        review.hashCode ^
        images.hashCode ^
        userName.hashCode ^
        userPhone.hashCode;
  }
}
