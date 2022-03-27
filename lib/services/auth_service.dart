import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../views/phone_verification.dart';

class AuthService {
  String verificationId = "";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> signinWithPhone(String phoneNumber, BuildContext w) async {
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (c, r) => codeSent(c, w, r),
        codeAutoRetrievalTimeout: codeRetrievalTimeout);
  }

  void verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    try {
      print(phoneAuthCredential);
    } catch (e) {}
  }

  void verificationFailed(FirebaseAuthException firebaseAuthException) async {
    try {
      print(firebaseAuthException);
    } catch (e) {}
  }

  void codeSent(String string, BuildContext context, [int? code]) async {
    try {
      verificationId = string;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneVerification(authService: this),
        ),
      );
    } catch (e) {}
  }

  void codeRetrievalTimeout(String coderetrive) async {
    try {
      print(coderetrive);
    } catch (e) {}
  }

  Future<bool> verifySmsCode(String code) async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);
      if (userCredential.user != null) {
        return true;
      }
    } catch (e) {}
    return false;
  }
}
