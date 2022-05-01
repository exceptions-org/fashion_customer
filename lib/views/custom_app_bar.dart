import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  bool isCenterTitle;
  late Icon icon;

  CustomAppBar({Key? key, required this.title, required this.isCenterTitle,Icon? icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Text(
        title,
        style: GoogleFonts.montserratAlternates(
            color: KConstants.kPrimary100, fontSize: 25),
      ),
      centerTitle: isCenterTitle,
    );
  }
}
