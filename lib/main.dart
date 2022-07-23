import 'package:fashion_customer/controller/cart_controller.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/constants.dart';

GetIt getIt = GetIt.instance;

void main() async {
  getIt.registerLazySingleton(() => UserController());
  Get.put(CartController());
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  /*  QuerySnapshot snap = await FirebaseFirestore.instance.collection("products").get();
  for (var item in snap.docs) {
    log(item.id+item.data().toString());
  } */
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            toolbarTextStyle:
                GoogleFonts.montserratAlternates(color: KConstants.kPrimary100),
            elevation: 1,
            centerTitle: true),
        scaffoldBackgroundColor: KConstants.kBgColor,
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: KConstants.kPrimary100))),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: KConstants.kPrimary100),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
