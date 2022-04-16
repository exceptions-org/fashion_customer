import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupPage2 extends StatefulWidget {
  final String number;
  SignupPage2({required this.number});

  @override
  State<SignupPage2> createState() => _SignupPage2State();
}

class _SignupPage2State extends State<SignupPage2> {
  TextEditingController name = TextEditingController();
  TextEditingController houseNo = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController landmark = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          final formState = _formKey.currentState;
          if (formState!.validate()) {
            formState.save();
            addaddress();
          } else {
            return null;
          }
        },
        child: Container(
            margin: EdgeInsets.all(20),
            height: 60,
            decoration: BoxDecoration(
              color: KConstants.kPrimary100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                "Save & continue",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            )),
      ),
      backgroundColor: Color(0XFFFAFAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Contact Details',
          style: TextStyle(
            color: KConstants.kPrimary100,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "Enter Your name";
                        }
                        return null;
                      },
                      controller: name,
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
                // height: 500,
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
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "Enter House no. or building name";
                        }
                        return null;
                      },
                      controller: houseNo,
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
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "Enter Road name or area name";
                        }
                        return null;
                      },
                      controller: area,
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
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "Enter Pincode";
                        }
                        return null;
                      },
                      controller: pincode,
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
                          child: TextFormField(
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "Enter City name";
                              }
                              return null;
                            },
                            controller: city,
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
                          child: TextFormField(
                            validator: (input) {
                              if (input!.isEmpty) {
                                return "Enter State name";
                              }
                              return null;
                            },
                            controller: state,
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
                    TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "Enter Your nearby Location";
                        }
                        return null;
                      },
                      controller: landmark,
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
      ),
    );
  }

  void addaddress() async {
    UserModel userModel = UserModel(
        orderCount: 0,
        name: name.text,
        number: widget.number,
        address: [
          Address(
              type: '',
              actualAddress:
                  "${houseNo.text}, ${area.text}, ${landmark.text}, ${city.text}, ${pincode.text}, ${state.text}}",
              landMark: landmark.text,
              latlng: GeoPoint(0, 0),
              pinCode: pincode.text),
        ]);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.number)
        .set(userModel.toMap());

    await getIt<UserController>().getUser();

    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => BottomNavigation()),
        (r) => false);
  }
}
