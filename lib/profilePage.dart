import 'package:fashion_customer/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFAFAFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0XFF604FCD)),
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
                //backgroundColor: Color(0XFF604FCD),
                foregroundImage: AssetImage("Icons/account.png"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Arif Khan",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {},
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
                      color: Color(0XFF604FCD),
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "106 1st Floor Ameen Apartment\nTandel Mohalla Idgah Road\nBhiwandi, Maharashtra 421302'"),
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
                    SizedBox(
                      height: 10,
                    )
                  ],
                  // trailing: RotatedBox(
                  //   quarterTurns: 2,
                  //   child: Image.asset(
                  //     "Icons/Arrow.png",
                  //     height: 25,
                  //     color: Color(0XFF604FCD),
                  //   ),
                  // ),
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
                child: ExpansionTile(
                  leading: Icon(Icons.phone, color: Colors.blue),
                  title: Text("User Contact No"),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("8446062685"),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              size: 18,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                  /*  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "Icons/Arrow.png",
                      height: 25,
                      color: Color(0XFF604FCD),
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
                      color: Color(0XFF604FCD),
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
