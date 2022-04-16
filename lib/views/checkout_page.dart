import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_customer/bottom_navigation.dart';
import 'package:fashion_customer/controller/controller.dart';
import 'package:fashion_customer/main.dart';
import 'package:fashion_customer/model/order_model.dart';
import 'package:fashion_customer/utils/constants.dart';
import 'package:fashion_customer/utils/select_address_sheet.dart';
import 'package:fashion_customer/views/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final UserController controller = getIt<UserController>();
  @override
  Widget build(BuildContext context) {
    double subTotal = cartItems
        .map((e) => e.price)
        .reduce((value, element) => value + element);
    double deliveryCharge;
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (c) {
                return WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: AlertDialog(
                    content: Container(
                      height: MediaQuery.of(context).size.height / 4.5,
                      width: MediaQuery.of(context).size.height / 4.5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: CircularProgressIndicator(
                              color: KConstants.kPrimary100,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Placing Order',
                            style: TextStyle(
                                color: KConstants.kPrimary100, fontSize: 25),
                          )
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                );
              });
          QuerySnapshot orders =
              await FirebaseFirestore.instance.collection('orders').get();
          DocumentReference ref =
              await FirebaseFirestore.instance.collection('orders').add({});
          await ref.update(OrderModel(
            products: cartItems,
            orderDocId: ref.id,
            totalPrice: subTotal,
            deliveryDate: Timestamp.now(),
            totalDiscountPrice: 0,
            orderId: 'FASHION${orders.docs.length + 1}',
            orderState: OrderState.placed,
            createdAt: Timestamp.now(),
          ).toMap());
          cartItems.clear();
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (c) => BottomNavigation()),
              (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Order Placed Successfully',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: KConstants.kPrimary100,
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.all(20),
          height: 60,
          decoration: BoxDecoration(
            color: KConstants.kPrimary100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              "Place Order",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xffFAFAFF),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: KConstants.kPrimary100,
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Checkout',
          style: TextStyle(
            color: KConstants.kPrimary100,
          ),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: cartItems.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xffC8D5EF),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 120,
                          width: 140,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffC8D5EF),
                            ),
                          ),
                          child: Image.network(
                            cartItems[index].image.first,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItems[index].name,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              "Price: ${cartItems[index].price}",
                              style: TextStyle(
                                  color: Color(0xff604FCC),
                                  fontWeight: FontWeight.bold),
                            ),
                            if (cartItems[index].selectedSize != '') ...[
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "Selected Size: ${cartItems[index].selectedSize}",
                                style: TextStyle(
                                    color: Color(0xff604FCC),
                                    fontWeight: FontWeight.bold),
                              ),
                            ]
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              );
            },
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffC7D4EE),
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Deliver to',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                            context: context,
                            builder: (c) {
                              return SelectAddressSheet();
                            });
                        setState(() {});
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: KConstants.kPrimary100,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  controller.seletedAddress == null
                      ? controller.userModel.address.first.actualAddress
                      : controller.seletedAddress!.actualAddress,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xffC7D4EE),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff130B43),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff130B43),
                      ),
                    ),
                    Spacer(),
                    Text(
                      subTotal.toString(),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff130B43),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  children: [
                    Text(
                      'Delivery Charges',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff130B43),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Free',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff130B43),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xff130B43),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      subTotal.toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xff130B43),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
