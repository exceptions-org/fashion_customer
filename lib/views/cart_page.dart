import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashion_customer/controller/cart_controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/views/checkout_page.dart';
import 'package:fashion_customer/views/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cartpage extends StatefulWidget {
  final Function(int) onChange;
  const Cartpage({Key? key, required this.onChange}) : super(key: key);

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartController.getTotal();
    return Scaffold(
      backgroundColor: Color(0xffFAFAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58),
        child: CustomAppBar(
          isaction: [Icon(Icons.abc)],
          isCenterTitle: true,
          title: "Cart Page",
        ),
      ),
      body: Column(
        children: [
          if (cartController.cartItems.isNotEmpty)
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: cartController.cartItems
                    .map((e) => Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0XFFC8D5EF))),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffC8DFEF))),
                                    height: 120,
                                    width: 140,
                                    child: CachedNetworkImage(
                                        imageUrl: e.image.first),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.name.toTitleCase(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Price: ${e.price}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: KConstants.kPrimary100,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Size: ${e.selectedSize}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: KConstants.kPrimary100,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                              text: 'Color: ',
                                              children: [
                                                TextSpan(
                                                  text: e.colorName,
                                                  style: TextStyle(
                                                      color: Color(e.color)),
                                                ),
                                              ],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: KConstants.kPrimary100,
                                              )),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cartController.increment(
                                                      e.productId,
                                                      e.selectedSize,
                                                      e.color);
                                                  setState(() {});
                                                },
                                                child: Image.asset(
                                                  "Icons/add.png",
                                                  height: 25,
                                                  color: KConstants.kPrimary100,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                "${e.quantity}",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(height: 10),
                                              InkWell(
                                                onTap: () {
                                                  cartController.decrement(
                                                      e.productId,
                                                      e.selectedSize,
                                                      e.color);
                                                  setState(() {});
                                                },
                                                child: Image.asset(
                                                  "Icons/remove.png",
                                                  height: 25,
                                                  color: KConstants.kPrimary100,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ))
                    .toList(),
              ),
            )
          else
            Expanded(
                flex: 7,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "Icons/empty-cart.png",
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            widget.onChange(0);
                          },
                          child: Text.rich(
                            TextSpan(
                                text: 'No items in cart ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                children: [
                                  TextSpan(
                                    text: 'Start Shopping',
                                    style: TextStyle(
                                        color: KConstants.kPrimary100,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                          ))
                    ],
                  ),
                )),
          if (cartController.cartItems.isEmpty) Spacer(flex: 1),
          if (cartController.cartItems.isNotEmpty)
            Container(
              height: 50,
              width: double.maxFinite,
              color: KConstants.kPrimary100,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price: ${cartController.cartItems.map((e) => e.price).reduce((a, b) => a + b)}",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Container(
                      height: 40,
                      width: 2,
                      color: Colors.grey.withOpacity(.3),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => CheckoutPage(
                              totalAmount: totalAmount,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "CheckOut",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
