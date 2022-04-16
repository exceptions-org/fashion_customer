import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String name;
  String number;
  List<Address> address;
  int orderCount;
  UserModel({
    required this.name,
    required this.number,
    required this.address,
    required this.orderCount,
  });

  UserModel copyWith({
    String? name,
    String? number,
    List<Address>? address,
    int? orderCount,
  }) {
    return UserModel
    (
    orderCount: orderCount ?? this.orderCount,
      name: name ?? this.name,
      number: number ?? this.number,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'orderCount': orderCount,
      'address': address.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      address: List<Address>.from(map['address']?.map((x) => Address.fromMap(x))),
      orderCount: map['orderCount'] ?? 0,
    );
  }

  Map<String, dynamic> toSF() {
    return {
      'name': name,
      'number': number,
      'address': address.map((x) => x.toSf()).toList(),
        'orderCount': orderCount,
    };
  }

  factory UserModel.fromSF(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      address: List<Address>.from(map['address']?.map((x) => Address.fromSf(x))),
      orderCount: map['orderCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toSF());

  factory UserModel.fromJson(String source) =>
      UserModel.fromSF(json.decode(source));

  @override
  String toString() =>
      'UserModel(name: $name, number: $number, address: $address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.number == number &&
        listEquals(other.address, address);
  }

  @override
  int get hashCode => name.hashCode ^ number.hashCode ^ address.hashCode;
}

class Address {
  String type;
  String actualAddress;
  GeoPoint latlng;
  String landMark;
  String pinCode;
  Address({
    required this.type,
    required this.actualAddress,
    required this.latlng,
    required this.landMark,
    required this.pinCode,
  });

  Address copyWith({
    String? type,
    String? actualAddress,
    GeoPoint? latlng,
    String? landMark,
    String? pinCode,
  }) {
    return Address(
      type: type ?? this.type,
      actualAddress: actualAddress ?? this.actualAddress,
      latlng: latlng ?? this.latlng,
      landMark: landMark ?? this.landMark,
      pinCode: pinCode ?? this.pinCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'actualAddress': actualAddress,
      'latlng': latlng,
      'landMark': landMark,
      'pinCode': pinCode,
    };
  }

  Map<String, dynamic> toSf() {
    return {
      'type': type,
      'actualAddress': actualAddress,
      'latlng': {'lat': latlng.latitude, 'lng': latlng.longitude},
      'landMark': landMark,
      'pinCode': pinCode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      type: map['type'] ?? '',
      actualAddress: map['actualAddress'] ?? '',
      latlng: map['latlng'],
      landMark: map['landMark'] ?? '',
      pinCode: map['pinCode'] ?? '',
    );
  }

  factory Address.fromSf(Map<String, dynamic> map) {
    return Address(
      type: map['type'] ?? '',
      actualAddress: map['actualAddress'] ?? '',
      latlng: GeoPoint(map['latlng']['lat'], map['latlng']['lng']),
      landMark: map['landMark'] ?? '',
      pinCode: map['pinCode'] ?? '',
    );
  }

  String toJson() => json.encode(toSf());

  factory Address.fromJson(String source) =>
      Address.fromSf(json.decode(source));

  @override
  String toString() {
    return 'Address(type: $type, actualAddress: $actualAddress, latlng: $latlng, landMark: $landMark, pinCode: $pinCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.type == type &&
        other.actualAddress == actualAddress &&
        other.latlng == latlng &&
        other.landMark == landMark &&
        other.pinCode == pinCode;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        actualAddress.hashCode ^
        latlng.hashCode ^
        landMark.hashCode ^
        pinCode.hashCode;
  }
}
