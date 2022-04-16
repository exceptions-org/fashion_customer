import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/cart_model.dart';
import 'package:flutter/foundation.dart';

enum OrderState { placed, confirmed, delivered, cancel }

class OrderModel {
  String orderDocId;
  List<CartModel> products;
  double totalPrice;
  Timestamp deliveryDate;
  double totalDiscountPrice;
  String orderId;
  OrderState orderState;
  Timestamp createdAt;
  OrderModel({
    required this.orderDocId,
    required this.products,
    required this.totalPrice,
    required this.deliveryDate,
    required this.totalDiscountPrice,
    required this.orderId,
    required this.orderState,
    required this.createdAt,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(orderDocId: $orderDocId, products: $products, totalPrice: $totalPrice, deliveryDate: $deliveryDate, totalDiscountPrice: $totalDiscountPrice, orderId: $orderId, orderState: $orderState, createdAt: $createdAt)';
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
        other.createdAt == createdAt;
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
        createdAt.hashCode;
  }
}
