import 'package:auto_size_text/auto_size_text.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';
import '../views/add_address.dart';

class SelectAddressSheet extends StatefulWidget {
  SelectAddressSheet({Key? key}) : super(key: key);

  @override
  State<SelectAddressSheet> createState() => _SelectAddressSheetState();
}

class _SelectAddressSheetState extends State<SelectAddressSheet> {
  final UserController controller = getIt<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  'Select Address',
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
          ListView(
            shrinkWrap: true,
            children: controller.userModel.address
                .map((e) => InkWell(
                      onTap: () async {
                        await controller.setAddress(e);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(20),
                        decoration: ShapeDecoration(
                            color: controller.seletedAddress == e
                                ? KConstants.kPrimary75.withOpacity(0.15)
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                e.actualAddress,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () async {
                await Geolocator.requestPermission();
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                showModalBottomSheet(
                    isScrollControlled: true,
                    isDismissible: false,
                    context: context,
                    builder: (c) {
                      return AddAdress(
                        isEdit: false,
                        latLng: LatLng(position.latitude, position.longitude),
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
    );
  }
}
