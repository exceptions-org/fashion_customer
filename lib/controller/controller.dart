import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/utils/spHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserController {
  SPHelper spHelper = SPHelper();
  late UserModel userModel;
  AddressModel? seletedAddress;

  void setEmptyUser() {
    UserModel userModel =
        UserModel(name: "", number: "", address: [], orderCount: 0);
  }

  Future<void> addAddress(AddressModel address) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.number)
        .update({
      'address': FieldValue.arrayUnion([address.toMap()])
    });
  }

  Future<void> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String phone = user.phoneNumber!.substring(3);
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(phone).get();
      bool exist = snapshot.exists;
      if (exist) {
        userModel = UserModel.fromMap(snapshot.data()!);
        spHelper.setUser(userModel);
        seletedAddress = await spHelper.getAddress();
      } else {
        FirebaseAuth.instance.signOut();
        runApp(MyApp(
          key: UniqueKey(),
        ));
      }
    }
  }

  Future<void> setAddress(AddressModel address) async {
    seletedAddress = address;
    spHelper.setAddress(address);
  }
}
