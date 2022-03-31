import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fashion_customer/views/contact_details.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/product_model.dart';

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
  CollectionReference productRefs =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFAFAFF),
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
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SignupPage2()));
                },
                child: Image.asset("Icons/Bag.png")),
          ],
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
                StreamBuilder<QuerySnapshot<ProductModel>>(
                  stream: productRefs
                      .orderBy("orderCount")
                      .withConverter<ProductModel>(
                          fromFirestore: (snapshot, options) =>
                              ProductModel.fromMap(snapshot.data()!),
                          toFirestore: (product, options) => product.toMap())
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("something went wrong"),
                      );
                    }
                    // if (snapshot.data!.docs.isEmpty) {
                    //   return Center(child: Text("No such Product Found"));
                    // }
                    if (snapshot.hasData && snapshot.data != null) {
                      // var productLength = snapshot.data!.docs.length;
                      if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          "No such Product Found",
                          style: TextStyle(fontSize: 50),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: GridView.count(
                          physics: BouncingScrollPhysics(),
                          childAspectRatio: 1 / 1.2,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: snapshot.data!.docs
                              .map((e) => e.data())
                              .map(
                                (data) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetails(productModel: data),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.blueGrey.shade100,
                                        // width: 1,
                                      ),
                                      // color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    // padding: const EdgeInsets.all(8),
                                    height: height * 0.25,

                                    width: width * 0.4,
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.max,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: height * 0.15,
                                          width: 142,
                                          // padding: const EdgeInsets.only(left: 10),
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            image: DecorationImage(
                                              image: NetworkImage(data
                                                  .images.first.images.first),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            data.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            "Rs. ${data.prices.first.colorPrice.first.price}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF604FCD),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        /* Container(
                                                height: 50,
                                                width: 162,
                                                decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                                                ),
                                                child: const Center(
                            child: Text(
                              "NameOfProduct",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                                                ),
                                              ), */
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(), /* (context, index) {
                  ProductModel data = snapshot.data.docs[index].data();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetails(productModel: data),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.blueGrey.shade100,
                          // width: 1,
                        ),
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: const EdgeInsets.all(10),
                      // padding: const EdgeInsets.all(8),
                      height: 200,
                      width: 162,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            width: 142,
                            // padding: const EdgeInsets.only(left: 10),
                            margin: const EdgeInsets.only(top: 10, left: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                image: NetworkImage(
                                    data.images.first.images.first),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              data.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              "Rs. ${data.prices.first.colorPrice.first.price}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF604FCD),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          /* Container(
                        height: 50,
                        width: 162,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            "NameOfProduct",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ), */
                        ],
                      ),
                    ),
                  );
                } */
                          // itemCount: productLength,
                        ),
                      );
                    }
                    return const Center(child: Text('Loading...'));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
