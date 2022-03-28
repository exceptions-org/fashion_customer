import 'dart:convert';

class CartModel {
  String name;
  String price;
  String quantity;
  String productId;
  int color;
  CartModel({
    required this.name,
    required this.price,
    required this.quantity,
    required this.productId,
    required this.color,
  });
  

  CartModel copyWith({
    String? name,
    String? price,
    String? quantity,
    String? productId,
    int? color,
  }) {
    return CartModel(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'productId': productId,
      'color': color,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      quantity: map['quantity'] ?? '',
      productId: map['productId'] ?? '',
      color: map['color']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(name: $name, price: $price, quantity: $quantity, productId: $productId, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CartModel &&
      other.name == name &&
      other.price == price &&
      other.quantity == quantity &&
      other.productId == productId &&
      other.color == color;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      productId.hashCode ^
      color.hashCode;
  }
}
