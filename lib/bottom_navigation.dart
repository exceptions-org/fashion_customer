import 'package:fashion_customer/views/product_page.dart';
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
  int index = 0;

  List routes = [
    const HomePage(),
    const SearchPage(),
    const ProductPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFAFAFF),
      body: routes[index],
      bottomNavigationBar: SizedBox(
        height: 60,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 0
                        ? Image.asset(
                            "Icons/Home.png",
                            height: 30,
                            color: const Color(0XFF604FCD),
                          )
                        : Image.asset(
                            "Icons/Home.png",
                            height: 25,
                            color: Colors.black,
                          ),
                    Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                          color: index == 0
                              ? const Color(0XFF604FCD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 1
                        ? Image.asset(
                            "Icons/Search.png",
                            height: 30,
                            color: const Color(0XFF604FCD),
                          )
                        : Image.asset(
                            "Icons/Search.png",
                            height: 25,
                            color: Colors.black,
                          ),
                    Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                          color: index == 1
                              ? const Color(0XFF604FCD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 2
                        ? Image.asset(
                            "Icons/Bag.png",
                            height: 30,
                            color: const Color(0XFF604FCD),
                          )
                        : Image.asset(
                            "Icons/Bag.png",
                            height: 25,
                            color: Colors.black,
                          ),
                    Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                          color: index == 2
                              ? const Color(0XFF604FCD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 3
                        ? Image.asset(
                            "Icons/User.png",
                            height: 30,
                            color: const Color(0XFF604FCD),
                          )
                        : Image.asset(
                            "Icons/User.png",
                            height: 25,
                            color: Colors.black,
                          ),
                    Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                          color: index == 3
                              ? const Color(0XFF604FCD)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
