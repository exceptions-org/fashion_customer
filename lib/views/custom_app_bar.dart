import 'package:fashion_customer/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool isCenterTitle;
  final Widget? isleading;
  final List<Widget>? isaction;

  CustomAppBar(
      {Key? key,
      required this.title,
      required this.isCenterTitle,
      this.isleading,
      required this.isaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: isleading,
      backgroundColor: Colors.white,
      elevation: 1,
      title: Text(
        title,
        style: GoogleFonts.montserratAlternates(
            color: KConstants.kPrimary100, fontSize: 25),
      ),
      centerTitle: isCenterTitle,
      actions: [
        isaction!.first,
        isaction!.last,
      ],
    );
  }
}
