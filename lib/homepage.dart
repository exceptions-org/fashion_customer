import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/category_model.dart';
import 'package:fashion_customer/utils/product_card.dart';
import 'package:fashion_customer/utils/select_address_sheet.dart';
import 'package:fashion_customer/views/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/product_model.dart';
import 'utils/constants.dart';

class HomePage extends StatefulWidget {
  final void Function(int) onChange;
  const HomePage({Key? key, required this.onChange}) : super(key: key);

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
    {'image': 'Icons/lace.png', 'name': 'Lace'},
    {'image': 'Icons/bangle.png', 'name': 'Bangle'},
    {'image': 'Icons/high-heels.png', 'name': 'High-heels'},
    {'image': 'Icons/handbag.png', 'name': 'Handbag'},
  ];
  CollectionReference productRefs =
      FirebaseFirestore.instance.collection('products');

  UserController controller = getIt<UserController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFAFAFF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: const Text(
            "Fashio",
            style: TextStyle(
              color: KConstants.kPrimary100,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            InkWell(
                onTap: () {
                  widget.onChange(2);
                  /*  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Cartpage())); */
                },
                child: Image.asset("Icons/Bag.png")),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                        context: context, builder: (c) => SelectAddressSheet());
                    setState(() {});
                  },
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 30,
                        color: Color(
                          0xff604FCD,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        width: width * 0.8,
                        child: AutoSizeText(
                          controller.seletedAddress != null
                              ? controller.seletedAddress!.actualAddress
                              : controller
                                  .userModel.address.first.actualAddress,
                          textScaleFactor: 1.0,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff130B43),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(
                        0xff130B43,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                FutureBuilder<QuerySnapshot<FetchCategoryModel>>(
                    future: FirebaseFirestore.instance
                        .collection('admin')
                        .doc('categories')
                        .collection('categories')
                        .withConverter(
                            fromFirestore: (snapshot, options) =>
                                FetchCategoryModel.fromMap(snapshot.data()!),
                            toFirestore: (FetchCategoryModel v, s) => v.toMap())
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Wrap(
                          children: snapshot.data!.docs
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    SearchPage(
                                                      onChange: (i) {},
                                                      category: e
                                                          .data()
                                                          .category
                                                          .name,
                                                      isCategry: true,
                                                    )));
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: size.height * 0.065,
                                            width: size.height * 0.065,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: KConstants.kPrimary100,
                                              ),
                                            ),
                                            child: Image.network(
                                                e.data().category.imageUrl),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(e.data().category.name),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        );
                      }
                      return Container();
                    }),
                /*  SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 100,
                    width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: categories
                          .map((e) => Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: KConstants.kPrimary100,
                                      ),
                                    ),
                                    child: Image.asset(e['image']),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(e['name'])
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ), */
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
                            color: KConstants.kPrimary100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: const Center(child: Text("second")),
                          decoration: BoxDecoration(
                            color: KConstants.kPrimary100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: const Center(child: Text("third")),
                          decoration: BoxDecoration(
                            color: KConstants.kPrimary100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: const Center(child: Text("fourth")),
                          decoration: BoxDecoration(
                            color: KConstants.kPrimary100,
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
                                ? KConstants.kPrimary100
                                : KConstants.kPrimary100.withOpacity(.2),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Products",
                        style: TextStyle(fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onChange(1);
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) => SearchPage()));
                        },
                        child: Text(
                          "View More",
                          style: TextStyle(fontSize: 18, color: Colors.purple),
                        ),
                      ),
                    ],
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
                      .limit(6)
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
                              .map((data) => ProductCard(data: data))
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
                                color: KConstants.kPrimary100,
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
