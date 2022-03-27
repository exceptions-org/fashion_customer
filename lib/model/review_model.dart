import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final Timestamp createdAt;
  final String uid;
  final double rating;
  final String review;
  ReviewModel({
    required this.createdAt,
    required this.uid,
    required this.rating,
    required this.review,
  });

  ReviewModel copyWith({
    Timestamp? createdAt,
    String? uid,
    double? rating,
    String? review,
  }) {
    return ReviewModel(
      createdAt: createdAt ?? this.createdAt,
      uid: uid ?? this.uid,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toMap() {
    return {
    //  'createdAt': createdAt.toMap(),
      'uid': uid,
      'rating': rating,
      'review': review,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      createdAt: map['createdAt'],
      uid: map['uid'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      review: map['review'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewModel.fromJson(String source) => ReviewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewModel(createdAt: $createdAt, uid: $uid, rating: $rating, review: $review)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ReviewModel &&
      other.createdAt == createdAt &&
      other.uid == uid &&
      other.rating == rating &&
      other.review == review;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
      uid.hashCode ^
      rating.hashCode ^
      review.hashCode;
  }
}
