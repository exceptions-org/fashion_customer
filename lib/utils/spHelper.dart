import 'package:fashion_customer/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class SPHelper {
  final String _address = 'address';
  final String _user = 'user';
  final String _carty = 'cart';
  final String _adminTokens = 'adminTokens';

  Future<void> setCart(List<CartModel> cart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_carty, cart.map((e) => e.toJson()).toList());
  }

  Future<List<CartModel>?> getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cart = prefs.getStringList(_carty);
    if (cart == null) return null;
    return cart.map((e) => CartModel.fromJson(e)).toList();
  }

  Future<void> setAddress(AddressModel address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_address, address.toJson());
  }

  Future<AddressModel?> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString(_address);
    if (address != null) {
      return AddressModel.fromJson(address);
    }
    return null;
  }

  Future<void> setUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_user, user.toJson());
  }

  Future<UserModel?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(_user);
    if (user != null) {
      return UserModel.fromJson(user);
    }
    return null;
  }

  Future<void> setAdminToken(List<String> tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_adminTokens, tokens);
  }

  Future<List<String>?> getAdminToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_adminTokens);
  }
}
