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
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/phone_verification.dart';

class AuthService {
  String verificationId = "";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> signinWithPhone(
      String phoneNumber, BuildContext w, bool isOtpPage) async {
    if (!isOtpPage)
      Navigator.push(w, CupertinoPageRoute(builder: (w) => Loading()));
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (e) => verificationFailed(e, w),
        codeSent: (c, r) => codeSent(
              phoneNumber,
              c,
              w,
              isOtpPage,
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

  void codeSent(
      String number, String string, BuildContext context, bool isOtpPage,
      [int? code]) async {
    try {
      verificationId = string;
      if (!isOtpPage) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                PhoneVerification(authService: this, number: number),
          ),
        );
      }
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
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => BottomNavigation()),
            (e) => false);
      } else {
        await Geolocator.requestPermission();
        Position position = await Geolocator.getCurrentPosition();
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => SignupPage2(
                      number: phone,
                      latLng: LatLng(position.latitude, position.longitude),
                    )));
      }
    } catch (e) {}
    return false;
  }
}
