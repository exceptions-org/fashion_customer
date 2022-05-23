import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58),
        child: CustomAppBar(
          isaction: [Icon(Icons.abc)],
          isleading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              "Icons/Arrow.png",
              color: KConstants.kPrimary100,
            ),
          ),
          isCenterTitle: true,
          title: "About Us",
        ),
      ),
      /* AppBar(
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
      ), */
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: KConstants.defContainerDec,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: FittedBox(
                    child: Text('Fasheo',
                        style: GoogleFonts.montserratAlternates(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            fontWeight: FontWeight.normal,
                            color: KConstants.kPrimary100)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: FittedBox(
                    child: Text('by Anas Ansari',
                        style: GoogleFonts.montserratAlternates(
                            fontSize: MediaQuery.of(context).size.width * 0.07,
                            fontWeight: FontWeight.normal,
                            color: KConstants.kPrimary100)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            decoration: KConstants.defContainerDec,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Us At:',
                  style: GoogleFonts.montserratAlternates(
                      color: KConstants.kPrimary100, fontSize: 25),
                ),
                SizedBox(height: 10),
                Text(
                  'Rabia Masjid,\nMangal Bazaar Slap,\nBhiwandi,\nMaharashtra',
                  style: GoogleFonts.montserratAlternates(
                      color: KConstants.kPrimary100, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            decoration: KConstants.defContainerDec,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us At:',
                  style: GoogleFonts.montserratAlternates(
                      color: KConstants.kPrimary100, fontSize: 25),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    launchUrlString('tel:+91${8286349316}');
                  },
                  child: Text(
                    '8286349316',
                    style: GoogleFonts.montserratAlternates(
                        color: KConstants.kPrimary100, fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    launchUrlString('mailto:fashio687@gmail.com');
                  },
                  child: Text(
                    'fashio687@gmail.com',
                    style: GoogleFonts.montserratAlternates(
                        color: KConstants.kPrimary100, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
