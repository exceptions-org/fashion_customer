// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/model/cart_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/spHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../model/image_color_model.dart';
import '../model/product_model.dart';
import '../utils/product_card.dart';

List<CartModel> cartItems = [];

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;
  final bool notFromHome;
  // final DocumentReference documentReference;
  const ProductDetails({
    Key? key,
    required this.productModel,
    required this.notFromHome,
  }
      // this.documentReference,
      ) : super(key: key);
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late List<String> listOfImage = productModel.images.first.images;
  String size = '';
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
  // DocumentReference get documentReference => widget.documentReference;
  late String price = productModel.prices.first.colorPrice
      .firstWhere(
          (element) => element.colorName == productModel.images.first.colorName)
      .price;

  int pageIndex = 0;

  BoxDecoration defContainerDec = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: KConstants.kBorderColor),
  );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
          floatingActionButton: SizedBox(
            height: 60,
            child: FittedBox(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: cartItems
                        .any((element) => element.productId == productModel.id)
                    ? FloatingActionButton.extended(
                        key: ValueKey(cartItems.any(
                            (element) => element.productId == productModel.id)),
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  int index = cartItems.indexOf(
                                      cartItems.firstWhere((element) =>
                                          element.productId ==
                                          productModel.id));
                                  if (cartItems[index].quantity > 1) {
                                    double singleProdPrice =
                                        cartItems[index].price /
                                            cartItems[index].quantity;
                                    setState(() {
                                      cartItems[index].quantity--;
                                      cartItems[index].price =
                                          cartItems[index].price -
                                              singleProdPrice;
                                    });
                                  } else {
                                    cartItems.removeAt(index);
                                    setState(() {});
                                  }
                                  SPHelper().setCart(cartItems);
                                },
                                icon: Icon(Icons.remove, color: Colors.white)),
                            Text(
                              cartItems
                                  .firstWhere((element) =>
                                      element.productId == productModel.id)
                                  .quantity
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: height * 0.025,
                                  letterSpacing: 1),
                            ),
                            IconButton(
                                onPressed: () {
                                  int index = cartItems.indexOf(
                                      cartItems.firstWhere((element) =>
                                          element.productId ==
                                          productModel.id));
                                  double singleProdPrice =
                                      cartItems[index].price /
                                          cartItems[index].quantity;

                                  setState(() {
                                    cartItems[index].quantity++;
                                    cartItems[index].price = cartItems[index]
                                            .price +
                                        singleProdPrice; /* cartItems[index].price +
                                        cartItems[index].price; */
                                  });
                                  SPHelper().setCart(cartItems);
                                },
                                icon: Icon(Icons.add, color: Colors.white)),
                          ],
                        ),
                      )
                    : FloatingActionButton.extended(
                        key: ValueKey(cartItems.any(
                            (element) => element.productId == productModel.id)),
                        onPressed: () {
                          if (sizes.isNotEmpty && size == '') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please select a size')));
                            return;
                          }
                          cartItems.add(CartModel(
                              image: listOfImage,
                              name: productModel.name,
                              price: double.parse(price),
                              quantity: 1,
                              productId: productModel.id,
                              color: selectedColor.value,
                              discountPrice: 100,
                              selectedSize: size));
                          SPHelper().setCart(cartItems);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Product added to the cart")));

                          setState(() {});
                          // Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        icon: Image.asset('Icons/Bag.png', color: Colors.white),
                        label: Text(
                          "Add to Cart",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.025,
                              letterSpacing: 1),
                        ),
                      ),
              ),
            ),
          ),
          /* Container(
            height: 70,
            width: width * 0.5,
            child: cartItems
                    .any((element) => element.productId == productModel.id)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            int index = cartItems.indexOf(cartItems.firstWhere(
                                (element) =>
                                    element.productId == productModel.id));
                            if (cartItems[index].quantity > 1) {
                              double singleProdPrice = cartItems[index].price /
                                  cartItems[index].quantity;
                              setState(() {
                                cartItems[index].quantity--;
                                cartItems[index].price =
                                    cartItems[index].price - singleProdPrice;
                              });
                            } else {
                              cartItems.removeAt(index);
                              setState(() {});
                            }
                            SPHelper().setCart(cartItems);
                          },
                          icon: Icon(Icons.remove, color: Colors.white)),
                      Text(
                        cartItems
                            .firstWhere(
                                (element) => element.productId == productModel.id)
                            .quantity
                            .toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.025,
                            letterSpacing: 1),
                      ),
                      IconButton(
                          onPressed: () {
                            int index = cartItems.indexOf(cartItems.firstWhere(
                                (element) =>
                                    element.productId == productModel.id));
                            double singleProdPrice = cartItems[index].price /
                                cartItems[index].quantity;
    
                            setState(() {
                              cartItems[index].quantity++;
                              cartItems[index].price = cartItems[index].price +
                                  singleProdPrice; /* cartItems[index].price +
                                    cartItems[index].price; */
                            });
                            SPHelper().setCart(cartItems);
                          },
                          icon: Icon(Icons.add, color: Colors.white)),
                    ],
                  )
                : TextButton.icon(
                    onPressed: () {
                      if (sizes.isNotEmpty && size == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select a size')));
                        return;
                      }
                      cartItems.add(CartModel(
                          image: listOfImage,
                          name: productModel.name,
                          price: double.parse(price),
                          quantity: 1,
                          productId: productModel.id,
                          color: selectedColor.value,
                          discountPrice: 100,
                          selectedSize: size));
                      SPHelper().setCart(cartItems);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Product added to the cart")));
    
                      setState(() {});
                      // Navigator.pop(context);
                    },
                    icon: Image.asset('Icons/Bag.png', color: Colors.white),
                    label: Text(
                      "Add to Cart",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: height * 0.025,
                          letterSpacing: 1),
                    ),
                  ),
            decoration: BoxDecoration(
              color: KConstants.kPrimary100,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            /* margin: EdgeInsets.only(
                          top: height * 0.03,
                          bottom: 10,
                        ), */
            //width: double.infinity,
          ), */
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            elevation: 1,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  'Icons/Arrow.png',
                  color: KConstants.kPrimary100,
                )),
            backgroundColor: Colors.white,
            title: const Text(
              'Product Details',
              style: TextStyle(color: KConstants.kPrimary100),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                          onPageChanged: (value) {
                            setState(() {
                              pageIndex = value;
                            });
                          },
                          children: listOfImage
                              .mapIndexed((i, e) => InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          CupertinoPageRoute(builder: (C) {
                                        PageController controller =
                                            PageController(initialPage: i);
                                        return Scaffold(
                                          body: PageView(
                                              controller: controller,
                                              children: listOfImage
                                                  .map(
                                                    (e) => Center(
                                                      child: InteractiveViewer(
                                                        child: Image.network(
                                                          e,
                                                          width: width,
                                                          height: height,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList()),
                                        );
                                      }));
                                    },
                                    child: InteractiveViewer(
                                      child: Image.network(
                                        e,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        listOfImage.length,
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
                      child: Row(
                          children: productModel.images
                              .map((e) => customContainer(
                                  Color(e.colorCode), e.colorName))
                              .toList()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      productModel.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02,
                          color: KConstants.textColor50,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Rs $price",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: height * 0.03,
                          color: KConstants.txtColor75,
                          letterSpacing: 1),
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
                                    child: Container(
                                      margin: EdgeInsets.all(4),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: size == e
                                                ? KConstants.kPrimary100
                                                : Colors.grey.shade600),
                                      ),
                                      child: Text(e,
                                          style: TextStyle(fontSize: 20)),
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Related Products',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.02,
                          color: KConstants.txtColor100,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 20,
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
                                childAspectRatio: 1 / 1.1,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                crossAxisCount: 2,
                                children: snapshot.data!.docs
                                    .where((element) =>
                                        element.data().id !=
                                        widget.productModel.id)
                                    .mapIndexed((i, element) =>
                                        AnimationConfiguration.staggeredGrid(
                                            duration:
                                                Duration(milliseconds: 300),
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
                        })
                  ],
                ),
              ),
            ]),
          )),
    );
  }

  // Padding(
  //   padding: const EdgeInsets.all(8.0),
  //   child: Padding(
  //     padding: const EdgeInsets.only(left: 20, right: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //               color: selectedColor,
  //               borderRadius: BorderRadius.circular(15)),
  //           margin: EdgeInsets.only(top: 20, bottom: 30),
  //           width: double.infinity,
  //           height: 200,
  //         ),
  //         Text(
  //           "Available Colors",
  //           style: TextStyle(
  //               fontSize: height * 0.02,
  //               color: Colors.grey,
  //               letterSpacing: 1),
  //         ),
  //         Row(
  //           children: [
  //             customContainer(Colors.amber),
  //             customContainer(Colors.grey)
  //           ],
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Text(
  //           "Gold Lace".toUpperCase(),
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: height * 0.03,
  //               color: Colors.grey,
  //               letterSpacing: 1),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Text(
  //           '''Gold Lace jsdkh sajkd juasdgdg jkawdty asdiumn uiydiuqwddb iodyiu  8wdy9y isidhydihd jhdiduhghgdiua d udiu sds duisds dusudg iugdisgdgiuu d d gddiugiugsaiuddgsiuuidgdaiuid d  dgduisadiudhdiua ''',
  //           style: TextStyle(
  //               fontSize: height * 0.02,
  //               color: Colors.grey,
  //               letterSpacing: 1),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           children: [
  //             Text(
  //               "Rs 320",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: height * 0.03,
  //                   color: Colors.grey,
  //                   letterSpacing: 1),
  //             ),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             Text(
  //               "Free Delivery",
  //               style: TextStyle(
  //                   fontSize: height * 0.02,
  //                   color: Colors.grey,
  //                   letterSpacing: 1),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   ),
  // ),
  Widget customContainer(Color color, String colorName) {
    return InkWell(
      onTap: () {
        ImageColorModel imageColorModel = productModel.images
            .firstWhere((element) => element.colorCode == color.value);
        setState(() {
          selectedColor = color;
          listOfImage = imageColorModel.images;
          price = productModel.prices.first.colorPrice
              .firstWhere(
                  (element) => element.colorName == imageColorModel.colorName)
              .price;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(5),
              decoration: ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(
                        width: 2,
                        color: color == selectedColor
                            ? KConstants.kPrimary100
                            : Colors.transparent)),
              ),
              child: CircleAvatar(
                radius: 18,
                /* margin:
                    const EdgeInsets.only(right: 15, top: 8, bottom: 8, left: 15), */
                /* height: 80,
                width: 50, */
                backgroundColor: color,
                /* decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color), */
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              colorName,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  color: color,
                  letterSpacing: 1),
            )
          ],
        ),
      ),
    );
  }
}
