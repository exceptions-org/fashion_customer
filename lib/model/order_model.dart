import 'dart:convert';

class OrderModel {
  String orderId;
  String orderName;
  double orderPrice;
  String orderQuantity;
  OrderModel({
    required this.orderId,
    required this.orderName,
    required this.orderPrice,
    required this.orderQuantity,
  });

  OrderModel copyWith({
    String? orderId,
    String? orderName,
    double? orderPrice,
    String? orderQuantity,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      orderName: orderName ?? this.orderName,
      orderPrice: orderPrice ?? this.orderPrice,
      orderQuantity: orderQuantity ?? this.orderQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderName': orderName,
      'orderPrice': orderPrice,
      'orderQuantity': orderQuantity,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      orderName: map['orderName'] ?? '',
      orderPrice: map['orderPrice']?.toDouble() ?? 0.0,
      orderQuantity: map['orderQuantity'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, orderName: $orderName, orderPrice: $orderPrice, orderQuantity: $orderQuantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is OrderModel &&
      other.orderId == orderId &&
      other.orderName == orderName &&
      other.orderPrice == orderPrice &&
      other.orderQuantity == orderQuantity;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
      orderName.hashCode ^
      orderPrice.hashCode ^
      orderQuantity.hashCode;
  }
}
