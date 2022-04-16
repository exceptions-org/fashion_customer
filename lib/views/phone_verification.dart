import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/services/auth_service.dart';
import 'package:fashion_customer/views/contact_details.dart';
import 'package:flutter/material.dart';

class PhoneVerification extends StatefulWidget {
  final AuthService authService;
  String number;
  PhoneVerification({Key? key, required this.authService,required this.number}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          24.0,
        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter the OTP sent to",
                    style: TextStyle(
                        fontSize: 14, color: Color(0xff4E4872), height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    smsController.text,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff604FCD),
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
                  maxLength: 6,
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
                  Text(
                    "Resend OTP",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff604FCD),
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
                    bool a = await widget.authService.verifySmsCode(
                      widget.number,
                      smsController.text,
                      context
                    );
                    if (a == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage2(number: widget.number),
                        ),
                      );
                    }
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
    );
  }
}
