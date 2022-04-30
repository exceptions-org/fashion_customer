import 'package:after_layout/after_layout.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/cart_controller.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/startup_page.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/fcm_service.dart';
import 'package:fashion_customer/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "Icons/FashioLogo.png",
                height: 100,
              ),
              Hero(
                tag: 'title',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    "Fashio",
                    style: GoogleFonts.montserratAlternates(
                      color: KConstants.kPrimary100,
                      fontSize: 25,
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    UserController controller = getIt<UserController>();
    controller.setEmptyUser();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isfirst = sharedPreferences.getBool("first");
    await Future.delayed(Duration(seconds: 10));
    if (isfirst != true) {
      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (c) => StartupPage()), (route) => false);
    } else if (FirebaseAuth.instance.currentUser != null) {
      FirebaseMessagingService();
      getIt<CartController>().init();
      await controller.getUser();
      controller.saveAdminToken();
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
