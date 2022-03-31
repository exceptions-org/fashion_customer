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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color(0XFF604FCD),
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  //backgroundColor: Color(0XFF604FCD),
                  foregroundImage: AssetImage("Icons/account.png"),
                ),
                SizedBox(height: 30),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blueGrey),
                  title: Text("User Name"),
                ),
                ListTile(
                  leading: Icon(Icons.location_city, color: Colors.green),
                  title: Text("User Address"),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.blue),
                  title: Text("User Contact No"),
                ),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.orange),
                  title: Text("User Email ID"),
                ),
                ListTile(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => LoginPage()));
                  },
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
