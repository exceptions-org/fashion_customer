import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SignupPage2 extends StatefulWidget {
  final String number;
  final LatLng? latLng;
  SignupPage2({required this.number, this.latLng});

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

  late LatLng? selectedLatLng = widget.latLng;
  GoogleMapController? controller;
  Completer<GoogleMapController> completer = Completer<GoogleMapController>();

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
              Container(
                decoration: KConstants.defContainerDec,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('...Or Select from Map'),
                    SizedBox(
                      height: 20,
                    ),
                    OpenContainer(
                      closedBuilder: (context, action) => GestureDetector(
                        onTap: () {
                          action();
                        },
                        child: AbsorbPointer(
                          child: Container(
                            height: 300,
                            child: GoogleMap(
                              onMapCreated: (c) {
                                controller = c;
                                completer.complete(c);
                              },
                              initialCameraPosition: CameraPosition(
                                target: selectedLatLng ??
                                    LatLng(
                                        19.283872311756532, 73.0539163835629),
                                zoom: 14,
                              ),
                              markers: Set<Marker>.of([
                                if (selectedLatLng != null)
                                  Marker(
                                      markerId: MarkerId('0'),
                                      position: selectedLatLng!)
                              ]),
                            ),
                          ),
                        ),
                      ),
                      openBuilder: (context, action) => MapScreen(
                        latLng: selectedLatLng,
                        action: action,
                        onSelected: (latLng, add) {
                          selectedLatLng = latLng;
                          houseNo.text = (add.streetNumber ?? '').toString();
                          city.text = add.city ?? '';
                          area.text = add.streetAddress ?? '';
                          pincode.text = add.postal ?? '';
                          state.text = (add.region?.split(',').length == 2
                                  ? add.region?.split(',')[1]
                                  : '') ??
                              '';

                          action();
                          controller
                              ?.animateCamera(CameraUpdate.newLatLng(latLng));
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addaddress() async {
    UserModel userModel = UserModel(
        orderCount: 0,
        wishList: [],
        name: name.text,
        number: widget.number,
        pushToken: '',
        address: [
          AddressModel(
              type: '',
              actualAddress:
                  "${houseNo.text}, ${area.text}, ${landmark.text}, ${city.text}, ${pincode.text}, ${state.text}}",
              landMark: landmark.text,
              latlng: selectedLatLng != null
                  ? GeoPoint(
                      selectedLatLng!.latitude, selectedLatLng!.longitude)
                  : GeoPoint(0, 0),
              pinCode: pincode.text),
        ], whistList: []);
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

class MapScreen extends StatefulWidget {
  final Function(LatLng, Address) onSelected;
  final LatLng? latLng;
  final Function() action;
  const MapScreen(
      {key,
      required this.onSelected,
      required this.latLng,
      required this.action})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? controller;
  Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  Widget pin() {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.place,
              size: 56,
              color: Colors.black,
            ),
            Container(
              decoration: ShapeDecoration(
                shadows: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black38,
                  ),
                ],
                shape: CircleBorder(
                  side: BorderSide(
                    width: 4,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget myLocation() {
    return Container(
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(primary: KConstants.kPrimary100),
          label: Text('Current Location'),
          onPressed: () async {
            Position position = await Geolocator.getCurrentPosition();
            controller?.animateCamera(CameraUpdate.newLatLng(
                LatLng(position.latitude, position.longitude)));
          },
          icon: Icon(Icons.my_location)),
    );
  }

  Address? address;

  String getAddressString(dynamic component, [bool isLast = false]) {
    if (component == null) {
      return '';
    } else {
      return component.toString() + (isLast ? '' : ', ');
    }
  }

  late LatLng latLng =
      widget.latLng ?? LatLng(19.283872311756532, 73.0539163835629);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: latLng,
              zoom: 14,
            ),
            onMapCreated: (c) {
              controller = c;
              completer.complete(c);
            },
            onCameraMove: (l) {
              latLng = l.target;
            },
            onCameraIdle: () async {
              address = await GeoCode().reverseGeocoding(
                  latitude: latLng.latitude, longitude: latLng.longitude);
              setState(() {});
            },
          ),
          pin(),
          if (address != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  myLocation(),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      getAddressString(address!.streetNumber) +
                          getAddressString(address!.streetAddress) +
                          getAddressString(address!.city) +
                          getAddressString(address!.region) +
                          getAddressString(address!.postal),
                      style: TextStyle(color: KConstants.kPrimary100),
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight + 18.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          widget.action();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: KConstants.kPrimary100),
                        onPressed: () {
                          if (address != null) {
                            widget.onSelected(latLng, address!);
                          } else {
                            widget.action();
                          }
                        },
                        child: Text('Save'))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
