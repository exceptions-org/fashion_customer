import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/views/contact_details.dart';
import 'package:fashion_customer/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';


GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getIt.registerFactory(()=>UserController());
  runApp(
    const MyApp(),
  );
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
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0XFF604FCD),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        );
  }
}
