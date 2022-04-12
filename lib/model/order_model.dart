import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:fashion_customer/model/cart_model.dart';

enum OrderState{
    placed,
    confirmed,
    delivered,
    cancel
  }
class OrderModel {
  List<CartModel> products;
  String totalPrice;
  String selectedSize;
  Timestamp deliveryDate;
  double totalDiscountPrice;
  String orderId;
  OrderState orderState;
  Timestamp createdAt;
  OrderModel({
    required this.products,
    required this.totalPrice,
    required this.deliveryDate,
    required this.totalDiscountPrice,
    required this.orderId,
    required this.orderState,
    required this.createdAt,
    required this.selectedSize,
  });

  OrderModel copyWith({
    List<CartModel>? products,
    String? totalPrice,
    Timestamp? deliveryDate,
    double? totalDiscountPrice,
    String? orderId,
    OrderState? orderState,
    Timestamp? createdAt,
  }) {
    return OrderModel(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      totalDiscountPrice: totalDiscountPrice ?? this.totalDiscountPrice,
      orderId: orderId ?? this.orderId,
      orderState: orderState ?? this.orderState,
      createdAt: createdAt ?? this.createdAt,
      selectedSize: selectedSize,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'deliveryDate': deliveryDate,
      'totalDiscountPrice': totalDiscountPrice,
      'orderId': orderId,
      'orderState': orderState.index,
      'createdAt': createdAt,
      'selectedSize': selectedSize
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      products: List<CartModel>.from(map['products']?.map((x) => CartModel.fromMap(x))),
      totalPrice: map['totalPrice'] ?? '',
      deliveryDate: map['deliveryDate'],
      totalDiscountPrice: map['totalDiscountPrice']?.toDouble() ?? 0.0,
      orderId: map['orderId'] ?? '',
      orderState: OrderState.values[(map['orderState'])],
      createdAt: map['createdAt'],
      selectedSize: map['selectedSize']??''
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(products: $products, totalPrice: $totalPrice, deliveryDate: $deliveryDate, totalDiscountPrice: $totalDiscountPrice, orderId: $orderId, orderState: $orderState, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderModel &&
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
    return products.hashCode ^
      totalPrice.hashCode ^
      deliveryDate.hashCode ^
      totalDiscountPrice.hashCode ^
      orderId.hashCode ^
      orderState.hashCode ^
      createdAt.hashCode;
  }
}
