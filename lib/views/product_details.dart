// ignore_for_file: unused_local_variable

import 'package:fashion_customer/model/cart_model.dart';
import 'package:flutter/material.dart';

import '../model/image_color_model.dart';
import '../model/product_model.dart';

List<CartModel> cartItems = [];

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;
  // final DocumentReference documentReference;
  const ProductDetails({
    Key? key,
    required this.productModel,
  }
      // this.documentReference,
      ) : super(key: key);
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late List<String> listOfImage = productModel.images.first.images;

  ProductModel get productModel => widget.productModel;
  Color selectedColor = Color(0xffffffff);
  // DocumentReference get documentReference => widget.documentReference;
  late String price = productModel.prices.first.colorPrice
      .firstWhere(
          (element) => element.colorName == productModel.images.first.colorName)
      .price;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('View Products'),
        ),
        body: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: PageView(
                              children: listOfImage
                                  .map((e) => Image.network(
                                        e,
                                        fit: BoxFit.contain,
                                      ))
                                  .toList()),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          margin: const EdgeInsets.only(top: 20, bottom: 30),
                          width: double.infinity,
                          height: 200,
                        ),
                        Text(
                          "Available Colors",
                          style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.grey,
                              letterSpacing: 1),
                        ),
                        SingleChildScrollView(
                          child: Row(
                              children: productModel.images
                                  .map((e) => customContainer(
                                      Color(e.colorCode), e.colorName))
                                  .toList()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          productModel.name.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.03,
                              color: Colors.grey,
                              letterSpacing: 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          productModel.description,
                          style: TextStyle(
                              fontSize: height * 0.02,
                              color: Colors.grey,
                              letterSpacing: 1),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              "The product comes in : ${productModel.quantity}${productModel.sizeUnit}of ${productModel.unit}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: height * 0.014,
                                  color: Colors.grey,
                                  letterSpacing: 1),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            // Text(productModel.unit)
                            // Text(
                            //   "Free Delivery",
                            //   style: TextStyle(
                            //       fontSize: height * 0.02,
                            //       color: Colors.grey,
                            //       letterSpacing: 1),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Rs $price",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.03,
                              color: Colors.grey,
                              letterSpacing: 1),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: width * 0.5,
                              child: cartItems.any((element) =>
                                      element.productId == productModel.id)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              int index = cartItems.indexOf(
                                                  cartItems.firstWhere(
                                                      (element) =>
                                                          element.productId ==
                                                          productModel.id));
                                              if (cartItems[index].quantity >
                                                  1) {
                                                double singleProdPrice =
                                                    cartItems[index].price /
                                                        cartItems[index]
                                                            .quantity;
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
                                            },
                                            icon: Icon(Icons.remove,
                                                color: Colors.white)),
                                        Text(
                                          cartItems
                                              .firstWhere((element) =>
                                                  element.productId ==
                                                  productModel.id)
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
                                                  cartItems.firstWhere(
                                                      (element) =>
                                                          element.productId ==
                                                          productModel.id));
                                              double singleProdPrice =
                                                  cartItems[index].price /
                                                      cartItems[index].quantity;

                                              setState(() {
                                                cartItems[index].quantity++;
                                                cartItems[index]
                                                    .price = cartItems[index]
                                                        .price +
                                                    singleProdPrice; /* cartItems[index].price +
                                          cartItems[index].price; */
                                              });
                                            },
                                            icon: Icon(Icons.add,
                                                color: Colors.white)),
                                      ],
                                    )
                                  : TextButton.icon(
                                      onPressed: () {
                                        cartItems.add(CartModel(
                                            image: listOfImage,
                                            name: productModel.name,
                                            price: double.parse(price),
                                            quantity: 1,
                                            productId: productModel.id,
                                            color: selectedColor.value,
                                            discountPrice: 100));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Product added to the cart")));

                                        setState(() {});
                                        // Navigator.pop(context);
                                      },
                                      icon: Image.asset('Icons/Bag.png',
                                          color: Colors.white),
                                      label: Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: height * 0.025,
                                            letterSpacing: 1),
                                      ),
                                    ),
                              decoration: BoxDecoration(
                                color: Color(0XFF604FCD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              /* margin: EdgeInsets.only(
                                top: height * 0.03,
                                bottom: 10,
                              ), */
                              //width: double.infinity,
                              height: kBottomNavigationBarHeight,
                            ),
                          ),
                        ),

                        // CustomListTile(
                        //   onTap: () async {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ProductDetails()));
                        //     // doc.data().images.forEach((element) async {
                        //     //   element.images.forEach((el) async {
                        //     //     Reference getRef =
                        //     //         await FirebaseStorage.instance.refFromURL(el);
                        //     //     await getRef.delete();
                        //     //   });
                        //     // });
                        //     // await doc.reference.delete();
                        //   },
                        //   title: doc.data().name,
                        //   subtitle: doc.data().description,

                        // ),
                      ])))
        ]));
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
      child: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(right: 15, top: 8, bottom: 8, left: 15),
            height: 80,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: color),
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
    );
  }
}
