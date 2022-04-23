import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CouponModel {
  final String couponCode;
  final String couponName;
  final String couponDescription;
  final String couponImage;
  final Timestamp couponExpiryDate;
  final bool isByPercent;
  final double couponDiscount;
  final double minPrice;
  final bool isSingleUse;
  final bool isActive;
  final Timestamp createdAt;
  final int usedCount;
  final List<String> forUsers;
  final List<String> usedBy;
  CouponModel({
    required this.couponCode,
    required this.couponName,
    required this.couponDescription,
    required this.couponImage,
    required this.couponExpiryDate,
    required this.isByPercent,
    required this.couponDiscount,
    required this.minPrice,
    required this.isSingleUse,
    required this.isActive,
    required this.createdAt,
    required this.usedCount,
    required this.forUsers,
    required this.usedBy,
  });

  CouponModel copyWith({
    String? couponCode,
    String? couponName,
    String? couponDescription,
    String? couponImage,
    Timestamp? couponExpiryDate,
    bool? isByPercent,
    double? couponDiscount,
    double? minPrice,
    bool? isSingleUse,
    bool? isActive,
    Timestamp? createdAt,
    int? usedCount,
    List<String>? forUsers,
    List<String>? usedBy,
  }) {
    return CouponModel(
      couponCode: couponCode ?? this.couponCode,
      couponName: couponName ?? this.couponName,
      couponDescription: couponDescription ?? this.couponDescription,
      couponImage: couponImage ?? this.couponImage,
      couponExpiryDate: couponExpiryDate ?? this.couponExpiryDate,
      isByPercent: isByPercent ?? this.isByPercent,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      minPrice: minPrice ?? this.minPrice,
      isSingleUse: isSingleUse ?? this.isSingleUse,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      usedCount: usedCount ?? this.usedCount,
      forUsers: forUsers ?? this.forUsers,
      usedBy: usedBy ?? this.usedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'couponCode': couponCode,
      'couponName': couponName,
      'couponDescription': couponDescription,
      'couponImage': couponImage,
      'couponExpiryDate': couponExpiryDate,
      'isByPercent': isByPercent,
      'couponDiscount': couponDiscount,
      'minPrice': minPrice,
      'isSingleUse': isSingleUse,
      'isActive': isActive,
      'createdAt': createdAt,
      'usedCount': usedCount,
      'forUsers': forUsers,
      'usedBy': usedBy,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      couponCode: map['couponCode'] ?? '',
      couponName: map['couponName'] ?? '',
      couponDescription: map['couponDescription'] ?? '',
      couponImage: map['couponImage'] ?? '',
      couponExpiryDate: map['couponExpiryDate'],
      isByPercent: map['isByPercent'] ?? false,
      couponDiscount: map['couponDiscount']?.toDouble() ?? 0.0,
      minPrice: map['minPrice']?.toDouble() ?? 0.0,
      isSingleUse: map['isSingleUse'] ?? false,
      isActive: map['isActive'] ?? false,
      createdAt: map['createdAt'],
      usedCount: map['usedCount']?.toInt() ?? 0,
      forUsers: List<String>.from(map['forUsers']),
      usedBy: List<String>.from(map['usedBy']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CouponModel(couponCode: $couponCode, couponName: $couponName, couponDescription: $couponDescription, couponImage: $couponImage, couponExpiryDate: $couponExpiryDate, isByPercent: $isByPercent, couponDiscount: $couponDiscount, minPrice: $minPrice, isSingleUse: $isSingleUse, isActive: $isActive, createdAt: $createdAt, usedCount: $usedCount, forUsers: $forUsers, usedBy: $usedBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouponModel &&
        other.couponCode == couponCode &&
        other.couponName == couponName &&
        other.couponDescription == couponDescription &&
        other.couponImage == couponImage &&
        other.couponExpiryDate == couponExpiryDate &&
        other.isByPercent == isByPercent &&
        other.couponDiscount == couponDiscount &&
        other.minPrice == minPrice &&
        other.isSingleUse == isSingleUse &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.usedCount == usedCount &&
        listEquals(other.forUsers, forUsers) &&
        listEquals(other.usedBy, usedBy);
  }

  @override
  int get hashCode {
    return couponCode.hashCode ^
        couponName.hashCode ^
        couponDescription.hashCode ^
        couponImage.hashCode ^
        couponExpiryDate.hashCode ^
        isByPercent.hashCode ^
        couponDiscount.hashCode ^
        minPrice.hashCode ^
        isSingleUse.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        usedCount.hashCode ^
        forUsers.hashCode ^
        usedBy.hashCode;
  }
}
