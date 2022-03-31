import 'package:flutter/material.dart';

class SignupPage2 extends StatefulWidget {
  const SignupPage2({Key? key}) : super(key: key);

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          margin: EdgeInsets.all(20),
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xff604FCD),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              "Save & continue",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          )),
      backgroundColor: Color(0XFFFAFAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Contact Details',
          style: TextStyle(
            color: Color(0XFF604FCD),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0XFFC8DFEF),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Contact Details",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4E4872),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Enter your name",
                      labelStyle: TextStyle(
                        color: Color(0xff4E4872),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              padding: EdgeInsets.all(24),
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0XFFC8DFEF),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4E4872),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "House no. / Building Name",
                      labelStyle: TextStyle(
                        color: Color(0xff4E4872),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Road name / Area",
                      labelStyle: TextStyle(
                        color: Color(0xff4E4872),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Pincode",
                      labelStyle: TextStyle(
                        color: Color(0xff4E4872),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "City",
                            labelStyle: TextStyle(
                              color: Color(0xff4E4872),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "State",
                            labelStyle: TextStyle(
                              color: Color(0xff4E4872),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Nearby location",
                      labelStyle: TextStyle(
                        color: Color(0xff4E4872),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
