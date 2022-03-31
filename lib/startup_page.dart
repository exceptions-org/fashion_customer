import 'package:fashion_customer/views/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({Key? key}) : super(key: key);

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  String buttonText = "Next";
  var pageIndex = 0;
  PageController pageController = PageController();
  void pageChange(index) {
    if (index == 2) {
      setState(() {
        buttonText = "Get Started";
      });
    } else {
      setState(() {
        buttonText = "Next";
      });
    }
    setState(() {
      pageIndex = index;
    });
  }

  void onNext(index) {
    pageController.animateToPage(index,
        curve: Curves.ease, duration: const Duration(microseconds: 200));
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Fashion App"),
      ), */
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, left: 10),
              child: Text(
                "Fashion App",
                style: TextStyle(
                    fontSize: 30,
                    color: Color(0XFF604FCD),
                    fontWeight: FontWeight.w400),
              ),
            ),
            Spacer(),
            SizedBox(
              height: size.height * .5,
              // color: Colors.blue,
              child: PageView(
                onPageChanged: pageChange,
                controller: pageController,
                physics: BouncingScrollPhysics(),
                children: [
                  Column(
                    children: const [
                      Text(
                        "Welcome",
                        style:
                            TextStyle(fontSize: 40, color: Color(0XFF604FCD)),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            wordSpacing: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        "Choose",
                        style: TextStyle(
                          fontSize: 40,
                          color: Color(0XFF604FCD),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            wordSpacing: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        "Order",
                        style: TextStyle(
                          fontSize: 40,
                          color: Color(0XFF604FCD),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.\nLorem Ipsum has been the industry's standard dummy text ever\nsince the 1500s, when an unknown printer took a galley of type and scrambled it to make\na type specimen book.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          wordSpacing: 8,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  3,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                              color: pageIndex == index
                                  ? const Color(0XFF604FCD)
                                  : const Color(0XFF604FCD).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          height: 10,
                          width: pageIndex == index ? 25 : 10,
                        ),
                      )),
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setBool("first", true);
                    Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Color(0XFF604FCD), fontSize: 18),
                  ),
                ),
                /*  const Text(
                  "Skip",
                  style: TextStyle(color: Color(0XFF604FCD), fontSize: 15),
                ), */
                MaterialButton(
                  height: 50,
                  minWidth: 150,
                  color: const Color(0XFF604FCD),
                  onPressed: () async {
                    if (pageIndex != 2) {
                      onNext(pageIndex + 1);
                    } else {
                      buttonText = "Get Started";
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setBool("first", true);
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
