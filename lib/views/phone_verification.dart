import 'dart:ui';

import 'package:fashion_customer/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PhoneVerification extends StatefulWidget {
  final AuthService authService;
  String number;
  PhoneVerification({Key? key, required this.authService, required this.number})
      : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController smsController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
                top: kToolbarHeight,
                left: kToolbarHeight / 2,
                right: kToolbarHeight / 2),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'img',
                    child: Image.asset(
                      "Icons/OTP.png",
                      height: size.height * 0.25,
                    ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Enter the OTP sent to",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff4E4872),
                            height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.number,
                        style: TextStyle(
                            fontSize: 14,
                            color: KConstants.kPrimary100,
                            fontWeight: FontWeight.bold,
                            height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 40,
                    width: 240,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      controller: smsController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't you receive the OTP?"),
                      SizedBox(
                        width: 8,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Resend OTP",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.authService
                                    .signinWithPhone(widget.number, context, true);
                              }),
                        style: TextStyle(
                            fontSize: 14,
                            color: KConstants.kPrimary100,
                            fontWeight: FontWeight.bold,
                            height: 1.4),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        await widget.authService.verifySmsCode(
                            widget.number, smsController.text, context);
                        setState(() {
                          loading = false;
                        });
                      },
                      child: Container(
                        height: 60.0,
                        width: 240.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                          color: Color(
                            0xff604FCD,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Verify",
                            style: TextStyle(
                              letterSpacing: 1.0,
                              fontSize: 16.0,
                              color: Colors.white,
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
        if (loading)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
      ],
    );
  }
}
