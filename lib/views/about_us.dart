import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'About Us',
          style:
              GoogleFonts.montserratAlternates(color: KConstants.kPrimary100),
        ),
        leading: IconButton(
          icon: Image.asset(
            "Icons/Arrow.png",
            color: KConstants.kPrimary100,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
    );
  }
}
