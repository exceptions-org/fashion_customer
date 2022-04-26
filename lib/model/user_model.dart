import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String name;
  String number;
  List<AddressModel> address;
  List<String> whistList;
  int orderCount;
  String pushToken;
  UserModel({
    required this.name,
    required this.number,
    required this.address,
    required this.whistList,
    required this.orderCount,
    required this.pushToken
  });

  UserModel copyWith({
    String? name,
    String? number,
    List<AddressModel>? address,
    int? orderCount,
  }) {
    return UserModel(
      pushToken: pushToken,
      orderCount: orderCount ?? this.orderCount,
      name: name ?? this.name,
      number: number ?? this.number,
      address: address ?? this.address,
      whistList: whistList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,

      'orderCount': orderCount,
      'address': address.map((x) => x.toMap()).toList(),
      'pushToken': pushToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      whistList: map['whistList'],
      address: List<AddressModel>.from(
          map['address']?.map((x) => AddressModel.fromMap(x))),
      orderCount: map['orderCount'] ?? 0,
      pushToken: map['pushToken'] ?? '',
    );
  }

  Map<String, dynamic> toSF() {
    return {
      'name': name,
      'number': number,
      'address': address.map((x) => x.toSf()).toList(),
      'orderCount': orderCount,
      'pushToken': pushToken,
    };
  }

  factory UserModel.fromSF(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      whistList: map['whistList'],
      address: List<AddressModel>.from(
          map['address']?.map((x) => AddressModel.fromSf(x))),
      orderCount: map['orderCount'] ?? 0,
      pushToken: map['pushToken'] ?? '',
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

class AddressModel {
  String type;
  String actualAddress;
  GeoPoint latlng;
  String landMark;
  String pinCode;
  AddressModel({
    required this.type,
    required this.actualAddress,
    required this.latlng,
    required this.landMark,
    required this.pinCode,
  });

  AddressModel copyWith({
    String? type,
    String? actualAddress,
    GeoPoint? latlng,
    String? landMark,
    String? pinCode,
  }) {
    return AddressModel(
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

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      type: map['type'] ?? '',
      actualAddress: map['actualAddress'] ?? '',
      latlng: map['latlng'],
      landMark: map['landMark'] ?? '',
      pinCode: map['pinCode'] ?? '',
    );
  }

  factory AddressModel.fromSf(Map<String, dynamic> map) {
    return AddressModel(
      type: map['type'] ?? '',
      actualAddress: map['actualAddress'] ?? '',
      latlng: GeoPoint(map['latlng']['lat'], map['latlng']['lng']),
      landMark: map['landMark'] ?? '',
      pinCode: map['pinCode'] ?? '',
    );
  }

  String toJson() => json.encode(toSf());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromSf(json.decode(source));

  @override
  String toString() {
    return 'Address(type: $type, actualAddress: $actualAddress, latlng: $latlng, landMark: $landMark, pinCode: $pinCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
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
