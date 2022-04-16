import 'package:after_layout/after_layout.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/cart_model.dart';
import 'package:fashion_customer/startup_page.dart';
import 'package:fashion_customer/utils/spHelper.dart';
import 'package:fashion_customer/views/login_page.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.purple,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fashio",
                  style: TextStyle(color: Colors.purple, fontSize: 20),
                ),
              ],
            )
          ]),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isfirst = sharedPreferences.getBool("first");
    await Future.delayed(Duration(seconds: 2));
    if (isfirst != true) {
      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (c) => StartupPage()), (route) => false);
    } else if (FirebaseAuth.instance.currentUser != null) {
      UserController controller = getIt<UserController>();
      List<CartModel>? carts = await SPHelper().getCart();
      if(carts!=null){
        cartItems = carts;
      }
      await controller.getUser();
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (c) => BottomNavigation()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (c) => LoginPage()), (route) => false);
    }
  }
}
