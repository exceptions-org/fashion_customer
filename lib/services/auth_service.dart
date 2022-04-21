import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/utils/fcm_service.dart';
import 'package:fashion_customer/views/contact_details.dart';
import 'package:fashion_customer/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/phone_verification.dart';

class AuthService {
  String verificationId = "";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> signinWithPhone(String phoneNumber, BuildContext w) async {
    Navigator.push(w, CupertinoPageRoute(builder: (w) => Loading()));
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (e) => verificationFailed(e, w),
        codeSent: (c, r) => codeSent(
              phoneNumber,
              c,
              w,
              r,
            ),
        codeAutoRetrievalTimeout: codeRetrievalTimeout);
  }

  void verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    try {
      print(phoneAuthCredential);
    } catch (e) {}
  }

  void verificationFailed(
      FirebaseAuthException firebaseAuthException, BuildContext c) async {
    Navigator.pop(c);
    try {
      print(firebaseAuthException);
    } catch (e) {}
  }

  void codeSent(String number, String string, BuildContext context,
      [int? code]) async {
    try {
      verificationId = string;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              PhoneVerification(authService: this, number: number),
        ),
      );
    } catch (e) {}
  }

  void codeRetrievalTimeout(String coderetrive) async {
    try {
      print(coderetrive);
    } catch (e) {}
  }

  Future<bool> verifySmsCode(
      String phone, String code, BuildContext context) async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(phone).get();
      FirebaseMessagingService();
      if (snapshot.exists) {
        UserController userController = getIt<UserController>();
        UserModel userModel = UserModel.fromMap(snapshot.data()!);
        (await SharedPreferences.getInstance())
            .setString('user', userModel.toJson());
        await userController.getUser();
        userController.saveAdminToken();
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => BottomNavigation()),
            (e) => false);
      } else {
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => SignupPage2(
                      number: phone,
                    )));
      } /* 
          (await SharedPreferences.getInstance()).setString('user', UserModel(name: "name", number: "number", adress: []).toJson());
      String? user = (await SharedPreferences.getInstance()).getString('user');
      if(user!=null){
        UserModel userModel = UserModel.fromJson(user);
       
      }
      
      if (userCredential.user != null) {
        return true;
      } */
    } catch (e) {}
    return false;
  }
}
