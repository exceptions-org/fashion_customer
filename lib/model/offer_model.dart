import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String couponCode;
  final String couponName;
  final String couponDescription;
  final String couponImage;
  final Timestamp couponExpiryDate;
  final bool isByPercent;
  final double couponDiscount;
  OfferModel({
    required this.couponCode,
    required this.couponName,
    required this.couponDescription,
    required this.couponImage,
    required this.couponExpiryDate,
    required this.isByPercent,
    required this.couponDiscount,
  });

  OfferModel copyWith({
    String? couponCode,
    String? couponName,
    String? couponDescription,
    String? couponImage,
    Timestamp? couponExpiryDate,
    bool? isByPercent,
    double? couponDiscount,
  }) {
    return OfferModel(
      couponCode: couponCode ?? this.couponCode,
      couponName: couponName ?? this.couponName,
      couponDescription: couponDescription ?? this.couponDescription,
      couponImage: couponImage ?? this.couponImage,
      couponExpiryDate: couponExpiryDate ?? this.couponExpiryDate,
      isByPercent: isByPercent ?? this.isByPercent,
      couponDiscount: couponDiscount ?? this.couponDiscount,
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
    };
  }

  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      couponCode: map['couponCode'] ?? '',
      couponName: map['couponName'] ?? '',
      couponDescription: map['couponDescription'] ?? '',
      couponImage: map['couponImage'] ?? '',
      couponExpiryDate: map['couponExpiryDate'],
      isByPercent: map['isByPercent'] ?? false,
      couponDiscount: map['couponDiscount']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferModel.fromJson(String source) =>
      OfferModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OfferModel(couponCode: $couponCode, couponName: $couponName, couponDescription: $couponDescription, couponImage: $couponImage, couponExpiryDate: $couponExpiryDate, isByPercent: $isByPercent, couponDiscount: $couponDiscount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfferModel &&
        other.couponCode == couponCode &&
        other.couponName == couponName &&
        other.couponDescription == couponDescription &&
        other.couponImage == couponImage &&
        other.couponExpiryDate == couponExpiryDate &&
        other.isByPercent == isByPercent &&
        other.couponDiscount == couponDiscount;
  }

  @override
  int get hashCode {
    return couponCode.hashCode ^
        couponName.hashCode ^
        couponDescription.hashCode ^
        couponImage.hashCode ^
        couponExpiryDate.hashCode ^
        isByPercent.hashCode ^
        couponDiscount.hashCode;
  }
}
