import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/views/about_us.dart';
import 'package:fashion_customer/views/add_address.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:fashion_customer/views/login_page.dart';
import 'package:fashion_customer/views/view_order.dart';
import 'package:fashion_customer/views/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController controller = getIt<UserController>();
  Size get preferredSize => const Size.fromHeight(100);

  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    controller.getUser();
    return Scaffold(
      backgroundColor: Color(0XFFFAFAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58),
        child: CustomAppBar(
          isaction: [Icon(Icons.abc)],
          isCenterTitle: true,
          title: "Profile",
        ),
      ),
      // AppBar(
      //   automaticallyImplyLeading: false,
      //   elevation: 1,
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     'Profile',
      //     style: TextStyle(color: KConstants.kPrimary100),
      //   ),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: KConstants.kPrimary100,
                child: Text(
                  (controller.userModel.name.split(' ').length > 1
                          ? controller.userModel.name.split(' ')[0][0] +
                              controller.userModel.name.split(' ')[1][0]
                          : controller.userModel.name[0])
                      .toUpperCase(),
                  style: GoogleFonts.montserratAlternates(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  Text(
                    controller.userModel.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Image.asset(
                                                    'Icons/Arrow.png',
                                                    color:
                                                        KConstants.kPrimary100,
                                                  ),
                                                ),
                                                Text(
                                                  'Update Name',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        KConstants.kPrimary100,
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
                                                  .doc(controller
                                                      .userModel.number)
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
                          )),
                    ),
                  )
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
                    ...controller.userModel.address.mapIndexed(
                      (i, e) => InkWell(
                        onTap: () async {
                          await controller.setAddress(e);
                          setState(() {});
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
                                onPressed: () async {
                                  await Geolocator.requestPermission();
                                  Position position =
                                      await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high);
                                  await showModalBottomSheet(
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      context: context,
                                      builder: (c) {
                                        return AddAdress(
                                          addressModel: e,
                                          latLng: LatLng(position.latitude,
                                              position.longitude),
                                          editIndex: i,
                                          isEdit: true,
                                          onTap: () {
                                            setState(() {});
                                          },
                                        );
                                      });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              if (controller.userModel.address.length > 1)
                                IconButton(
                                  onPressed: () async {
                                    List<AddressModel> list =
                                        controller.userModel.address;
                                    list.removeAt(i);
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(controller.userModel.number)
                                        .update({
                                      'address':
                                          list.map((e) => e.toMap()).toList()
                                    });
                                    await controller.getUser();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18,
                                  ),
                                )
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
                        onPressed: () async {
                          await Geolocator.requestPermission();
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high);
                          showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: false,
                              context: context,
                              builder: (c) {
                                return AddAdress(
                                  isEdit: false,
                                  latLng: LatLng(
                                      position.latitude, position.longitude),
                                  onTap: () {
                                    setState(() {});
                                  },
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
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ViewOrders(
                                  userPhone: controller.userModel.number,
                                )));
                  },
                  leading: Image.asset(
                    "Icons/Orders.png",
                    height: 25,
                    color: KConstants.kPrimary100,
                  ),
                  title: Text("Your Orders"),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "Icons/Arrow.png",
                      height: 25,
                      color: KConstants.kPrimary100,
                    ),
                  ),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => WishlistWidget()));
                  },
                  leading: Icon(
                    Icons.bookmark_border,
                    color: Colors.blueGrey,
                  ),
                  title: Text("Wishlist"),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "Icons/Arrow.png",
                      height: 25,
                      color: KConstants.kPrimary100,
                    ),
                  ),
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
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => AboutUs()));
                  },
                  leading: Icon(
                    CupertinoIcons.at,
                    color: Colors.teal,
                  ),
                  title: Text("About US"),
                  trailing: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      "Icons/Arrow.png",
                      height: 25,
                      color: KConstants.kPrimary100,
                    ),
                  ),
                ),
              ),
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
