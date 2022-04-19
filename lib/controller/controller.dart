import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/utils/spHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  SPHelper spHelper = SPHelper();
  late UserModel userModel;
  Address? seletedAddress;

  void setEmptyUser() {
    UserModel userModel =
        UserModel(name: "", number: "", address: [], orderCount: 0);
  }

  Future<void> addAddress(Address address) async {
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
      userModel = UserModel.fromMap(snapshot.data()!);
      spHelper.setUser(userModel);
      seletedAddress = await spHelper.getAddress();
    }
  }

  Future<void> setAddress(Address address) async {
    seletedAddress = address;
    spHelper.setAddress(address);
  }
}
