import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/cart_model.dart';
import 'package:fashion_customer/model/offer_model.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:flutter/foundation.dart';

enum OrderState { placed, confirmed, outForDelivery, delivered, cancel }

class OrderModel {
  final String orderDocId;
  final List<CartModel> products;

  final double totalPrice;
  final Timestamp deliveryDate;
  final double totalDiscountPrice;
  final String orderId;
  final OrderState orderState;
  final Timestamp createdAt;
  final AddressModel address;
  final String userPhone;
  final String userName;
  final String pushToken;
  final Timestamp deliveredDate;
  final bool cancelledByUser;
  final String cancellationReason;
  final CouponModel? couponModel;

  OrderModel({
    required this.orderDocId,
    required this.products,
    required this.totalPrice,
    required this.deliveryDate,
    required this.totalDiscountPrice,
    required this.orderId,
    required this.orderState,
    required this.createdAt,
    required this.address,
    required this.userPhone,
    required this.userName,
    required this.pushToken,
    required this.deliveredDate,
    required this.cancelledByUser,
    required this.cancellationReason,
    required this.couponModel,
  });

  OrderModel copyWith({
    String? orderDocId,
    List<CartModel>? products,
    double? totalPrice,
    Timestamp? deliveryDate,
    double? totalDiscountPrice,
    String? orderId,
    OrderState? orderState,
    Timestamp? createdAt,
    AddressModel? address,
    String? userPhone,
    String? userName,
    String? pushToken,
    Timestamp? deliveredDate,
    bool? cancelledByUser,
    String? cancellationReason,
    CouponModel? couponModel,
  }) {
    return OrderModel(
      orderDocId: orderDocId ?? this.orderDocId,
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      totalDiscountPrice: totalDiscountPrice ?? this.totalDiscountPrice,
      orderId: orderId ?? this.orderId,
      orderState: orderState ?? this.orderState,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
      userPhone: userPhone ?? this.userPhone,
      userName: userName ?? this.userName,
      pushToken: pushToken ?? this.pushToken,
      deliveredDate: deliveredDate ?? this.deliveredDate,
      cancelledByUser: cancelledByUser ?? this.cancelledByUser,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      couponModel: couponModel ?? this.couponModel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderDocId': orderDocId,
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'deliveryDate': deliveryDate,
      'totalDiscountPrice': totalDiscountPrice,
      'orderId': orderId,
      'orderState': orderState.index,
      'createdAt': createdAt,
      'address': address.toMap(),
      'userPhone': userPhone,
      'userName': userName,
      'pushToken': pushToken,
      'deliveredDate': deliveredDate,
      'cancelledByUser': cancelledByUser,
      'cancellationReason': cancellationReason,
      'couponModel': couponModel?.toMap(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderDocId: map['orderDocId'] ?? '',
      products: List<CartModel>.from(
          map['products']?.map((x) => CartModel.fromMap(x))),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      deliveryDate: map['deliveryDate'],
      totalDiscountPrice: map['totalDiscountPrice']?.toDouble() ?? 0.0,
      orderId: map['orderId'] ?? '',
      orderState: OrderState.values[map['orderState']],
      createdAt: map['createdAt'],
      address: AddressModel.fromMap(map['address']),
      userPhone: map['userPhone'] ?? '',
      userName: map['userName'] ?? '',
      pushToken: map['pushToken'] ?? '',
      deliveredDate: map['deliveredDate'],
      cancelledByUser: map['cancelledByUser'] ?? false,
      cancellationReason: map['cancellationReason'] ?? '',
      couponModel: map['couponModel'] == null
          ? null
          : CouponModel.fromMap(map['couponModel']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(orderDocId: $orderDocId, products: $products, totalPrice: $totalPrice, deliveryDate: $deliveryDate, totalDiscountPrice: $totalDiscountPrice, orderId: $orderId, orderState: $orderState, createdAt: $createdAt, address: $address, userPhone: $userPhone, userName: $userName, pushToken: $pushToken, deliveredDate: $deliveredDate, cancelledByUser: $cancelledByUser, cancellationReason: $cancellationReason)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.orderDocId == orderDocId &&
        listEquals(other.products, products) &&
        other.totalPrice == totalPrice &&
        other.deliveryDate == deliveryDate &&
        other.totalDiscountPrice == totalDiscountPrice &&
        other.orderId == orderId &&
        other.orderState == orderState &&
        other.createdAt == createdAt &&
        other.address == address &&
        other.userPhone == userPhone &&
        other.userName == userName &&
        other.pushToken == pushToken &&
        other.deliveredDate == deliveredDate &&
        other.cancelledByUser == cancelledByUser &&
        other.cancellationReason == cancellationReason;
  }

  @override
  int get hashCode {
    return orderDocId.hashCode ^
        products.hashCode ^
        totalPrice.hashCode ^
        deliveryDate.hashCode ^
        totalDiscountPrice.hashCode ^
        orderId.hashCode ^
        orderState.hashCode ^
        createdAt.hashCode ^
        address.hashCode ^
        userPhone.hashCode ^
        userName.hashCode ^
        pushToken.hashCode ^
        deliveredDate.hashCode ^
        cancelledByUser.hashCode ^
        cancellationReason.hashCode;
  }
}
