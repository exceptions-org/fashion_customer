import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pageIndex = 0;
  PageController pageController = PageController();
  void onPageChange(index) {
    pageIndex = index;
    setState(() {});
  }

  final List<Map<String, dynamic>> categories = [
    {'image': 'Icons/Bag.png', 'name': 'Lace'},
    {'image': 'Icons/Bag.png', 'name': 'Lace'},
    {'image': 'Icons/Bag.png', 'name': 'Lace'},
    {'image': 'Icons/Bag.png', 'name': 'Lace'},
    {'image': 'Icons/Bag.png', 'name': 'Lace'},
    {'image': 'Icons/Bag.png', 'name': 'Lace'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Fashio",
            style: TextStyle(
                fontSize: 30,
                color: Color(0XFF604FCD),
                fontWeight: FontWeight.w100),
          ),
          actions: [Image.asset("Icons/Bag.png")],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      foregroundImage: AssetImage(e['image']),
                                    ),
                                    Text(e['name'])
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 160,
                  child: PageView(
                    onPageChanged: onPageChange,
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: const Center(child: Text("first")),
                          decoration: BoxDecoration(
                            color: const Color(0XFF604FCD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: const Center(child: Text("second")),
                          decoration: BoxDecoration(
                            color: const Color(0XFF604FCD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: const Center(child: Text("third")),
                          decoration: BoxDecoration(
                            color: const Color(0XFF604FCD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: const Center(child: Text("fourth")),
                          decoration: BoxDecoration(
                            color: const Color(0XFF604FCD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 10,
                        width: pageIndex == index ? 15 : 10,
                        decoration: BoxDecoration(
                            color: pageIndex == index
                                ? const Color(0XFF604FCD)
                                : const Color(0XFF604FCD).withOpacity(.2),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Popular Products",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 5),
                /* GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1),
                  children: productModel
                      .map((e) => Container(
                            child: Column(
                              children: [
                                Image.network(
                                    'https://picsum.photos/250?image=1'),
                                Image.network(
                                    'https://picsum.photos/250?image=2'),
                                Image.network(
                                    'https://picsum.photos/250?image=3'),
                                Image.network(
                                    'https://picsum.photos/250?image=4'),
                                Text(e.name),
                                Text(e.price),
                              ],
                            ),
                          ))
                      .toList(),
                ) */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
