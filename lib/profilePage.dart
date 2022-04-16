import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/user_model.dart';
import 'utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController controller = getIt<UserController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  TextEditingController houseNo = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController landmark = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    controller.getUser().then((value) {
      setState(() {});
    });
    return Scaffold(
      backgroundColor: Color(0XFFFAFAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(color: KConstants.kPrimary100),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                //backgroundColor: KConstants.kPrimary100,
                foregroundImage: AssetImage("Icons/account.png"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.userModel.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (c) {
                              return StatefulBuilder(builder: (context, s) {
                                var newMedia = MediaQuery.of(context);
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: newMedia.viewInsets.bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30.0, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Image.asset(
                                                'Icons/Arrow.png',
                                                color: KConstants.kPrimary100,
                                              ),
                                            ),
                                            Text(
                                              'Update Name',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: KConstants.kPrimary100,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Image.asset(
                                              'Icons/Arrow.png',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30.0, horizontal: 10),
                                        child: TextField(
                                          autofocus: true,
                                          controller: name,
                                          decoration: InputDecoration(
                                            labelText: "Name",
                                            labelStyle: TextStyle(
                                              color: Color(0xff4E4872),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(controller.userModel.number)
                                              .update({'name': name.text});
                                          await controller.getUser();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(20),
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: KConstants.kPrimary100,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        height: media.viewPadding.bottom,
                                      )
                                    ],
                                  ),
                                );
                              });
                            });
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 18,
                      ))
                ],
              ),
              SizedBox(height: 20),
              /* Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      //width: 1,
                      color: Color(0XFFC8DFEF),
                    )),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blueGrey),
                  title: Text("Personal Details"),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "Icons/Arrow.png",
                      height: 25,
                      color: KConstants.kPrimary100,
                    ),
                  ),
                ),
              ), */
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      //width: 1,
                      color: Color(0XFFC8DFEF),
                    )),
                child: ExpansionTile(
                  leading: Icon(Icons.location_city, color: Colors.green),
                  title: Text("User Address"),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...controller.userModel.address.map(
                      (e) => InkWell(
                        onTap: () async {
                          await controller.setAddress(e);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: controller.seletedAddress == e
                              ? KConstants.kPrimary75.withOpacity(0.15)
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  e.actualAddress,
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit,
                                    size: 18,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: false,
                              context: context,
                              builder: (c) {
                                return Scaffold(
                                  bottomNavigationBar: InkWell(
                                    onTap: () {
                                      final formState = _formKey.currentState;
                                      if (formState!.validate()) {
                                        formState.save();
                                        controller.addAddress(Address(
                                            type: '',
                                            actualAddress:
                                                "${houseNo.text}, ${area.text}, ${landmark.text}, ${city.text}, ${pincode.text}, ${state.text}}",
                                            landMark: landmark.text,
                                            latlng: GeoPoint(0, 0),
                                            pinCode: pincode.text));
                                        controller.getUser();
                                        landmark.clear();
                                        houseNo.clear();
                                        area.clear();
                                        pincode.clear();
                                        city.clear();
                                        state.clear();

                                        Navigator.pop(context);
                                      } else {
                                        return null;
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(20),
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: KConstants.kPrimary100,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        )),
                                  ),
                                  body: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: kToolbarHeight),
                                      child: SingleChildScrollView(
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(24),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0XFFC8DFEF),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Add Address",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff4E4872),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Address",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff4E4872),
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
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "House no. / Building Name",
                                                        labelStyle: TextStyle(
                                                          color:
                                                              Color(0xff4E4872),
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
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Road name / Area",
                                                        labelStyle: TextStyle(
                                                          color:
                                                              Color(0xff4E4872),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      validator: (input) {
                                                        if (input!.isEmpty) {
                                                          return "Enter Pincode";
                                                        }
                                                        return null;
                                                      },
                                                      controller: pincode,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Pincode",
                                                        labelStyle: TextStyle(
                                                          color:
                                                              Color(0xff4E4872),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          width: 100,
                                                          child: TextFormField(
                                                            validator: (input) {
                                                              if (input!
                                                                  .isEmpty) {
                                                                return "Enter City name";
                                                              }
                                                              return null;
                                                            },
                                                            controller: city,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: "City",
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Color(
                                                                    0xff4E4872),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 60,
                                                          width: 100,
                                                          child: TextFormField(
                                                            validator: (input) {
                                                              if (input!
                                                                  .isEmpty) {
                                                                return "Enter State name";
                                                              }
                                                              return null;
                                                            },
                                                            controller: state,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "State",
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Color(
                                                                    0xff4E4872),
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
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Nearby location",
                                                        labelStyle: TextStyle(
                                                          color:
                                                              Color(0xff4E4872),
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
                                    ),
                                  ),
                                );
                              });
                        },
                        label: Text("Add New Address"),
                        icon: Icon(Icons.add_location),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      //width: 1,
                      color: Color(0XFFC8DFEF),
                    )),
                child: ListTile(
                  leading: Icon(Icons.phone, color: Colors.blue),
                  title: Text("User Contact No"),
                  trailing: Text(controller.userModel.number),

                  /*  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "Icons/Arrow.png",
                      height: 25,
                      color: KConstants.kPrimary100,
                    ),
                  ), */
                ),
              ),
              /* Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      //width: 1,
                      color: Color(0XFFC8DFEF),
                    )),
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.orange),
                  title: Text("User Email ID"),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "Icons/Arrow.png",
                      height: 25,
                      color: KConstants.kPrimary100,
                    ),
                  ),
                ),
              ), */
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        //width: 1,
                        color: Color(0XFFC8DFEF),
                      )),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text("Logout"),
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
