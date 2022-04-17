import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/views/cart_page.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'profilePage.dart';
import 'views/search_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<String> assets = [
    "Icons/Home.png",
    "Icons/Search.png",
    "Icons/Bag.png",
    "Icons/User.png"
  ];
  int index = 0;

  List<Widget> get routes => [
        HomePage(onChange: onChange),
        SearchPage(onChange: onChange),
        Cartpage(
          onChange: onChange,
        ),
        const ProfilePage(),
      ];
  late double leftPadding;
  late double rightPadding;

  double width = 5;

  late Size size;

  int k = 0;

  void onChange(int i) async {/* 
    pageController.animateToPage(i,
        duration: Duration(microseconds: 250), curve: Curves.easeIn); */
    switch (i) {
      case 0:
        setState(() {
          leftPadding = size.width * 0.12;
        });
        await Future.delayed(Duration(milliseconds: 180));
        setState(() {
          rightPadding = size.width * 0.87;
        });
        break;
      case 1:
        if (i > index) {
          setState(() {
            rightPadding = size.width * 0.62;
          });
          await Future.delayed(Duration(milliseconds: 180));
          setState(() {
            leftPadding = size.width * 0.37;
          });
        } else {
          setState(() {
            leftPadding = size.width * 0.37;
          });
          await Future.delayed(Duration(milliseconds: 180));
          setState(() {
            rightPadding = size.width * 0.62;
          });
        }
        break;
      case 2:
        if (i > index) {
          setState(() {
            rightPadding = size.width * 0.37;
          });
          await Future.delayed(Duration(milliseconds: 180));
          setState(() {
            leftPadding = size.width * 0.62;
          });
        } else {
          setState(() {
            leftPadding = size.width * 0.62;
          });
          await Future.delayed(Duration(milliseconds: 180));
          setState(() {
            rightPadding = size.width * 0.37;
          });
        }

        break;
      case 3:
        setState(() {
          rightPadding = size.width * 0.12;
        });

        await Future.delayed(Duration(milliseconds: 180));
        setState(() {
          leftPadding = size.width * 0.87;
        });
        break;

      default:
    }
    this.index = i;
  }

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (k == 0) {
      leftPadding = size.width * 0.11;
      rightPadding = size.width * 0.86;
      k++;
    }
    return WillPopScope(
      onWillPop: () async {
        if (index != 0) {
          onChange(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0XFFFAFAFF),
        body: routes[index],
        /* PageView(
          controller: pageController,
          onPageChanged: onChange,
          children: routes,
        ), */
        bottomNavigationBar: SizedBox(
          height: kBottomNavigationBarHeight * 1.3,
          width: size.width,
          child: Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < assets.length; i++)
                    InkWell(
                      onTap: () {
                        onChange(i);
                      },
                      child: SizedBox(
                        width: size.width * 0.25,
                        height: size.width * 0.11,
                        child: Image.asset(
                          assets[i],
                          height: 25,
                          color:
                              index == i ? KConstants.kPrimary100 : Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: size.width,
                child: AnimatedContainer(
                  //  curve: Curves.fastOutSlowIn,
                  margin:
                      EdgeInsets.only(left: leftPadding, right: rightPadding),
                  duration: Duration(milliseconds: 180),
                  height: 3,
                  width: width,
                  decoration: BoxDecoration(
                      color: KConstants.kPrimary100,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
