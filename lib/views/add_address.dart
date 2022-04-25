import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'contact_details.dart';

class AddAdress extends StatefulWidget {
  final Function() onTap;
  final bool isEdit;
  final int? editIndex;
  final LatLng? latLng;
  final AddressModel? addressModel;
  AddAdress(
      {Key? key,
      required this.onTap,
      required this.isEdit,
      this.addressModel,
      this.editIndex,
      this.latLng})
      : super(key: key);

  @override
  State<AddAdress> createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdress> {
  UserController ucontroller = getIt<UserController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController houseNo = TextEditingController(
      text: widget.isEdit
          ? widget.addressModel!.actualAddress.split(', ')[0]
          : "");
  late TextEditingController area = TextEditingController(
      text: widget.isEdit
          ? widget.addressModel!.actualAddress.split(', ')[1]
          : "");
  late TextEditingController pincode = TextEditingController(
      text: widget.isEdit ? widget.addressModel!.pinCode : "");
  late TextEditingController city = TextEditingController(
      text: widget.isEdit
          ? widget.addressModel!.actualAddress.split(
              ', ')[widget.addressModel!.actualAddress.split(', ').length - 3]
          : "");
  late TextEditingController state = TextEditingController(
      text: widget.isEdit
          ? widget.addressModel!.actualAddress.split(
              ', ')[widget.addressModel!.actualAddress.split(', ').length - 1]
          : "");
  late TextEditingController landmark = TextEditingController(
      text: widget.isEdit ? widget.addressModel!.landMark : "");

  late LatLng? selectedLatLng = (widget.isEdit
      ? LatLng(widget.addressModel!.latlng.latitude,
          widget.addressModel!.latlng.longitude)
      : widget.latLng);
  GoogleMapController? controller;
  Completer<GoogleMapController> completer = Completer<GoogleMapController>();

  @override
  void initState() {
    if (widget.isEdit) {
      selectedLatLng = LatLng(widget.addressModel!.latlng.latitude,
          widget.addressModel!.latlng.longitude);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          final formState = _formKey.currentState;
          if (formState!.validate()) {
            formState.save();
            if (widget.isEdit) {
              List<AddressModel> addresses = ucontroller.userModel.address;
              addresses[widget.editIndex!] = AddressModel(
                  type: '',
                  actualAddress:
                      "${houseNo.text}, ${area.text}, ${landmark.text}, ${city.text}, ${pincode.text}, ${state.text}}",
                  landMark: landmark.text,
                  latlng: selectedLatLng != null
                      ? GeoPoint(
                          selectedLatLng!.latitude, selectedLatLng!.longitude)
                      : GeoPoint(0, 0),
                  pinCode: pincode.text);
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(ucontroller.userModel.number)
                  .update({'address': addresses});
            } else {
              ucontroller.addAddress(AddressModel(
                  type: '',
                  actualAddress:
                      "${houseNo.text}, ${area.text}, ${landmark.text}, ${city.text}, ${pincode.text}, ${state.text}}",
                  landMark: landmark.text,
                  latlng: selectedLatLng != null
                      ? GeoPoint(
                          selectedLatLng!.latitude, selectedLatLng!.longitude)
                      : GeoPoint(0, 0),
                  pinCode: pincode.text));
            }
            ucontroller.getUser();
            landmark.clear();
            houseNo.clear();
            area.clear();
            pincode.clear();
            city.clear();
            state.clear();

            Navigator.pop(context);
            widget.onTap();
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
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Address",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4E4872),
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
                                    if (widget.isEdit) {
                                      controller?.animateCamera(
                                          CameraUpdate.newLatLng(LatLng(
                                              widget.addressModel!.latlng
                                                  .latitude,
                                              widget.addressModel!.latlng
                                                  .longitude)));
                                    }
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: selectedLatLng ??
                                        (widget.isEdit
                                            ? LatLng(
                                                widget.addressModel!.latlng
                                                    .latitude,
                                                widget.addressModel!.latlng
                                                    .longitude)
                                            : LatLng(19.283872311756532,
                                                73.0539163835629)),
                                    zoom: 17,
                                  ),
                                  markers: Set<Marker>.of([
                                    if (selectedLatLng != null)
                                      Marker(
                                          markerId: MarkerId('0'),
                                          position: selectedLatLng!)
                                    else if (widget.isEdit)
                                      Marker(
                                          markerId: MarkerId('0'),
                                          position: LatLng(
                                              widget.addressModel!.latlng
                                                  .latitude,
                                              widget.addressModel!.latlng
                                                  .longitude)),
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
                              houseNo.text =
                                  (add.streetNumber ?? '').toString();
                              city.text = add.city ?? '';
                              area.text = add.streetAddress ?? '';
                              pincode.text = add.postal ?? '';
                              state.text = (add.region?.split(',').length == 2
                                      ? add.region?.split(',')[1]
                                      : '') ??
                                  '';

                              action();
                              controller?.animateCamera(
                                  CameraUpdate.newLatLng(latLng));
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
        ),
      ),
    );
  }
}
