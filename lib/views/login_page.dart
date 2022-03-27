import 'package:fashion_customer/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "Icons/OTP.png",
                  height: 220.0,
                ),
                SizedBox(
                  height: 54.0,
                ),
                Text(
                  "OTP Verification",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4E4872)),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "We will send you a one-time password\nto this mobile number",
                  style: TextStyle(
                      fontSize: 14, color: Color(0xff4E4872), height: 1.4),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Enter Mobile Number",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xff8985A1),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24.0,
                ),
                Container(
                  height: 40,
                  width: 240,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Color(
                          0xff4E4872,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.0,
                ),
                GestureDetector(
                  onTap: () {
                    authService.signinWithPhone(phoneController.text, context);
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        height: 60.0,
                        width: 240.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Color(0xff604FCD),
                        ),
                        child: Center(
                          child: Text(
                            "Get OTP",
                            style: TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
