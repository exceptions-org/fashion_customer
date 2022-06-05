// ignore_for_file: unused_local_variable
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/cart_controller.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/review_model.dart';
import 'package:fashion_customer/model/user_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/review_card.dart';
import 'package:fashion_customer/utils/spHelper.dart';
import 'package:fashion_customer/views/cart_page.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:fashion_customer/views/reviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/image_color_model.dart';
import '../model/product_model.dart';
import '../utils/product_card.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;
  final bool notFromHome;

  const ProductDetails({
    Key? key,
    required this.productModel,
    required this.notFromHome,
  }
      ) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  void onPageChange(index) {
    pageIndex = index;
    setState(() {});
  }

  late List<String> listOfImage = productModel.images.first.images;

  late List<String> allImages = productModel.images
      .map((e) => e.images)
      .fold<List<String>>(
          [],
          (previousValue, element) =>
              previousValue..addAll(element.map((e) => e)));

  CartController cartController = getIt<CartController>();
  final PageController pageController = PageController();

  ProductModel get productModel => widget.productModel;
  late Color selectedColor = Color(productModel.images.first.colorCode);
  late List<String> sizes = productModel.sizeUnit.contains(',,')
      ? List.generate(
          int.parse(productModel.sizeUnit.split(',,').last) -
              int.parse(productModel.sizeUnit.split(',,').first) +
              1,
          (index) =>
              (index + int.parse(productModel.sizeUnit.split(',,').first))
                  .toString())
      : [];

  String size = '';
  late String price = productModel.prices.first.colorPrice
      .firstWhere(
          (element) => element.colorName == productModel.images.first.colorName)
      .price;

  int pageIndex = 0;

  BoxDecoration defContainerDec = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: KConstants.kBorderColor),
  );

  final UserController userController = getIt.get<UserController>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (sizes.isEmpty) {
      size = productModel.sizeUnit;
    }
    return WillPopScope(
      onWillPop: () async {
        if (widget.notFromHome) {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (c) => BottomNavigation()),
              (route) => false);
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
          bottomNavigationBar: SizedBox(
            height: kBottomNavigationBarHeight * 1.5,
            child: SizedBox(
              width: width,
              height: kBottomNavigationBarHeight * 1.5,
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: StreamBuilder<DocumentSnapshot<UserModel>>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(userController.userModel.number)
                              .withConverter(
                                  fromFirestore: (snapshot, options) =>
                                      UserModel.fromMap(snapshot.data()!),
                                  toFirestore: (UserModel userModel, o) =>
                                      userModel.toMap())
                              .snapshots(),
                          builder: (context, snapshot) {
                            bool hasAdded = snapshot.data
                                    ?.data()
                                    ?.wishList
                                    .contains(productModel.id) ??
                                false;
                            return InkWell(
                              onTap: () async {
                                if (hasAdded) {
                                  snapshot.data?.reference.update({
                                    'wishList': FieldValue.arrayRemove(
                                        [productModel.id])
                                  });
                                } else {
                                  snapshot.data?.reference.update({
                                    'wishList':
                                        FieldValue.arrayUnion([productModel.id])
                                  });
                                }
                                getIt<UserController>().getUser();
                              },
                              child: AnimatedContainer(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: hasAdded
                                              ? KConstants.kPrimary100
                                              : Colors.transparent)),
                                  color: hasAdded
                                      ? Colors.white
                                      : KConstants.kPrimary100,
                                ),
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    if (hasAdded)
                                      Icon(
                                        Icons.bookmark,
                                        color: KConstants.kPrimary100,
                                      )
                                    else
                                      Icon(Icons.bookmark_add_outlined,
                                          size: 20, color: Colors.white),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      hasAdded
                                          ? 'Remove from Wishlist'
                                          : 'Add To Wishlist',
                                      style: TextStyle(
                                          fontSize: height * 0.015,
                                          fontWeight: FontWeight.w600,
                                          color: hasAdded
                                              ? KConstants.kPrimary100
                                              : Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: FittedBox(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: cartController.isExist(
                                productModel.id, selectedColor.value, size)
                            ? FloatingActionButton.extended(
                                key: ValueKey(cartController.isExist(
                                    productModel.id,
                                    selectedColor.value,
                                    size)),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                label: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          cartController.decrement(
                                              productModel.id,
                                              size,
                                              selectedColor.value);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.remove,
                                            color: Colors.white)),
                                    Text(
                                      cartController
                                          .getCart(productModel.id, size,
                                              selectedColor.value)
                                          .quantity
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: height * 0.025,
                                          letterSpacing: 1),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          cartController.increment(
                                              productModel.id,
                                              size,
                                              selectedColor.value);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.add,
                                            color: Colors.white)),
                                  ],
                                ),
                              )
                            : FloatingActionButton.extended(
                                key: ValueKey(cartController.isExist(
                                    productModel.id,
                                    selectedColor.value,
                                    size)),
                                onPressed: () {
                                  if (sizes.isNotEmpty && size == '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Please select a size')));
                                    return;
                                  }
                                  cartController.addToCart(
                                      productModel.id,
                                      size,
                                      selectedColor.value,
                                      listOfImage,
                                      productModel.name,
                                      price,
                                      widget.productModel.images
                                          .firstWhere((element) =>
                                              element.colorCode ==
                                              selectedColor.value)
                                          .colorName);
                                  SPHelper().setCart(cartController.cartItems);
                                  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                                      SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                              "Product added to the cart")));

                                  setState(() {});
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                icon: Image.asset('Icons/Bag.png',
                                    color: Colors.white),
                                label: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: height * 0.02,
                                      letterSpacing: 1),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(58),
            child: CustomAppBar(
              isaction: [
                Icon(Icons.abc),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  Cartpage(onChange: onPageChange)));
                    },
                    child: Image.asset("Icons/Bag.png")),
              ],
              isCenterTitle: true,
              title: "Product Details",
              isleading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "Icons/Arrow.png",
                  color: KConstants.kPrimary100,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                          controller: pageController,
                          onPageChanged: (value) {
                            String selectedImage = allImages[value];
                            selectedColor = Color(productModel.images
                                .firstWhere((element) => element.images
                                    .any((element) => element == selectedImage))
                                .colorCode);
                            setState(() {
                              pageIndex = value;
                            });
                          },
                          children: allImages
                              .mapIndexed((i, e) => InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          CupertinoPageRoute(builder: (C) {
                                        PageController controller =
                                            PageController(initialPage: i);
                                        return Scaffold(
                                          body: SafeArea(
                                            child: StatefulBuilder(
                                                builder: (context, setState) {
                                              ImageColorModel imageColorModel =
                                                  productModel.images
                                                      .firstWhere((element) =>
                                                          element.colorCode ==
                                                          selectedColor.value);
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18.0),
                                                    child: AnimatedSwitcher(
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      key: UniqueKey(),
                                                      child: Hero(
                                                        tag:
                                                            selectedColor.value,
                                                        child: Card(
                                                          color: selectedColor,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                    vertical:
                                                                        8),
                                                            child: Text(
                                                              imageColorModel
                                                                  .colorName
                                                                  .toTitleCase(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: PageView(
                                                        controller: controller,
                                                        onPageChanged: (value) {
                                                          String selectedImage =
                                                              allImages[value];
                                                          selectedColor = Color(productModel
                                                              .images
                                                              .firstWhere((element) => element
                                                                  .images
                                                                  .any((element) =>
                                                                      element ==
                                                                      selectedImage))
                                                              .colorCode);
                                                          setState(() {
                                                            pageIndex = value;
                                                          });
                                                          this.setState(() {});
                                                        },
                                                        children: allImages
                                                            .map(
                                                              (e) => Center(
                                                                child:
                                                                    InteractiveViewer(
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: e,
                                                                    progressIndicatorBuilder:
                                                                        (context,
                                                                            url,
                                                                            downloadProgress) {
                                                                      return Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          value:
                                                                              downloadProgress.progress,
                                                                          strokeWidth:
                                                                              2,
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation(KConstants.kPrimary100),
                                                                        ),
                                                                      );
                                                                    },
                                                                    width:
                                                                        width,
                                                                    height:
                                                                        height,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                            .toList()),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                        );
                                      }));
                                    },
                                    child: SizedBox(
                                      width: width,
                                      child: InteractiveViewer(
                                        child: CachedNetworkImage(
                                          imageUrl: e,
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        KConstants.kPrimary100),
                                              ),
                                            );
                                          },
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        allImages.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 7,
                            width: pageIndex == index ? 18 : 7,
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
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: KConstants.kBorderColor)),
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: defContainerDec,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Colors",
                      style: TextStyle(
                          fontSize: height * 0.02,
                          color: KConstants.txtColor100,
                          letterSpacing: 1),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: productModel.images
                              .mapIndexed((i, e) => customContainer(
                                  Color(e.colorCode), e.colorName, i))
                              .toList()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      productModel.name.toTitleCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02,
                          color: KConstants.textColor50,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Rs $price",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.025,
                              color: KConstants.txtColor75,
                              letterSpacing: 1),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Rs ${productModel.highPrice}",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.w600,
                              fontSize: height * 0.018,
                              color: Colors.red,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: width,
                decoration: defContainerDec,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "You can directly buy it from the store",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02,
                          color: KConstants.txtColor100,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          child: Text(
                            "Rabia Masjid, Mangal Bazaar Slap, Bhiwandi",
                            style: TextStyle(
                                fontSize: height * 0.015,
                                color: Colors.grey,
                                letterSpacing: 1),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              launchMap(
                                  'Rabia Masjid, Mangal Bazaar Slap, Bhiwandi');
                            },
                            child: Text('View On Map')),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        launch("tel:${8286349316}");
                      },
                      child: Text(
                        "Contact No: 8286349316",
                        style: TextStyle(
                            fontSize: height * 0.015,
                            color: Colors.grey,
                            letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
              if (sizes.isNotEmpty)
                SizedBox(
                  height: 10,
                ),
              if (sizes.isNotEmpty)
                Container(
                  decoration: defContainerDec,
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Size",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.02,
                            color: KConstants.txtColor100,
                            letterSpacing: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: sizes
                              .map((e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        size = e;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      margin: EdgeInsets.all(4),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: size == e
                                            ? KConstants.kPrimary100
                                            : Colors.white,
                                        border: Border.all(
                                          color: size == e
                                              ? KConstants.kPrimary100
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      child: Text(e,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: size == e
                                                ? KConstants.textColor25
                                                : Colors.grey.shade600,
                                          )),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: width,
                decoration: defContainerDec,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Product Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02,
                          color: KConstants.txtColor100,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      productModel.description,
                      style: TextStyle(
                          fontSize: height * 0.015,
                          color: Colors.grey,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      size,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02,
                          color: KConstants.textColor50,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Brand : ${productModel.brand}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.015,
                          color: KConstants.textColor50,
                          letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Reviews',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.02,
                              color: KConstants.txtColor100,
                              letterSpacing: 1),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        ReviewScreen(productModel.id)));
                          },
                          child: Row(
                            children: [
                              Text('View All'),
                              RotatedBox(
                                quarterTurns: 2,
                                child: Image.asset(
                                  'Icons/Arrow.png',
                                  color: KConstants.txtColor75,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 04,
                  ),
                  StreamBuilder<QuerySnapshot<ReviewModel>>(
                    stream: FirebaseFirestore.instance
                        .collection("reviews")
                        .orderBy('createdAt', descending: true)
                        .where("productId", arrayContains: productModel.id)
                        .withConverter<ReviewModel>(
                            fromFirestore: (snapshot, options) =>
                                ReviewModel.fromMap(snapshot.data()!),
                            toFirestore: (reviews, options) => reviews.toMap())
                        .limit(3)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text('No Reviews Yet'),
                          );
                        }

                        return Column(
                            children: snapshot.data!.docs
                                .map((e) => ReviewCard(reviewModel: e.data()))
                                .toList());
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Related Products',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02,
                          color: KConstants.txtColor100,
                          letterSpacing: 1),
                    ),
                  ),
                  SizedBox(
                    height: 04,
                  ),
                  StreamBuilder<QuerySnapshot<ProductModel>>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .where('category.name',
                              isEqualTo: widget.productModel.category.name)
                          .withConverter<ProductModel>(
                              fromFirestore: (snapshot, options) =>
                                  ProductModel.fromMap(snapshot.data()!),
                              toFirestore: (product, options) =>
                                  product.toMap())
                          .limit(10)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AnimationLimiter(
                            child: GridView.count(
                              childAspectRatio: 1 / 1.2,
                              shrinkWrap: true,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              crossAxisCount: 2,
                              physics: NeverScrollableScrollPhysics(),
                              children: snapshot.data!.docs
                                  .where((element) =>
                                      element.data().id !=
                                      widget.productModel.id)
                                  .mapIndexed((i, element) =>
                                      AnimationConfiguration.staggeredGrid(
                                          duration: Duration(milliseconds: 300),
                                          columnCount: 2,
                                          position: i,
                                          child: ScaleAnimation(
                                            child: ProductCard(
                                                data: element.data()),
                                          )))
                                  .toList(),
                            ),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              ),
            ]),
          )),
    );
  }

  Widget customContainer(Color color, String colorName, int index) {
    return InkWell(
      onTap: () {
        ImageColorModel imageColorModel = productModel.images
            .firstWhere((element) => element.colorCode == color.value);
        int movingIndex = allImages.indexOf(imageColorModel.images.first);
        int diff = movingIndex - pageIndex;
        if (diff.isNegative) {
          diff = -diff;
        }
        Duration duration = movingIndex > 6
            ? Duration(milliseconds: 1500)
            : movingIndex > 3
                ? Duration(milliseconds: 700)
                : Duration(milliseconds: 300);
        pageController.jumpToPage(movingIndex);
        setState(() {
          selectedColor = color;

          price = productModel.prices.first.colorPrice
              .firstWhere(
                  (element) => element.colorName == imageColorModel.colorName)
              .price;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(3),
              decoration: ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(
                        width: 1,
                        color: color == selectedColor
                            ? KConstants.kPrimary100
                            : Colors.transparent)),
              ),
              child: Hero(
                tag: color.value,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: color,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Hero(
              tag: color.value.toString() + 'text',
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: AutoSizeText(
                  colorName.toTitleCase(),
                  maxFontSize: 14,
                  minFontSize: 12,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      color: color,
                      letterSpacing: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
