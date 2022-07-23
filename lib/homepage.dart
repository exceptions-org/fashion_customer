import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/controller/cart_controller.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/carousel_model.dart';
import 'package:fashion_customer/model/category_model.dart';
import 'package:fashion_customer/utils/select_address_sheet.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:fashion_customer/views/custom_grid_view.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:fashion_customer/views/search_page.dart';
import 'package:fashion_customer/views/select_sub_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Widget carouselContainer(CarouselModel carouselModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          if (carouselModel.navigate.isNotEmpty) {
            List<String> data = carouselModel.navigate.split('|');
            if (data[0] == 'product') {
              DocumentSnapshot<ProductModel?> snap = await FirebaseFirestore
                  .instance
                  .collection('products')
                  .withConverter(
                      fromFirestore: (snapshot, options) =>
                          (snapshot.data() == null
                              ? null
                              : ProductModel.fromMap(snapshot.data()!)),
                      toFirestore: (ProductModel? v, o) => v?.toMap() ?? {})
                  .doc(data[1])
                  .get();
              if (snap.exists && snap.data() != null) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProductDetails(
                      productModel: snap.data()!,
                      notFromHome: false,
                    ),
                  ),
                );
              }
            } else {
              DocumentSnapshot<FetchCategoryModel?> snap =
                  await FirebaseFirestore.instance
                      .collection('admin')
                      .doc('categories')
                      .collection('categories')
                      .withConverter(
                          fromFirestore: (snapshot, options) => snapshot
                                      .data() ==
                                  null
                              ? null
                              : FetchCategoryModel.fromMap(snapshot.data()!),
                          toFirestore: (FetchCategoryModel? v, s) =>
                              v?.toMap() ?? {})
                      .doc(data[1])
                      .get();
              if (snap.exists && snap.data() != null) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SearchPage(
                      category: data[1],
                      isCategry: true,
                      subcategories: snap.data()!.subcategory,
                      onChange: (int) {},
                    ),
                  ),
                );
              }
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(carouselModel.imageUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  int page = 0;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void autoScrollPage() {
    if (timer != null) timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      this.timer = timer;
      if (pageIndex == page - 1) {
        pageController.animateToPage(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        pageController.animateToPage(pageIndex + 1,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFAFAFF),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58),
          child: CustomAppBar(
            isCenterTitle: false,
            title: "Fasheo",
            isaction: [
              InkWell(
                  onTap: () {
                    widget.onChange(2);
                  },
                  child: Obx(
                    () => Badge(
                        position: BadgePosition.topEnd(top: 3, end: -6),
                        badgeColor: KConstants.kPrimary100,
                        showBadge: cartController.cartItems.isNotEmpty,
                        badgeContent: Text(
                          cartController.cartItems.length.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Image.asset("Icons/Bag.png")),
                  )),
              InkWell(
                  onTap: () {
                    widget.onChange(3);
                  },
                  child: Image.asset("Icons/User.png")),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                        context: context, builder: (c) => SelectAddressSheet());
                    setState(() {});
                  },
                  child: Row(
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
                          controller.userModel.address.isEmpty
                              ? "Add Address"
                              : controller.seletedAddress != null
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
              ),
              const SizedBox(height: 20),
              Container(
                decoration: KConstants.defContainerDec,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(
                          0xff130B43,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    StreamBuilder<QuerySnapshot<FetchCategoryModel>>(
                        stream: FirebaseFirestore.instance
                            .collection('admin')
                            .doc('categories')
                            .collection('categories')
                            .withConverter(
                                fromFirestore: (snapshot, options) =>
                                    FetchCategoryModel.fromMap(
                                        snapshot.data()!),
                                toFirestore: (FetchCategoryModel v, s) =>
                                    v.toMap())
                            .orderBy('p')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Container(
                              width: size.width,
                              child: GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 7,
                                  childAspectRatio: 1 / 1.2,
                                  children: [
                                    ...(snapshot.data!.docs.length > 7
                                            ? snapshot.data!.docs.sublist(0, 7)
                                            : snapshot.data!.docs)
                                        .map((e) => InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            SearchPage(
                                                              onChange: widget
                                                                  .onChange,
                                                              category: e
                                                                  .data()
                                                                  .category
                                                                  .name,
                                                              isCategry: true,
                                                              subcategories: e
                                                                  .data()
                                                                  .subcategory,
                                                            )));
                                              },
                                              child: Column(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: e
                                                        .data()
                                                        .category
                                                        .imageUrl,
                                                    height: width * 0.12,
                                                    width: width * 0.12,
                                                  ),
                                                  SizedBox(
                                                    height: 12,
                                                  ),
                                                  Text(e.data().category.name),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(15))),
                                          context: context,
                                          builder: (c) => Scaffold(
                                            body: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      top: 50,
                                                      bottom: 10),
                                                  child:
                                                      Text('Select Category'),
                                                ),
                                                Divider(),
                                                GridView.count(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  childAspectRatio:
                                                      width / width * 0.9,
                                                  shrinkWrap: true,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 15,
                                                  crossAxisCount: 3,
                                                  children: snapshot.data!.docs
                                                      .map((e) => InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SelectSubCategory(
                                                                                onChange: widget.onChange,
                                                                                category: e.data().category.name,
                                                                                isCategry: true,
                                                                                subcategories: e.data().subcategory,
                                                                              )
                                                                      /*  SearchPage(
                                                                            onChange:
                                                                                widget.onChange,
                                                                            category:
                                                                                e.data().category.name,
                                                                            isCategry:
                                                                                true,
                                                                            subcategories:
                                                                                e.data().subcategory,
                                                                          ) */

                                                                      ));
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey)),
                                                              margin: EdgeInsets
                                                                  .all(10),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: Column(
                                                                children: [
                                                                  Image.network(e
                                                                      .data()
                                                                      .category
                                                                      .imageUrl),
                                                                  Spacer(),
                                                                  Text(e
                                                                      .data()
                                                                      .category
                                                                      .name)
                                                                ],
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                ),
                                                /*     ListView(
                                                  shrinkWrap: true,
                                                  children: snapshot.data!.docs
                                                      .map(
                                                        (e) => ListTile(
                                                          title: Text(
                                                            e
                                                                .data()
                                                                .category
                                                                .name,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                                context,
                                                                CupertinoPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SearchPage(
                                                                              onChange: widget.onChange,
                                                                              category: e.data().category.name,
                                                                              isCategry: true,
                                                                              subcategories: e.data().subcategory,
                                                                            )));
                                                          },
                                                        ),
                                                      )
                                                      .toList(),
                                                ), */
                                                SizedBox(
                                                  height: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'Icons/view_all.png',
                                            height: width * 0.12,
                                            width: width * 0.12,
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text('View All'),
                                        ],
                                      ),
                                    ),
                                  ]),
                            );
                          }
                          return Container();
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FutureBuilder<QuerySnapshot<CarouselModel>>(
                    future: FirebaseFirestore.instance
                        .collection('carousel')
                        .withConverter(
                            fromFirestore: (snapshot, options) =>
                                CarouselModel.fromMap(snapshot.data()!),
                            toFirestore: (CarouselModel v, s) => v.toMap())
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          page = snapshot.data!.docs.length;
                          autoScrollPage();
                          return SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                AspectRatio(
                                    aspectRatio: 3.2 / 1,
                                    child: PageView(
                                      onPageChanged: onPageChange,
                                      controller: pageController,
                                      scrollDirection: Axis.horizontal,
                                      children: snapshot.data!.docs
                                          .map((e) =>
                                              carouselContainer(e.data()))
                                          .toList(),
                                    )),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    snapshot.data!.docs.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: 10,
                                        width: pageIndex == index ? 15 : 10,
                                        decoration: BoxDecoration(
                                            color: pageIndex == index
                                                ? KConstants.kPrimary100
                                                : KConstants.kPrimary100
                                                    .withOpacity(.2),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                      return Container();
                    }),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: StreamBuilder<QuerySnapshot<ProductModel>>(
                  stream: productRefs
                      .orderBy("orderCount", descending: true)
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

                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          "No such Product Found",
                          style: TextStyle(fontSize: 50),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: CustomGridView(
                          onTap: () {
                            setState(() {});
                          },
                          products:
                              snapshot.data!.docs.map((e) => e.data()).toList(),
                        ),
                      );
                    }
                    return const Center(child: Text('Loading...'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
